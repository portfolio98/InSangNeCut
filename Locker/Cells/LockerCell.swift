//
//  LockerCell.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/28.
//

import UIKit
import SnapKit

final class LockerCell: BaseCollectionViewCell {
    private var item: LockerModel?
    
    let fileManager = ImageFileManager.shared
    func configureCell(model: LockerModel, index: Int) {
        item = model
        
        // TODO: - 셀 재사용으로 인한 UI 이슈 - 더 예쁘게 개선할 수 있을탠데, 우선은 이렇게 임시 방편으로 처리해두자.
        guard let id = item?.id else { return }
        
        imageView.image = fileManager.getSavedImage(id: id)
    }
    
    // MARK: - Initialize
    override func initialize() {
        self.configureUI()
    }
    
    // MARK: - UIComponents
    lazy var imageView: UIImageView = {
        $0.layer.cornerRadius = 16
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private func configureUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

/*
 준형이 피드백:
 생성 완료시 만들어졌는지 피드백을 주는게 부족하다.
 뒤ㅏ로가기 버튼이 빠져있다.
 
 인생네컷 핸드폰만의 장점을 살리기
 */
