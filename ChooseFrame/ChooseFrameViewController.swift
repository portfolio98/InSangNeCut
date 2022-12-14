//
//  ChooseFrameViewController.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/27.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxGesture
import RxDataSources

final class ChooseFrameViewController: UIViewController, View {
    typealias Reactor = ChooseFrameReactor
    
    enum Reusable {
        static let headerView = ReusableView<ChooseFrmaeHeaderView>()
        static let chooseFrame = ReusableCell<ChooseFrameCell>()
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    lazy var dataSource = UICollectionViewDiffableDataSource<ChooseFrameModel.Category, ChooseFrameReactor.Item>(
        collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            
            let section = ChooseFrameModel.Category(rawValue: indexPath.section)
            
            // NOTE: - 추후에 모델을 여러개도 다변화 가능해서 우선 학장성 고려해 설계해두기
            var value: ChooseFrameModel
            switch itemIdentifier {
            case .basicFrame1x1(let item): value = item
            case .basicFrame4x1(let item): value = item
            case .basicFrame4x1Emoji(let item): value = item
            case .basicFrame4x1Mongle(let item): value = item
            }
            
            switch section {
            default:
                let cell = collectionView.dequeue(Reusable.chooseFrame, for: indexPath)
                cell.configureCell(for: value)
                
                cell.frameImageView.rx.gesture(.tap())
                    .when(.recognized)
                    .map { _ in
                        Reactor.Action.didTapCellGesture(cell.model!)
                    }
                    .bind(to: self.reactor!.action)
                    .disposed(by: self.disposeBag)
                
                return cell
            }
        }
    // MARK: - Binding
    func bind(reactor: Reactor) {
        dispatch(reactor: reactor)
        render(reactor: reactor)
    }
    
    private func dispatch(reactor: Reactor) {
        disposeBag.insert {
            self.rx.viewDidLoad
                .map { _ in Reactor.Action.viewDidLoad }
                .bind(to: reactor.action)
            
            self.rx.viewWillAppear
                .map { _ in Reactor.Action.viewWillAppear }
                .bind(to: reactor.action)
            
            xmarkCircleBarButtonItem.rx.tap
                .map { _ in Reactor.Action.didTap나가기버튼뷰 }
                .bind(to: reactor.action)
            
            고르기완료버튼.rx.tap
                .map { _ in Reactor.Action.고르기완료버튼 }
                .bind(to: reactor.action)
        }
    }
    
    private func render(reactor: Reactor) {
        
        disposeBag.insert {
            reactor.state.map { $0.nextViewType }
                .withUnretained(self)
                .bind { this, type in
                    switch type {
                    case .카메라: this.xmarkCircleBarButtonItem.tintColor = .designSystem(.mainPurple)
                    case .포토컷: this.xmarkCircleBarButtonItem.tintColor = .designSystem(.mainBlue)
                    }
                }
            
            reactor.state.map { $0.snapshot }
                .withUnretained(self)
                .bind { this, snapshot in
                    this.dataSource.apply(snapshot, animatingDifferences: false)
                    // TODO: - 헤더에 파라미터로 다르게 처리하기
                    this.heaher()
                }
            
            reactor.pulse(\.$showsNextView)
                .filter { $0 == true }
                .withUnretained(self)
                .bind { this, _ in
                    let nextViewType = reactor.initialState.nextViewType
                    this.showNextView(nextViewType: nextViewType)
                }
            
            reactor.state.map { $0.isDismiss }
                .filter { $0 == true }
                .withUnretained(self)
                .bind { this, _ in this.dismiss(animated: true) }
        }
    }
    
    // MARK: - Function
    private func showNextView( nextViewType: Reactor.State.NextViewType) {
        let frameImage = reactor?.currentState.chooseFrameModelItem
        
        switch nextViewType {
        case .카메라:
            self.showCameraViewController(frameImage: frameImage!.image, makeType: frameImage!.makeType)
        case .포토컷:
            self.showPhotoCutViewController(frameImgae: frameImage!.image, makeType: frameImage!.makeType)
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
    lazy var xmarkCircleBarButtonItem = XmarkCircleBarButtonItem(tintColor: .designSystem(.mainPurple))
    
    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.register(Reusable.chooseFrame)
        cv.register(Reusable.headerView, kind: .header)
        
        return cv
    }()
    
    lazy var 고르기완료버튼: ConfirmButton = {
        $0.normalTitle = "네컷 생성하기"
        $0.normalTitleColor = .white
        $0.configure()
        return $0
    }(ConfirmButton())
}

//
extension ChooseFrameViewController {
    
    func heaher() {
        // 1️⃣ Header Cell 등록
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <ChooseFrmaeHeaderView>(elementKind: ChooseFrmaeHeaderView.kind) {
            (supplementaryView, string, indexPath) in
            
            let section = ChooseFrameModel.Category(rawValue: indexPath.section)
            switch section {
            case .basicFrame4x1: supplementaryView.headerLabel.text = "# 기본 4x1"
            case .basicFrame1x1: supplementaryView.headerLabel.text = "# 기본 1x1"
            case .basicFrame1x1Emoji: supplementaryView.headerLabel.text = "# 이모지 1x1"
            case .basicFrame4x1Mongle: supplementaryView.headerLabel.text = "# 몽글 4x1"
            default:
                print("🚨 무언가 빠뜨린 것 같아요. 꼭 체크해주세요.")
                supplementaryView.headerLabel.text = "미분류"
            }
        }
        
        // 1️⃣ Footer Cell 등록
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: kind == ChooseFrmaeHeaderView.kind
                ? headerRegistration
                : headerRegistration, // 나중에 푸터 사용하면 푸터로 교체
                for: index
            )
        }
        
    }
}
