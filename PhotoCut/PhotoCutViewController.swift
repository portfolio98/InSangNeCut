//
//  PhotoCutViewController.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

final class PhotoCutViewController: UIViewController, View {
    typealias Reactor = PhotoCutReactor
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
            chevronBackwardBarButtonItem.rx.tap
                .map { _ in Reactor.Action.didTapXmark }
                .bind(to: reactor.action)
            
            collectionView.rx.itemSelected
                .map(Reactor.Action.itemSelected)
                .bind(to: reactor.action)
            
            고르기완료버튼.rx.tap
                .withUnretained(self)
                .bind { this, _ in
                    let images = reactor.currentState.dataSource.map { model -> UIImage in
                            guard let image = model.image else { return UIImage() }
                            return image
                    }
                    
                    let frameImage = reactor.currentState.frmaeImage
                    let makeType = reactor.currentState.makeType
                    this.showNeCutViewController(frameImage: frameImage,
                                                 photoImages: images,
                                                 makeType: makeType)
                }
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
            
            reactor.state.map { $0.dataSource }
                .bind(to: collectionView.rx.items(Reusable.photoCutAddCell)) { index, item, cell in
                    cell.configureCell(model: item)
                }
            
            reactor.pulse(\.$showImagePickerController)
                .filter { $0 == true }
                .withUnretained(self)
                .bind { this, _ in this.showPhotoPicker() }
            
            
            reactor.state.map { $0.isEnabled고르기완료 }
                .filter { $0 == true }
                .withUnretained(self)
                .bind { this, _ in
                    this.고르기완료버튼.isEnabled = true
                    this.고르기완료버튼.updateBackgroundColor()
                }
        }
    }
    
    // MARK: - Function
    private func showPhotoPicker() {
        let picker = UIImagePickerController()
        picker.modalPresentationStyle = .fullScreen
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
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
    lazy var chevronBackwardBarButtonItem = ChevronBackwardBarButtonItem(tintColor: .white)
    
    lazy var collectionView: UICollectionView = {
        let type = reactor!.currentState.makeType
        let layout = createLayout(type: type)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.backgroundColor = .clear
        cv.register(Reusable.photoCutAddCell)
        
        return cv
    }()
    
    lazy var 고르기완료버튼: ConfirmButton = {
        $0.normalTitle = "네컷 만들기"
        $0.normalTitleColor = .white
        $0.disabledTitle = "사진을 더 골라줘"
        $0.disabledTitleColor = .white
        $0.isEnabled = false
        $0.configure()
        return $0
    }(ConfirmButton())
}

extension PhotoCutViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage {
            reactor?.action.onNext(.didFinishImagePicker(image))
        } else {
            print("🚨 편집된 사진을 가져오다 에러를 만났어요.")
        }
    }
}
