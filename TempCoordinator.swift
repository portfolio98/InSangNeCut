//
//  TempCoordinator.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/28.
//

import UIKit

// 코디네이터 패턴을 적용해야 하나 일단 이걸로라도 적용해보자.
extension UIViewController {
    func showCameraViewController(frameImage: UIImage, makeType: NeCutMakeManager.NeCutMakeType) {
        let vc = CameraViewController(reactor: .init(initialState: .init(frameImage: frameImage, makeType: makeType)))
        let nav = UINavigationController(rootViewController: vc)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showChoosePhotoViewController(
        captureImages: [UIImage],
        frameImage: UIImage,
        makeType: NeCutMakeManager.NeCutMakeType
    ) {
        let capturePhotos = captureImages.map { image -> ChoosePhotoModel in
            return ChoosePhotoModel(image: image)
        }
        let vc = ChoosePhotoViewController(reactor: .init(initialState: .init(capturePhotos: capturePhotos, frameImage: frameImage, makeType: makeType)))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func showChooseFrameViewController(
        neCutMakeType: NeCutMakeManager.NeCutMakeType,
        nextViewType: ChooseFrameReactor.State.NextViewType
    ) {
        let vc = ChooseFrameViewController(reactor: .init(initialState: .init(neCutMakeType: neCutMakeType, nextViewType: nextViewType)))
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    func showNeCutViewController(frameImage: UIImage, photoImages: [UIImage], makeType: NeCutMakeManager.NeCutMakeType) {
        let vc = NeCutViewController()
        vc.chooseFrameImage = frameImage
        vc.choosePhotoImages = photoImages
        vc.makeType = makeType
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showPhotoCutViewController(frameImgae: UIImage, makeType: NeCutMakeManager.NeCutMakeType) {
        let vc = PhotoCutViewController(reactor: .init(initialState: .init(makeType: makeType, frmaeImage: frameImgae)))
        let nav = UINavigationController(rootViewController: vc)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showLockerViewContoller() {
        let vc = LockerViewController(reactor: .init(initialState: .init()))
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    func showSettingViewController() {
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showLockerDetailViewController(indexPath: IndexPath) {
        let reactor = LockerDetailReactor(initialState: .init(indexPath: indexPath))
        let vc = LockerDetailViewController(reactor: reactor)
        let nav = UINavigationController(rootViewController: vc)
        navigationController?.pushViewController(vc, animated: true)
    }
}
