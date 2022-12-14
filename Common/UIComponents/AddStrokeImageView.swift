//
//  AddImageView.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/29.
//

import UIKit
import SnapKit

final class AddStrokeImageView: UIImageView {
    
    // MARK: - Initailize
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.gray.cgColor
        borderLayer.lineDashPattern = [6,6]
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.path = UIBezierPath(roundedRect: self.frame, cornerRadius: 8).cgPath
        self.layer.addSublayer(borderLayer)
        
        let plusImageView = PlusImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        addSubview(plusImageView)
        self.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate final class PlusImageView: UIImageView {
    // MARK: - Initailize
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        self.image = UIImage(systemName: "plus") ?? UIImage()
        self.tintColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
