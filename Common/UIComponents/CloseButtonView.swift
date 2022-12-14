//
//  CloseButton.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/29.
//

import UIKit

final class CloseButtonView: UIImageView {
    
    // MARK: - Initailize
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.image = UIImage(systemName: "xmark.circle")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
