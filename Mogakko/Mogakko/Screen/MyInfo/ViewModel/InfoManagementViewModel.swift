//
//  InfoManagementViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/13.
//

import Foundation

import FirebaseAuth
import RxCocoa
import RxSwift

final class InfoManagementViewModel {
    
    // MARK: - Property
    
    var gender = BehaviorRelay<Int>(value: 0)
    var study = BehaviorRelay<String>(value: "")
    var allowSearch = BehaviorRelay<Int>(value: 0)
    var ageMin = BehaviorRelay<Int>(value: 18)
    var ageMax = BehaviorRelay<Int>(value: 65)
    
    var info = PublishRelay<Login>()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input/Ouput
    
    struct Input {
        let viewWillAppear: Observable<[Any]>
        
        let saveButtonTap: ControlEvent<Void>
        let expandButtonTap: ControlEvent<Void>
        
        let manButtonTap: ControlEvent<Void>
        let womanButtonTap: ControlEvent<Void>
        
        let studyTextFieldText: ControlProperty<String?>
        
        let searchSwithchIsOn: ControlProperty<Bool>
        
        let withdrawTap: ControlEvent<Void>
    }
    
    struct Output {
        let info: PublishRelay<Login>
        
        let saveButtonTap: Observable<Void>
        let expandButtonTap: Driver<Void>
        
        let manButtonTap: Driver<Void>
        let womanButtonTap: Driver<Void>
        
        let studyTextFieldText: Observable<String>
        
        let searchSwithchIsOn: Driver<Bool>
        
        let withdrawTap: Driver<Void>
    }
    
    func transform(from input: Input) -> Output {
        input.viewWillAppear
            .withUnretained(self)
            .bind { vm, _ in
                vm.getUserInfo()
            }
            .disposed(by: disposeBag)
        
        let saveButtonTap = input.saveButtonTap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
        
        let expandButtonTap = input.expandButtonTap.asDriver()
        
        let manButtonTap = input.manButtonTap.asDriver()
        let womanButtonTap = input.womanButtonTap.asDriver()
        
        let textFieldText = input.studyTextFieldText.orEmpty.distinctUntilChanged()
        
        let allowSwitchIsOn = input.searchSwithchIsOn.asDriver()
        
        let withdrawButtonTap = input.withdrawTap.asDriver()
        
        return Output(info: info,
                      saveButtonTap: saveButtonTap,
                      expandButtonTap: expandButtonTap,
                      manButtonTap: manButtonTap,
                      womanButtonTap: womanButtonTap,
                      studyTextFieldText: textFieldText,
                      searchSwithchIsOn: allowSwitchIsOn,
                      withdrawTap: withdrawButtonTap)
    }
    
    // MARK: - Method
    
    func getUserInfo() {
        GenericAPI.shared.requestDecodableData(type: Login.self, router: UserRouter.login) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(let data):
                print("🍀 내 정보 관리 - 사용자 정보 \(data)")
                self.info.accept(data)
                
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
                    print("미가입회원")
                case .serverError:
                    print("서버오류")
                case .emptyParameters:
                    print("클라이언트오류")
                }
                
            }
        }
    }
    
    private func refreshToken(_ idtoken: String) {
        GenericAPI.shared.requestDecodableData(type: Login.self, router: UserRouter.refresh(idToken: idtoken)) { response in
            switch response {
            case .success(let data):
                UserData.nickName = data.nick
            case .failure(_):
                print("업데이트")
            }
        }
    }
}
