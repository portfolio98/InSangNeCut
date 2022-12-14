//
//  LockerViewController.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/28.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa
import RxGesture
import ReactorKit

final class LockerViewController: UIViewController, View {
    typealias Reactor = LockerReactor
    
    enum Reusable {
        static let lockerCell = ReusableCell<LockerCell>()
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
//            self.collectionView.rx.setDelegate(self)
            
            self.rx.viewWillAppear
                .map { _ in Reactor.Action.viewWillAppear }
                .bind(to: reactor.action)
            
            xmarkCircleBarButtonItem.rx.tap
                .map { _ in Reactor.Action.didTapXmark }
                .bind(to: reactor.action)
            
            plusCircleBarButtonItem.rx.tap
                .map { _ in Reactor.Action.didTapPlus }
                .bind(to: reactor.action)
            
            collectionView.rx.itemSelected
                .map(Reactor.Action.itemSelected)
                .bind(to: reactor.action)
        }
    }
    
    private func render(reactor: Reactor) {
        disposeBag.insert {
            reactor.state.map { $0.isDismiss }
                .filter { $0 == true }
                .withUnretained(self)
                .bind { this, _ in this.dismiss(animated: true) }
            
            reactor.pulse(\.$lockerModels)
                .bind(to: collectionView.rx.items(Reusable.lockerCell)) { index, item, cell in
                    cell.configureCell(model: item, index: index)
                }

            reactor.pulse(\.$showsPicker)
                .filter { $0 == true }
                .withUnretained(self)
                .bind { this, _ in this.presentPickerView() }
            
            reactor.pulse(\.$isHiddenEmptyLabel)
                .withUnretained(self)
                .bind { this, value in
                    this.emptyLabel.isHidden = value
                    this.collectionView.isHidden = !value
                }
            
            reactor.pulse(\.$showDetailView)
                .filter { trigger, indexPath in return trigger }
                .withUnretained(self)
                .bind { this, item in
                    let indexPath = item.1
                    this.showLockerDetailViewController(indexPath: indexPath)
                }
        }
    }
    
    // MARK: - Function
    private func presentPickerView() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 36
        configuration.filter = .images
        configuration.selection =  .ordered
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.modalPresentationStyle = .fullScreen
        picker.delegate = self
        present(picker, animated: true)
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
        view.backgroundColor = .white
        
        self.configureUI()
    }
    
    // MARK: - UIComponents
    lazy var xmarkCircleBarButtonItem = XmarkCircleBarButtonItem(tintColor: .designSystem(.mainYellow))
    
    lazy var plusCircleBarButtonItem = PlusCircleBarButtonItem(tintColor: .designSystem(.mainYellow))
    
    lazy var 추가하기버튼뷰: AddButtonView = {
        $0.tintColor = .designSystem(.mainYellow)
        return $0
    }(AddButtonView())
    
    lazy var emptyLabel: UILabel = {
        $0.text = "아직 보관함에 모인 추억들이 없어요."
        $0.textAlignment = .center
        $0.font = .pretendardFont(size: 16, style: .medium)
        $0.textColor = .systemGray
        return $0
    }(UILabel())
    
    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(Reusable.lockerCell)
        
        return cv
    }()
}

extension LockerViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        let itemProviders = results.map { result in
            result.itemProvider
        }
        
        itemProviders.forEach { provider in
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { readingItem, error in
                    if let error {
                        print("🚨 \(error.localizedDescription)")
                    }
                    
                    // BUG: - async로 처리하면 UI가 제대로 그려지지 않는 현상 있음
                    DispatchQueue.main.sync {
                        if let image = readingItem as? UIImage {
                            // NOTE: - 타이밍 이슈 여기서 처리해야 함
                            self.reactor?.action.onNext(.didFinishPicking(image))
                        }
                    }
                }
            }
        }
        
    }
    
}

extension LockerViewController: UIScrollViewDelegate {
    // TODO: - 나중에 액션 제대로 연결하기
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y )
        scrollView.bounces = scrollView.contentOffset.y > 1
    }
}


// https://gyuios.tistory.com/131
// https://rockyshikoku.medium.com/select-multiple-photos-from-iphone-photo-library-phpickerviewcontroller-986257d4d7db

/* bug 일부 사진 추가가 안되는데 체크해야합니다.
 🚨 Cannot load representation of type public.jpeg
 👨🏽‍🦱 [<PUPhotosFileProviderItemProvider: 0x600002ac8240> {types = (
     "public.jpeg",
     "public.heic"
 )}]
 2022-11-29 13:49:11.417764+0900 InsangNeCut[3197:43847] [claims] 165B5E98-C320-4AE9-8C74-878D04AE0A8C grantAccessClaim reply is an error: Error Domain=NSCocoaErrorDomain Code=4101 "Couldn’t communicate with a helper application." UserInfo={NSUnderlyingError=0x6000016cde90 {Error Domain=PHAssetExportRequestErrorDomain Code=0 "작업을 완료할 수 없습니다.(PHAssetExportRequestErrorDomain 오류 0.)" UserInfo={NSLocalizedDescription=작업을 완료할 수 없습니다.(PHAssetExportRequestErrorDomain 오류 0.), NSUnderlyingError=0x6000016ceb80 {Error Domain=PAMediaConversionServiceErrorDomain Code=2 "작업을 완료할 수 없습니다.(PAMediaConversionServiceErrorDomain 오류 2.)" UserInfo={NSLocalizedDescription=작업을 완료할 수 없습니다.(PAMediaConversionServiceErrorDomain 오류 2.)}}}}}
 🚨 Cannot load representation of type public.jpeg

 */

