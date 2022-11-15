//
//  InfoBackgroundTableViewCell.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/15.
//

import UIKit

final class InfoImageView: BaseView {
    
    // MARK: - Property
    
    var item: InfoManagementItem? {
        didSet {
            guard let item = item as? ImageItem else { return }
            backgroundImageView.image = UIImage(named: "sesac_background_\(item.background)")
            sesacImageView.image = UIImage(named: "sesac_face_\(item.sesac)")
        }
    }
    
    // MARK: - UI Property
    
    private let backgroundImageView = UIImageView().then {
        $0.makeRound()
    }
    
    private let sesacImageView = UIImageView()
    
    // MARK: - UI Method
    
    override func configureAttribute() {
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        addSubviews(backgroundImageView)
        backgroundImageView.addSubview(sesacImageView)
        
        snp.makeConstraints { make in
            make.width.equalTo(self.frame.width)
            make.height.equalTo(210)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(Metric.margin)
            make.horizontalEdges.equalToSuperview().inset(Metric.margin)
            make.bottom.equalToSuperview()
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.width.height.equalTo(184)
            make.centerX.equalToSuperview()
        }
    }
}
