//
//  SearchSesacViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/19.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SearchSesacViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = MDSNavigationBar(self).then {
        $0.backButtonIsHidden = false
        $0.title = "새싹 찾기"
        $0.addSubview(stopButton)
    }
    
    private var stopButton = UIButton().then {
        $0.setTitle("찾기중단", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = MDSFont.Title3_M14.font
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
        $0.addSubviews(fromTitleLabel, requestedTitleLabel, underLineView, indicatorLine)
    }
    
    private var fromTitleLabel = UILabel().then {
        $0.text = "주변 새싹"
        $0.textColor = .green
        $0.textAlignment = .center
        $0.font = MDSFont.Title3_M14.font
    }
    
    private var requestedTitleLabel = UILabel().then {
        $0.text = "받은 요청"
        $0.textColor = .gray6
        $0.textAlignment = .center
        $0.font = MDSFont.Title4_R14.font
    }
    
    private var indicatorLine = UIView().then {
        $0.backgroundColor = .green
    }
    
    private var underLineView = UIView().then {
        $0.backgroundColor = .gray2
    }
    
    private let fromQueueView = FromQueueView()
    private let requestedView = RequestedView()
    
    // MARK: - Property
    
    private let viewModel = SearchSesacViewModel()
    private let disposeBag = DisposeBag()
    
    var mapLatitude = 0.0
    var mapLongitude = 0.0
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttribute()
        configureHierarchy()
        bind()
    }
}

extension SearchSesacViewController: BaseViewControllerAttribute {
    func configureAttribute() {
        view.backgroundColor = .white
    }
    
    func configureHierarchy() {
        view.addSubviews(navigationBar, indicatorView, scrollView)
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubviews(fromQueueView, requestedView)
        
        // 네비게이션
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        stopButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
        
        // 인디케이터
        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(43)
        }
        
        fromTitleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.equalTo(view.frame.width / 2)
        }
        
        requestedTitleLabel.snp.makeConstraints { make in
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
        
        let views = [fromQueueView, requestedView]
        
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
    
    func bind() {
        viewModel.requestSearch(request: SearchRequest(lat: mapLatitude, long: mapLongitude)) { error in
            if let error = error {
                print("error - \(error.errorDescription ?? "")")
            }
        }
        
        viewModel.fromQueue
            .withUnretained(self)
            .bind { vc, list in
                print("============ 주변 새싹 ============")
                dump(list)
                vc.fromQueueView.list.accept(list)
            }
            .disposed(by: disposeBag)
        
        viewModel.fromRequestedQueue
            .withUnretained(self)
            .bind { vc, list in
                print("============ 스터디를 요청한 새싹 ============")
                dump(list)
                
            }
            .disposed(by: disposeBag)
        
        scrollView.rx.didScroll
            .withUnretained(self)
            .map { vc, _ in
                return Int(vc.scrollView.contentOffset.x / vc.scrollView.frame.size.width)
            }
            .bind { [weak self] index in
                guard let self = self else { return }
                if index == 0 {
                    self.indicatorLine.snp.updateConstraints { make in
                        make.leading.equalToSuperview()
                    }
                    
                    self.fromTitleLabel.textColor = .green
                    self.fromTitleLabel.font = MDSFont.Title3_M14.font
                    self.requestedTitleLabel.textColor = .gray6
                    self.requestedTitleLabel.font = MDSFont.Title4_R14.font
                } else {
                    self.indicatorLine.snp.updateConstraints { make in
                        make.leading.equalToSuperview().inset(self.view.frame.width / 2)
                    }
                    
                    self.fromTitleLabel.textColor = .gray6
                    self.fromTitleLabel.font = MDSFont.Title4_R14.font
                    self.requestedTitleLabel.textColor = .green
                    self.requestedTitleLabel.font = MDSFont.Title3_M14.font
                }
            }
            .disposed(by: disposeBag)
    }
}
