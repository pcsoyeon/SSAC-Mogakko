//
//  SesacView.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/30.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SesacView: BaseView {
    
    // MARK: - UI Property
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
    
    private var collectionLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    // MARK: - Property
    
    private let sesac: [(Sesac, SesacPriceType)] = [(Sesac.plain, SesacPriceType.had),
                                                    (Sesac.strong, SesacPriceType.price1200),
                                                    (Sesac.mint, SesacPriceType.price2500),
                                                    (Sesac.purple, SesacPriceType.price2500),
                                                    (Sesac.gold, SesacPriceType.price2500)]
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Method 
    
    override func configureAttribute() {
        backgroundColor = .white
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.register(SesacCollectionViewCell.self, forCellWithReuseIdentifier: SesacCollectionViewCell.reuseIdentifier)
        
        collectionView.backgroundColor = .white
        
        let listObservable = Observable.of(sesac)
        listObservable.bind(to: collectionView.rx.items(cellIdentifier: SesacCollectionViewCell.reuseIdentifier, cellType: SesacCollectionViewCell.self)) { index, data, cell in
            let sesac = data.0
            let price = data.1
            
            cell.setSesacData(sesac)
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

extension SesacView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.frame.width - 16 - 16 - 12) / 2
        let height = 279.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}

