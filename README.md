## SeSAC Study Matching App
π± **μ§λλ₯Ό ν΅ν΄ μ£Όλ³μ μμΉλ€μ νμΈνκ³ , μ€ν°λλ₯Ό μμ²­ λ° 1:1 μ±νμ νλ μλΉμ€**

```
Service Level Project 
- μ€μ  μλ¬΄ νκ²½κ³Ό λμΌν νλ‘μΈμ€λ‘ μ§νλλ κ°μΈ νλ‘μ νΈ
- μλΉμ€ λ λ²¨μ API/κΈ°ν λͺμΈμμ λμμΈ λ¦¬μμ€λ₯Ό μ λ¬ λ°μμ μ± κ°λ° μ§ν
```
</br>

### Screen Shot
![Slide 16_9 - 2](https://user-images.githubusercontent.com/59593430/209462875-6c95a9a6-5cd1-4f78-9425-ffef1e0da78d.png)

</br>

### Term 
- 2022.11.07 ~ 2022.12.07

</br>

### Link
[π Notion Link](https://www.notion.so/38342edbb8fb4de19c018ed53601799e)

</br>

### Tool
- κΈ°ν λͺμΈμ : Conference 
- λμμΈ μμ€ν λ° UI : Figma
- μλ² API : Conference/Swagger 
- ν μ§μμλ΅ : Zep 

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
  - Login (μ νλ²νΈ λ‘κ·ΈμΈ/jwt Token)
- CompositionalLayout, DiffableDataSource 

</br>

### Trouble Shooting 
- ν ν° λ§λ£ (jwt token λ§λ£μ, 401 errorμ λν λμ)
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

- enumμΌλ‘ API Error λΆκΈ°μ²λ¦¬
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
            return "μ΄λ―Έ κ°μν μ μ μλλ€."
        case .invalidNickname:
            return "μ ν¨νμ§ μμ λλ€μμλλ€."
        case .invalidAuthorization:
            return "ν ν°μ΄ λ§λ£λμμ΅λλ€. λ€μ λ‘κ·ΈμΈ ν΄μ£ΌμΈμ."
        case .unsubscribedUser:
            return "μμ§ κ°μνμ§ μμ μ μ μλλ€."
        case .serverError:
            return "μλ² μλ¬μλλ€. μ μ ν μ΄μ©ν΄μ£ΌμΈμ."
        case .emptyParameters:
            return "request header/bodyλ₯Ό νμΈν΄μ£ΌμΈμ."
        }
    }
}
```

```
private func checkIdToken() {
        GenericAPI.shared.requestDecodableData(type: Login.self, router: UserRouter.login) { [weak self] response in
            print("κΈ°μ‘΄ - ", UserData.idtoken)
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
                            print("κ°±μ  - ", UserData.idtoken)
                            self.refreshToken(idtoken)
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                            return
                        }
                    }
                case .unsubscribedUser:
                    Helper.convertNavigationRootViewController(view: self.view, controller: NicknameViewController())
                case .serverError:
                    self.showToast(message: "μλ² λ΄λΆ μ€λ₯μλλ€. μ μ ν μ¬μΈμ¦ ν΄μ£ΌμΈμ.")
                case .emptyParameters:
                    self.showToast(message: "Client Error")
                }
                
            }
        }
    }
```

</br>

- λ΄ μνμ λ°λ₯Έ μ§λ νλ©΄ Floating Button νμ λ° νλ©΄μ ν λΆκΈ°μ²λ¦¬ 
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
                    // λ§€μΉ­μ€
                    let studyViewController = StudyViewController()
                    let searchViewController = SearchSesacViewController()
                    searchViewController.mapLatitude = vc.mapLatitude
                    searchViewController.mapLongitude = vc.mapLongitude
                    searchViewController.stateType = .matching
                    vc.navigationController?.pushViewControllers([studyViewController, searchViewController], animated: false)
                } else {
                    // λ§€μΉ­λ > μ±ννλ©΄μΌλ‘ μ΄λ
                    let viewController = ChatViewController()
                    vc.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
```

π€ λ€λΉκ²μ΄μμΌλ‘ νλ©΄μ΄ μ°κ²°λμ΄ μμ λ, νλ²μ μ¬λ¬ νλ©΄μ pushνκ³  μΆλ€λ©΄?
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

