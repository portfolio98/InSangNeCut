//
//  ChooseFrameSectionFactory.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/05.
//

import UIKit
import SnapKit

final class ChooseFrmaeHeaderView: UICollectionReusableView {
    static let kind = "ChooseFrmaeHeaderView"
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIComponents
    lazy var headerLabel: BasePaddingLabel = {
        $0.backgroundColor = .designSystem(.mainPoint)//.withAlphaComponent(0.5)
        $0.textColor = .white
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.font = .pretendardFont(size: 14, style: .regular)
        $0.padding = .init(top: 5, left: 10, bottom: 5, right: 10)
        return $0
    }(BasePaddingLabel())
    
    private func configureUI() {
//        backgroundColor = .designSystem(.mainPoint).withAlphaComponent(0.5)
        addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
    }
}
