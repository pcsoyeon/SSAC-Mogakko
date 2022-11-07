//
//  BackButton.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/07.
//

import UIKit

import SnapKit

final class BackButton: UIButton {
                
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setLayout()
    }
    
    convenience init(root: UIViewController) {
        self.init()
        setAction(vc: root)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Method
    
    private func configureUI() {
        setImage(Constant.Image.arrow, for: .normal)
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.navigationButtonSize)
            make.leading.equalToSuperview().inset(Metric.navigationButtonLeading)
            make.bottom.equalToSuperview().inset(Metric.navigationButtonBottom)
        }
    }
    
    // MARK: - Custom Method
    
    private func setAction(vc: UIViewController) {
        let backAction = UIAction { action in
            vc.navigationController?.popViewController(animated: true)
        }
        self.addAction(backAction, for: .touchUpInside)
    }
}

