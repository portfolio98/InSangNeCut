//
//  ChooseFrameViewController.Layout.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/30.
//

import UIKit
import SnapKit

extension ChooseFrameViewController {
    // NOTE: - 나중에 프레임 많아지면 타임블럭스 스토어처럼 바꾸자
    // 카테고리는 계절마다, 학교마다, 기본, 파스텔 등 내가 원하는 것들로!
    func configureUI() {
        navigationItem.leftBarButtonItem = xmarkCircleBarButtonItem
        
        view.addSubview(고르기완료버튼)
        고르기완료버튼.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(50)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(고르기완료버튼.snp.top).offset(-10)
        }
        
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection in
            return self.configurePhotoFrameSection()
        }
    }
    
    private func configurePhotoFrameSection() -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1 / 4
        let inset: CGFloat = 2.5
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(fraction),
                                                            heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                         heightDimension: .fractionalWidth(fraction * 1.2)),
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                     elementKind: ChooseFrmaeHeaderView.kind,
                                                                     alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
        
        return section
    }
}
//https://applecider2020.tistory.com/38#%EC%98%88%EC%A0%9C-%EC%A2%85%EB%A5%98-4.-header-/-footer-%EA%B5%AC%ED%98%84
