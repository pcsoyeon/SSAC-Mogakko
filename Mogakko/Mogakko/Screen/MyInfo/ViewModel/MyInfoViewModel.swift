//
//  MyInfoViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/13.
//

import Foundation

import RxCocoa
import RxSwift

final class MyInfoViewModel {
    lazy var info = BehaviorRelay<[MyInfo]>(value: [
        MyInfo(image: Constant.Image.profileImage, title: UserDefaults.standard.string(forKey: Constant.UserDefaults.nick)!),
        MyInfo(image: Constant.Image.notice, title: "공지사항"),
        MyInfo(image: Constant.Image.faq, title: "자주 묻는 질문"),
        MyInfo(image: Constant.Image.qna, title: "1:1 문의"),
        MyInfo(image: Constant.Image.settingAlarm, title: "알림 설정"),
        MyInfo(image: Constant.Image.permit, title: "이용 약관")
    ])
}
