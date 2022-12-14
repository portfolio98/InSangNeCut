//
//  PhotoCutViewController.Layout.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/28.
//

import UIKit
import SnapKit

extension PhotoCutViewController {
    func configureUI() {
        view.backgroundColor = .designSystem(.mainBlue)//.withAlphaComponent(0.3)
        
        navigationItem.leftBarButtonItem = chevronBackwardBarButtonItem
        
        view.addSubview(고르기완료버튼)
        고르기완료버튼.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(50)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(100)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.bottom.equalTo(고르기완료버튼.snp.top).offset(-10)
        }
    }
    
    func createLayout(type: NeCutMakeManager.NeCutMakeType) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection in
            return self.configurePhotoChooseSection(type: type)
            
//            let type = self.reactor?.initialState.makeType
//            switch type {
//            case ._4by1: return self.configure315by208Layout()
//            case ._4by2: return self.configure315by208Layout()
//            default: return self.configure315by208Layout()
//            }
        }
    }
    
    private func configurePhotoChooseSection(type: NeCutMakeManager.NeCutMakeType) -> NSCollectionLayoutSection {
        var groupFraction: CGFloat
        switch type {
        case .basic_frame_4x1, ._4by2, .basic_frame_4x1_mongle: groupFraction = 0.8
        case .basic_frame_1x1, .basic_frame_1x1_emoji: groupFraction = 1.0
        }
        
        let fraction: CGFloat = 1
        let inset: CGFloat = 6.5
            
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                            heightDimension: .fractionalHeight(1.0)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                         heightDimension: .fractionalWidth(fraction * groupFraction)),
                                                       subitems: [item])
        group.contentInsets = .init(top: inset, leading: 0, bottom: inset, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
