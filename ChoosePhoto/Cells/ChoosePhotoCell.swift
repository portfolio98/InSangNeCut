//
//  ChoosePhotoCell.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/27.
//

import UIKit

final class ChoosePhotoCell: BaseCollectionViewCell {
    var model: ChoosePhotoModel?
    
    func configureCell(for item: ChoosePhotoModel) {
        self.model = item
        guard let model else { return }
        imageView.image = model.image
        
        if let order = model.chooseOrder {
            chooseOrderLabel.isHidden = false
            chooseOrderLabel.text = "\(order)"
            imageView.alpha = 0.5
        } else {
            chooseOrderLabel.isHidden = true
            imageView.alpha = 1.0
        }
    }
    
    // MARK: - Initialize
    override func initialize() {
        self.configureUI()
    }
    
    // MARK: - UIComponents
    var imageView: UIImageView = {
        return $0
    }(UIImageView())
    
    var chooseOrderLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.backgroundColor = .designSystem(.mainPoint)
        $0.isUserInteractionEnabled = false
        $0.isHidden = true
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        return $0
    }(UILabel())
    
    private func configureUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.addSubview(chooseOrderLabel)
        chooseOrderLabel.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(10)
            $0.width.height.equalTo(32)
        }
    }
}
