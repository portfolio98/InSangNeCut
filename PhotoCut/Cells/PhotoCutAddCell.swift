//
//  PhotoCutAddCell.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/28.
//

import UIKit
import SnapKit

final class PhotoCutAddCell: BaseCollectionViewCell {
    var item: PhotoCutModel?
    
    func configureCell(model: PhotoCutModel) {
        item = model
        
        imageView.image = model.image
    }
    
    override func initialize() {
        configureUI()
    }
    
    // MARK: - UIComponents
    lazy var imageView: UIImageView = {
        
        return $0
    }(UIImageView())
    
    lazy var plusImageView: UIImageView = {
        $0.image = UIImage(systemName: "plus") ?? UIImage()
        
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    private func configureUI() {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.lineDashPattern = [6,6]
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.path = UIBezierPath(roundedRect: contentView.frame, cornerRadius: 8).cgPath
        borderLayer.lineWidth = 2
        contentView.layer.addSublayer(borderLayer)
        
        contentView.addSubview(plusImageView)
        plusImageView.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.center.equalToSuperview()
        }
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
