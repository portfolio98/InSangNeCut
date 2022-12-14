//
//  ChoosePhotoViewController.Layout.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/28.
//

import UIKit

extension ChoosePhotoViewController {
    func configureUI() {
        view.backgroundColor = .designSystem(.mainPurple)
        navigationItem.leftBarButtonItem = chevronBackwardBarButtonItem
        
        view.addSubview(고르기완료버튼)
        고르기완료버튼.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(50)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(고르기완료버튼.snp.top).offset(-10)
        }
    }
    
    func createLayout(type: NeCutMakeManager.NeCutMakeType) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection in
            return self.configurePhotoChooseSection(type: type)
        }
    }
    
    private func configurePhotoChooseSection(type: NeCutMakeManager.NeCutMakeType) -> NSCollectionLayoutSection {
        var groupFraction: CGFloat
        switch type {
        case .basic_frame_4x1, ._4by2, .basic_frame_4x1_mongle: groupFraction = 0.8
        case .basic_frame_1x1, .basic_frame_1x1_emoji: groupFraction = 1.0
        }
        
        let fraction: CGFloat = 1 / 2
        let inset: CGFloat = 2.5
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(fraction),
                                                            heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                         heightDimension: .fractionalWidth(fraction * groupFraction)),
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
