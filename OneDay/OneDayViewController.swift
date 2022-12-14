//
//  OneDayViewController.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/07.
//

import UIKit
import ReactorKit

final class OneDayViewController: UIViewController, View {
    typealias Reactor = OneDayReactor
    var disposeBag = DisposeBag()

    enum Reusable {
        static let photoCutAddCell = ReusableCell<PhotoCutAddCell>()
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        dispatch(reactor: reactor)
        render(reactor: reactor)
    }

    private func dispatch(reactor: Reactor) {
        disposeBag.insert {

        }
    }

    private func render(reactor: Reactor) {
        disposeBag.insert {

        }
    }

    // MARK: - Initialize
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIComponents
    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.backgroundColor = .clear
        cv.register(Reusable.photoCutAddCell)
        
        return cv
    }()

}

final class OneDayReactor: Reactor {
    enum Action {

    }

    enum Mutation {

    }

    struct State {

    }

    var initialState: State
    init(initialState: State) {
        self.initialState = initialState
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {

        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {

        }
    }
}

extension OneDayViewController {
    func configureUI() {
        view.backgroundColor = .designSystem(.mainPoint)//.withAlphaComponent(0.3)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection in
            
            return self.configurePhotoChooseSection()
        }
    }
    
    private func configurePhotoChooseSection() -> NSCollectionLayoutSection {
        
        let fraction: CGFloat = 1
        let inset: CGFloat = 6.5
            
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                            heightDimension: .fractionalHeight(1.0)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                         heightDimension: .fractionalWidth(fraction)),
                                                       subitems: [item])
        group.contentInsets = .init(top: inset, leading: 0, bottom: inset, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
