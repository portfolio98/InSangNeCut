//
//  PlaceHolderTextView.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/02.
//

import UIKit
import SnapKit

final class PlaceHolderTextView: BaseTextView {
    
    lazy var placeholderLabel: UILabel = {
        $0.text = "여러분의 추억에 기록을 남겨보아요."
        $0.textAlignment = .center
        $0.font = .pretendardFont(size: 14, style: .light)
        $0.textColor = .darkGray
        return $0
    }(UILabel())
    
    override func initialize() {
        self.layer.cornerRadius = 16
        self.layer.borderColor = UIColor.designSystem(.mainYellow).cgColor
        self.layer.borderWidth = 2
        self.backgroundColor = .designSystem(.mainYellow).withAlphaComponent(0.1)
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
