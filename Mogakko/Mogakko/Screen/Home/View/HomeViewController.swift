//
//  HomeViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/11.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class HomeViewController: UIViewController {

    // MARK: - UI Property
    
    private var floatingButton = MDSFloatingButton().then {
        $0.type = .plain
    }
    
    private lazy var slider: MDSSlider = {
        let slider = MDSSlider()
        slider.minValue = 1
        slider.maxValue = 100
        slider.lower = 1
        slider.upper = 75
        slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        return slider
      }()
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        networkMoniter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttribute()
        configureHierarchy()
        bind()
    }
}

extension HomeViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(floatingButton, slider)
        
        floatingButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin)
        }
        
        slider.snp.makeConstraints {
              $0.height.equalTo(22)
              $0.width.equalTo(300)
              $0.center.equalToSuperview()
            }
    }
    
    func configureAttribute() {
        view.backgroundColor = .darkGray
    }
    
    func bind() {
        
    }
    
    @objc private func changeValue() {
        print("\(Int(self.slider.lower)) ~ \(Int(self.slider.upper))")
      }
}
