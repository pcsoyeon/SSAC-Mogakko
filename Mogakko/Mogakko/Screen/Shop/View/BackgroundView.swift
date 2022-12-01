//
//  BackgroundView.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/30.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class BackgroundView: BaseView {
    
    // MARK: - UI Property
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
    
    private var collectionLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    // MARK: - Property
    
    private let sesac: [(Background, SesacPriceType)] = [(Background.skyPark, SesacPriceType.had),
                                                         (Background.cityView, SesacPriceType.price1200),
                                                         (Background.nightTrail, SesacPriceType.price1200),
                                                         (Background.dayTrail, SesacPriceType.price1200),
                                                         (Background.theater, SesacPriceType.price2500),
                                                         (Background.latin, SesacPriceType.price2500),
                                                         (Background.homeTraining, SesacPriceType.price2500),
                                                         (Background.musician, SesacPriceType.price2500)]
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        backgroundColor = .white
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.register(BackgroundCollectionViewCell.self, forCellWithReuseIdentifier: BackgroundCollectionViewCell.reuseIdentifier)
        
        collectionView.backgroundColor = .white
        
        let listObservable = Observable.of(sesac)
        listObservable.bind(to: collectionView.rx.items(cellIdentifier: BackgroundCollectionViewCell.reuseIdentifier, cellType: BackgroundCollectionViewCell.self)) { index, data, cell in
            let background = data.0
            let price = data.1
            
            cell.setBackgroundData(background)
            cell.setPriceData(price)
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalToSuperview()
        }
    }
}

extension BackgroundView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.frame.width - 16 - 16)
        let height = 165.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 16, bottom: 16, right: 16)
    }
}