- λμ  λ μ΄μμ κ΅¬ν 
Card Typeμ λ°λΌμ λ³΄μ¬μ§λ μμκ° λ€λ₯΄λ―λ‘, enumμΌλ‘ caseλ₯Ό λλ μ κ΄λ¦¬ 
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
SLP νλ‘μ νΈλ₯Ό ν΅ν΄ μ€μ  μλΉμ€(νμ¬) κ·λͺ¨μ κΈ°ν, λμμΈ, μλ²λ₯Ό νμΈνκ³  κ·Έμ λ§κ² κΈ°μ  μ€νμ μ ν λ€ μΌμ μ λ§κ² νλ‘μ νΈλ₯Ό κ΅¬ννλ κ²½νμ ν  μ μμλ€. 
λͺ¨λ  κΈ°νκ³Ό λμμΈ, μλ²κ° νμ λ μνλ‘ κ°λ°μ μμν κ²μ΄ μλλΌ, κ°λ°μ μ§ννλ λμ€μ μλ²κ° λ³κ²½λκΈ°λ νκ³  κΈ°νμ΄ λ μΆκ°λκΈ°λ νλ μν© μμμ μ μ°νκ² λμ²νλ©° κ°λ°μ μ§ννλ€. μ΄ κ³Όμ  μμμ μ½λλ₯Ό μ¬μ¬μ©ν  μ μκ² λΆλ¦¬νλ κ²κ³Ό λ‘μ°ν κ°μ μ¬μ©νμ§ μμμΌ νλ€λ κ²μ κΉ¨λ¬μλ€. 

</br>

Figmaμ κΈ°νλͺμΈμλ₯Ό λ³΄λ©΄μ μ¬μ¬μ©ν  μ μλ λΆλΆλ€μ΄ μλ€λ©΄ λ°λ‘ λμμΈμμ€νμΌλ‘ κ΄λ¦¬νκ±°λ λͺ¨λΈλ‘ κ΄λ¦¬νλ μ μ°ν μ¬κ³ λ₯Ό λ°°μ λ€. νΉν, λΉμ·ν UIλ‘ λμλλ νλ©΄λ€μ΄ λ§μκΈ° λλ¬Έμ μ΅λν λΆλ¦¬ν΄μ enumμΌλ‘ caseλ₯Ό λλ  κ΄λ¦¬νμλ€. 

</br>

Firebase μ νλ²νΈ λ‘κ·ΈμΈ, WebSocketμ μ΄μ©ν 1:1 μ±ν, IAP λ±μ μλ‘μ΄ κΈ°λ₯/κΈ°μ μ κ΅¬ννλ©΄μ λ€μν κ³΅λΆλ₯Ό ν  μ μμλ€. </br>
μ±νμ κ²½μ° μμΌκ³Ό μΈμ  μ°κ²°μ νκ³  ν΄μ νλ©°, Realmμ κΈ°λ°μΌλ‘ μ±ν λ΄μ­μ μ μ₯ λ° λΆλ¬μ€κ³  λ€μ μλ‘μ΄ μ±νμ μΆκ°νλ λ±μ μ λ°μ μΈ νλ‘μΈμ€λ₯Ό λ°°μΈ μ μμλ€. 

</br>

μ½λλ₯Ό κΉλνκ² μμ±νλ κ²λ μ€μνμ§λ§, μ΄λ νλ‘μ νΈμ λ§μ°¬κ°μ§λ‘ κΈ°νμ΄ μκΈ° λλ¬Έμ λμμ΄ λκ³  μμ±λκ° μλ κ²°κ³Όλ¬Όμ λ΄μΌ νλ€λ μ λ μμ§ μμΌλ©΄μ μμμ μ§ννλ€.
κ·Έλ κΈ°μ, λμμ΄ λλλ‘ κ΅¬ννκ³  κ°μ νλ κ³Όμ μ λ°λ³΅νλ©΄μ μ§λλ₯Ό λκ°λ€. κ·ΈλΌμλ μ½λκ° λ μ λ¦¬λ λΆλΆλ€μ΄ μμ΄ μμ¬μμ΄ λ¨λλ€. 

