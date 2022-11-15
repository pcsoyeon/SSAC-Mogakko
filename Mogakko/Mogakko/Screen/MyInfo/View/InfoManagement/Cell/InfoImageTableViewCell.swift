//
//  InfoBackgroundTableViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/15.
//

import UIKit

final class InfoImageTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    var item: InfoManagementItem? {
        didSet {
            guard let item = item as? ImageItem else { return }
            backgroundImageView.image = UIImage(named: "sesac_background_\(item.background)")
            sesacImageView.image = UIImage(named: "sesac_image\(item.sesac)")
        }
    }
    
    // MARK: - UI Property
    
    private let backgroundImageView = UIImageView().then {
        $0.makeRound()
    }
    
    private let sesacImageView = UIImageView()
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        contentView.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(backgroundImageView, sesacImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(Metric.margin)
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
            make.bottom.equalToSuperview()
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(35)
            make.centerX.equalToSuperview()
        }
    }
}
