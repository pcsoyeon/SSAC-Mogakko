## SeSAC Study Matching App
🌱 **지도를 통해 주변의 새싹들을 확인하고, 스터디를 요청 및 1:1 채팅을 하는 서비스**

```
Service Level Project 
- 실제 업무 환경과 동일한 프로세스로 진행되는 개인 프로젝트
- 서비스 레벨의 API/기획 명세서와 디자인 리소스를 전달 받아서 앱 개발 진행
```
</br>

### Screen Shot
![Slide 16_9 - 2](https://user-images.githubusercontent.com/59593430/209462875-6c95a9a6-5cd1-4f78-9425-ffef1e0da78d.png)

</br>

### Term 
- 2022.11.07 ~ 2022.12.07

</br>

### Link
[🔗 Notion Link](https://www.notion.so/38342edbb8fb4de19c018ed53601799e)

</br>

### Tool
- 기획 명세서 : Conference 
- 디자인 시스템 및 UI : Figma
- 서버 API : Conference/Swagger 
- 팀 질의응답 : Zep 

</br>

### Stack (+ Library)
- MVC, MVVM(Input/Output) Pattern
- Swift, UIKit
- AutoLayout, Snapkit, Then
- RxSwift
- Alamofire (Alamofire+URLRequestConvertible)
- CLLocation, MapKit
- Firebase
  - Push Notification
  - Login (전화번호 로그인/jwt Token)
- CompositionalLayout, DiffableDataSource 

</br>

### Trouble Shooting 
- 토큰 만료 (jwt token 만료시, 401 error에 대한 대응)
```
    func refreshIdToken(completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let idToken = idToken else { return }
                UserData.idtoken = idToken
                completion(.success(idToken))
            }
        }
    }
```

</br>

- enum으로 API Error 분기처리
```
@frozen
enum APIError: Int, Error {
    case takenUser = 201
    case invalidNickname = 202
    case invalidAuthorization = 401
    case unsubscribedUser = 406
    case serverError = 500
    case emptyParameters = 501
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .takenUser:
            return "이미 가입한 유저입니다."
        case .invalidNickname:
            return "유효하지 않은 닉네임입니다."
        case .invalidAuthorization:
            return "토큰이 만료되었습니다. 다시 로그인 해주세요."
        case .unsubscribedUser:
            return "아직 가입하지 않은 유저입니다."
        case .serverError:
            return "서버 에러입니다. 잠시 후 이용해주세요."
        case .emptyParameters:
            return "request header/body를 확인해주세요."
        }
    }
}
```

```
private func checkIdToken() {
        GenericAPI.shared.requestDecodableData(type: Login.self, router: UserRouter.login) { [weak self] response in
            print("기존 - ", UserData.idtoken)
            guard let self = self else { return }
            
            switch response {
            case .success(let data):
                UserData.nickName = data.nick
                
                Helper.convertNavigationRootViewController(view: self.view, controller: TabBarViewController())
                
            case .failure(let error):
                switch error {
                case .takenUser, .invalidNickname:
                    return
                case .invalidAuthorization:
                    UserAPI.shared.refreshIdToken { result in
                        switch result {
                        case .success(let idtoken):
                            print("갱신 - ", UserData.idtoken)
                            self.refreshToken(idtoken)
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                            return
                        }
                    }
                case .unsubscribedUser:
                    Helper.convertNavigationRootViewController(view: self.view, controller: NicknameViewController())
                case .serverError:
                    self.showToast(message: "서버 내부 오류입니다. 잠시 후 재인증 해주세요.")
                case .emptyParameters:
                    self.showToast(message: "Client Error")
                }
                
            }
        }
    }
```

</br>

- 내 상태에 따른 지도 화면 Floating Button 타입 및 화면전환 분기처리 
```
enum MDSFloatingButtonType {
    case plain
    case matching
    case matched
    
    var image: UIImage {
        switch self {
        case .plain:
            return Constant.Image.search
        case .matching:
            return Constant.Image.antenna
        case .matched:
            return Constant.Image.message
        }
    }
}
```

```
            floatingButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                if vc.floatingButton.type == .plain {
                    let viewController = StudyViewController()
                    viewController.viewModel.mapLatitude.accept(vc.mapLatitude)
                    viewController.viewModel.mapLongitude.accept(vc.mapLongitude)
                    vc.navigationController?.pushViewController(viewController, animated: true)
                } else if vc.floatingButton.type == .matching {
                    // 매칭중
                    let studyViewController = StudyViewController()
                    let searchViewController = SearchSesacViewController()
                    searchViewController.mapLatitude = vc.mapLatitude
                    searchViewController.mapLongitude = vc.mapLongitude
                    searchViewController.stateType = .matching
                    vc.navigationController?.pushViewControllers([studyViewController, searchViewController], animated: false)
                } else {
                    // 매칭된 > 채팅화면으로 이동
                    let viewController = ChatViewController()
                    vc.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
```

🤔 네비게이션으로 화면이 연결되어 있을 때, 한번에 여러 화면을 push하고 싶다면?
```
extension UINavigationController {
    func pushViewControllers(_ inViewControllers: [UIViewController], animated: Bool) {
        var stack = self.viewControllers
        stack.append(contentsOf: inViewControllers)
        self.setViewControllers(stack, animated: animated)
    }
}
```
</br>

- 동적 레이아웃 구현 
Card Type에 따라서 보여지는 요소가 다르므로, enum으로 case를 나눠서 관리 
```
@frozen
enum CardViewType {
    case plain
    case info
}
```

</br>
</br>

### Retrospect
SLP 프로젝트를 통해 실제 서비스(회사) 규모의 기획, 디자인, 서버를 확인하고 그에 맞게 기술 스택을 정한 뒤 일정에 맞게 프로젝트를 구현하는 경험을 할 수 있었다. 
모든 기획과 디자인, 서버가 확정된 상태로 개발을 시작한 것이 아니라, 개발을 진행하는 도중에 서버가 변경되기도 하고 기획이 더 추가되기도 하는 상황 속에서 유연하게 대처하며 개발을 진행했다. 이 과정 속에서 코드를 재사용할 수 있게 분리하는 것과 로우한 값을 사용하지 않아야 한다는 것을 깨달았다. 

</br>

Figma와 기획명세서를 보면서 재사용할 수 있는 부분들이 있다면 따로 디자인시스템으로 관리하거나 모델로 관리하는 유연한 사고를 배웠다. 특히, 비슷한 UI로 동작되는 화면들이 많았기 때문에 최대한 분리해서 enum으로 case를 나눠 관리하였다. 

</br>

Firebase 전화번호 로그인, WebSocket을 이용한 1:1 채팅, IAP 등의 새로운 기능/기술을 구현하면서 다양한 공부를 할 수 있었다. </br>
채팅의 경우 소켓과 언제 연결을 하고 해제하며, Realm을 기반으로 채팅 내역을 저장 및 불러오고 다시 새로운 채팅을 추가하는 등의 전반적인 프로세스를 배울 수 있었다. 

</br>

코드를 깔끔하게 작성하는 것도 중요하지만, 어느 프로젝트와 마찬가지로 기한이 있기 때문에 동작이 되고 완성도가 있는 결과물을 내야 한다는 점도 잊지 않으면서 작업을 진행했다.
그렇기에, 동작이 되도록 구현하고 개선하는 과정을 반복하면서 진도를 나갔다. 그럼에도 코드가 덜 정리된 부분들이 있어 아쉬움이 남는다. 

