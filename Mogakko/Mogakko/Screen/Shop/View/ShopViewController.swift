//
//  ShopViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/30.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class ShopViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = MDSNavigationBar(self).then {
        $0.backButtonIsHidden = true
        $0.title = "새싹샵"
    }
    
    private var backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "sesac_background_1")
        $0.makeRound()
        $0.clipsToBounds = true
    }
    
    private var sesacImageView = UIImageView().then {
        $0.image = UIImage(named: "sesac_face_1")
    }
    
    private var saveButton = MDSButton().then {
        $0.type = .fill
        $0.heightType = .h40
        $0.text = "저장하기"
    }
    
    private var scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private var contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.spacing = 0
    }
    
    private lazy var indicatorView = UIView().then {
        $0.addSubviews(sesacTitleButton, backgroundTitleButton, underLineView, indicatorLine)
    }
    
    private var sesacTitleButton = UIButton().then {
        $0.setTitle("새싹", for: .normal)
        $0.setTitleColor(.green, for: .normal)
        $0.titleLabel?.font = MDSFont.Title3_M14.font
    }
    
    private var backgroundTitleButton = UIButton().then {
        $0.setTitle("배경", for: .normal)
        $0.setTitleColor(.gray6, for: .normal)
        $0.titleLabel?.font = MDSFont.Title4_R14.font
    }
    
    private var indicatorLine = UIView().then {
        $0.backgroundColor = .green
    }
    
    private var underLineView = UIView().then {
        $0.backgroundColor = .gray2
    }
    
    private let sesacView = SesacView()
    private let backgroundView = BackgroundView()
    
    // MARK: - Property
    
    private let viewModel = ShopViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureAttribute()
        bind()
    }
}

extension ShopViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(navigationBar, backgroundImageView, indicatorView, scrollView)
        backgroundImageView.addSubviews(saveButton, sesacImageView)
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubviews(sesacView, backgroundView)
        
        // 네비게이션
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 새싹 배경 + 새싹 이미지
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
            make.height.equalTo(172)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.width.equalTo(80)
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(11)
            make.centerX.equalToSuperview()
        }
        
        // 인디케이터
        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(43)
        }
        
        sesacTitleButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.equalTo(view.frame.width / 2)
        }
        
        backgroundTitleButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.equalTo(view.frame.width / 2)
        }
        
        indicatorLine.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.leading.bottom.equalToSuperview()
            make.width.equalTo(view.frame.width / 2)
        }
        
        underLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        // 스크롤 뷰
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(indicatorView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        let views = [sesacView, backgroundView]
        
        contentStackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(views.count)
        }
        
        for view in views {
            view.snp.makeConstraints {
                $0.width.equalTo(scrollView.snp.width)
                $0.height.equalToSuperview()
            }
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .white
    }
    
    func bind() {
        scrollView.rx.didScroll
            .withUnretained(self)
            .map { vc, _ in
                return Int(vc.scrollView.contentOffset.x / vc.scrollView.frame.size.width)
            }
            .bind { [weak self] index in
                guard let self = self else { return }
                if index == 0 {
                    self.highlightedTitle(index: index, selectedButton: self.sesacTitleButton, deselectedButton: self.backgroundTitleButton)
                } else {
                    self.highlightedTitle(index: index, selectedButton: self.backgroundTitleButton, deselectedButton: self.sesacTitleButton)
                }
            }
            .disposed(by: disposeBag)
        
        sesacTitleButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            .disposed(by: disposeBag)
        
        backgroundTitleButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.scrollView.setContentOffset(CGPoint(x: vc.scrollView.frame.width, y: 0), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func highlightedTitle(index: Int, selectedButton: UIButton, deselectedButton: UIButton) {
        if index == 0 {
            UIView.animate(withDuration: 0.35) {
                self.indicatorLine.snp.updateConstraints { make in
                    make.leading.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.indicatorLine.snp.updateConstraints { make in
                    make.leading.equalToSuperview().inset(self.view.frame.width / 2)
                }
                self.view.layoutIfNeeded()
            }
        }
        
        selectedButton.setTitleColor(.green, for: .normal)
        selectedButton.titleLabel?.font = MDSFont.Title3_M14.font
        
        deselectedButton.setTitleColor(.gray6, for: .normal)
        deselectedButton.titleLabel?.font = MDSFont.Title4_R14.font
    }
}
