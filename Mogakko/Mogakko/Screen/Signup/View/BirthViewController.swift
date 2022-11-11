//
//  BirthViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class BirthViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = MDSNavigationBar(self).then {
        $0.backButtonIsHidden = false
    }
    
    private var titleLabel = UILabel().then {
        $0.text = "생년월일을 알려주세요"
        $0.font = MDSFont.Display1_R20.font
        $0.textColor = .black
    }
    
    private var yearTextField = MDSInputTextField().then {
        $0.placeholder = "1990"
        $0.type = .inactive
        $0.becomeFirstResponder()
    }
    
    private var yearLabel = UILabel().then {
        $0.text = "년"
        $0.textColor = .black
        $0.font = MDSFont.Title2_R16.font
    }
    
    private var monthTextField = MDSInputTextField().then {
        $0.placeholder = "1"
        $0.type = .inactive
    }
    
    private var monthLabel = UILabel().then {
        $0.text = "월"
        $0.textColor = .black
        $0.font = MDSFont.Title2_R16.font
    }
    
    private var dateTextField = MDSInputTextField().then {
        $0.placeholder = "1"
        $0.type = .inactive
    }
    
    private var dateLabel = UILabel().then {
        $0.text = "일"
        $0.textColor = .black
        $0.font = MDSFont.Title2_R16.font
    }
    
    private var nextButton = MDSButton().then {
        $0.text = "다음"
        $0.type = .disable
        $0.heightType = .h48
    }
    
    private let datePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko-KR")
    }
    
    // MARK: - Property
    
    private let disposeBag = DisposeBag()
    private let viewModel = BirthViewModel()

    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        networkMoniter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }

}

extension BirthViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(navigationBar, titleLabel, yearTextField, yearLabel, monthTextField, monthLabel, dateTextField, dateLabel, nextButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(124)
            make.centerX.equalToSuperview()
        }
        
        yearTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.leading.equalToSuperview().inset(Metric.margin)
            make.trailing.equalToSuperview().inset(279)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.centerY.equalTo(yearTextField.snp.centerY)
            make.leading.equalTo(yearTextField.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(260)
        }
        
        monthTextField.snp.makeConstraints { make in
            make.centerY.equalTo(yearTextField.snp.centerY)
            make.leading.equalTo(yearLabel.snp.trailing).offset(23)
            make.trailing.equalToSuperview().inset(157)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.centerY.equalTo(yearTextField.snp.centerY)
            make.leading.equalTo(monthTextField.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(138)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.centerY.equalTo(yearTextField.snp.centerY)
            make.leading.equalTo(monthLabel.snp.trailing).offset(23)
            make.trailing.equalToSuperview().inset(35)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(yearTextField.snp.centerY)
            make.leading.equalTo(dateTextField.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(yearTextField.snp.bottom).offset(72)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
        
        [yearTextField, monthTextField, dateTextField].forEach {
            $0.inputView = datePicker
            $0.tintColor = .clear
        }
    }
    
    func bind() {
        datePicker.rx.value
            .skip(1)
            .withUnretained(self)
            .bind { vc, date in
                vc.viewModel.changeDateToString(date)
                vc.viewModel.calculateAge(date)
            }
            .disposed(by: disposeBag)
        
        datePicker.rx.controlEvent([.valueChanged])
            .withUnretained(self)
            .bind { vc, _ in
                vc.yearTextField.type = .active
                vc.monthTextField.type = .active
                vc.dateTextField.type = .active
                
                vc.nextButton.type = .fill
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                if vc.viewModel.isValid.value {
                    UserDefaults.standard.set(vc.datePicker.date.toString(), forKey: Constant.UserDefaults.birth)
                    vc.navigationController?.pushViewController(EmailViewController(), animated: true)
                } else {
                    vc.showToast(message: "새싹스터디는 만 17세 이상만 사용할 수 있습니다.")
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.yearRelay
            .bind(to: yearTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.monthRelay
            .bind(to: monthTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dateRelay
            .bind(to: dateTextField.rx.text)
            .disposed(by: disposeBag)
    }
}
