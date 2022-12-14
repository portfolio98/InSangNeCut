//
//  ChoosePhotoViewController.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxGesture
import ReactorKit

final class ChoosePhotoViewController: UIViewController, View {
    typealias Reactor = ChoosePhotoReactor
    
    enum Reusable {
        static let choosePhoto = ReusableCell<ChoosePhotoCell>()
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        dispatch(reactor: reactor)
        render(reactor: reactor)
    }
    
    private func dispatch(reactor: Reactor) {
        disposeBag.insert {
            self.rx.viewWillAppear
                .map { _ in Reactor.Action.viewWillAppear }
                .bind(to: reactor.action)
            
            chevronBackwardBarButtonItem.rx.tap
                .map { _ in Reactor.Action.didTapBack }
                .bind(to: reactor.action)

            collectionView.rx.modelSelected(ChoosePhotoModel.self)
                .map(Reactor.Action.modelSelected)
                .bind(to: reactor.action)
            
            고르기완료버튼.rx.tap
                .map { _ in Reactor.Action.didTap고르기완료버튼 }
                .bind(to: reactor.action)
        }
    }
    
    private func render(reactor: Reactor) {
        disposeBag.insert {
            reactor.state.map { $0.isDismiss }
                .filter { $0 == true }
                .withUnretained(self)
                .bind { this, _ in
                    this.navigationController?.popViewController(animated: true)
                }
            
            reactor.state.map { $0.capturePhotos }
                .bind(to: collectionView.rx.items(Reusable.choosePhoto)) { index, item, cell in
                    cell.configureCell(for: item)
                }
            
            reactor.pulse(\.$isEnabledConfirmButton)
                .withUnretained(self)
                .bind { this, isValue in
                    this.고르기완료버튼.isEnabled = isValue
                    this.고르기완료버튼.updateBackgroundColor()
                }
            
            reactor.state.map { $0.isShowNext }
                .filter { $0 == true }
                .withUnretained(self)
                .bind { this, _ in
                    let photos = reactor.currentState.choosePhotos.map { model -> UIImage in
                        return model.image
                    }
                    let frameImage = reactor.currentState.frameImage
                    print("🩴 \(frameImage)")
                    let makeType = reactor.initialState.makeType
                    this.showNeCutViewController(frameImage: frameImage, photoImages: photos, makeType: makeType)
                }
        }
    }
    
    // MARK: - Initialize
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    // MARK: - UIComponents
    let chevronBackwardBarButtonItem = ChevronBackwardBarButtonItem(tintColor: .white)
    
    lazy var collectionView: UICollectionView = {
        let type = reactor?.initialState.makeType
        let layout = createLayout(type: type!)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .designSystem(.mainPurple)
        
        cv.register(Reusable.choosePhoto)
        
        return cv
    }()
    
    lazy var 고르기완료버튼: ConfirmButton = {
        $0.normalTitle = "네컷 만들러 가기"
        $0.normalTitleColor = .white
        $0.disabledTitle = "사진을 더 골라줘"
        $0.disabledTitleColor = .white
        $0.configure()
        return $0
    }(ConfirmButton())
}
