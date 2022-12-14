//
//  bottomConfimButton.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/28.
//

import UIKit

/**
 - Important: configure를 꼭 호출애야 합니다.
 
 */

class ConfirmButton: UIButton {
    
    var normalTitle: String = ""
    var normalTitleColor: UIColor?
//    var normalBackgroundColor: UIColor?
    
    var disabledTitle: String = ""
    var disabledTitleColor: UIColor?
    
    func configure() {
        let fontSize = UIFont.pretendardFont(size: 16, style: .semiBold)
        
        // MARK: - normal
        let normalAttr = NSMutableAttributedString(string: normalTitle)
        normalAttr.addAttribute(.font, value: fontSize, range: (normalTitle as NSString).range(of: normalTitle))
        self.setAttributedTitle(normalAttr, for: .normal)
        self.setTitleColor(normalTitleColor, for: .normal)
        
        // MARK: - disabled
        let disabledAttr = NSMutableAttributedString(string: disabledTitle)
        disabledAttr.addAttribute(.font, value: fontSize, range: (disabledTitle as NSString).range(of: disabledTitle))
        self.setAttributedTitle(disabledAttr, for: .disabled)
        self.setTitleColor(disabledTitleColor, for: .disabled)
        
        self.layer.cornerRadius = 16
        
        self.updateBackgroundColor()
    }
    
    func updateBackgroundColor() {
        switch self.state {
        case .normal:
            self.backgroundColor = .designSystem(.mainPoint)
        case .disabled:
            self.backgroundColor = .systemGray5
        default: assert(true, "배경 색 오류")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

