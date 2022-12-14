//
//  LockerViewController.Layout.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/28.
//

import UIKit

extension LockerViewController {
    func configureUI() {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.leftBarButtonItem = xmarkCircleBarButtonItem
        navigationItem.rightBarButtonItem = plusCircleBarButtonItem
        
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection in
            
            return self.configureDefaultLayout()
        }
    }
    
    private func configureDefaultLayout() -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1 / 3
        let inset: CGFloat = 2.5
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(fraction),
                                                            heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                         heightDimension: .fractionalWidth(fraction)),
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
