//
//  CameraViewController.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/25.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa
import SnapKit
import RxGesture
import ReactorKit

final class CameraViewController: UIViewController, View {
    typealias Reactor = CameraReactor
    var disposeBag = DisposeBag()
    
    // MARK: - Properties
    
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
            
            backBarButtonItem.rx.tap
                .map { _ in Reactor.Action.didTapBack }
                .bind(to: reactor.action)
            
            checkmarkCircleBarButtonItem.rx.tap
                .map { _ in Reactor.Action.didTapCheckmark }
                .bind(to: reactor.action)
            
            촬영하기버튼뷰.rx.tapGesture()
                .when(.recognized)
                .map { _ in Reactor.Action.didTap촬영하기버튼뷰 }
                .bind(to: reactor.action)
            
            imageOrientationImageView.rx.tapGesture()
                .when(.recognized)
                .map { _ in Reactor.Action.didTapimageOrientationImageView }
                .bind(to: reactor.action)
            
            switchCameraImageView.rx.tapGesture()
                .when(.recognized)
                .map { _ in Reactor.Action.didTapSwitchCameraImageView }
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
            
            reactor.pulse(\.$isProcessingPhoto)
                .withUnretained(self)
                .bind { this, value in
                    if value {
                        this.cameraPreview.capturePhoto(delegate: self)
                    }
                    this.촬영하기버튼뷰.isUserInteractionEnabled = !value
                }
            
            reactor.state.map { $0.isHiddenCheckmark }
                .withUnretained(self)
                .bind { this, value in
                    this.checkmarkCircleBarButtonItem.isEnabled = !value
                }
                
            reactor.state.map { $0.capturePhotos.count }
                .withUnretained(self)
                .bind { this, count in
                    if count >= 8 {
                        this.촬영하기버튼뷰.isHidden = true
                        this.촬영하기버튼뷰.isUserInteractionEnabled = false
                    }
                }
            
            reactor.state.map { $0.showsChoosPhotoView }
                .filter { trigger, photos, frameImage in
                    return trigger == true
                }
                .withUnretained(self)
                .bind { this, item in
                    let photos = item.1
                    let frameImage = item.2
                    
                    let makeType = reactor.initialState.makeType
                    this.showChoosePhotoViewController(captureImages: photos, frameImage: frameImage, makeType: makeType)
                }
            
            reactor.pulse(\.$imageOrientationIndex)
                .skip(1)
                .withUnretained(self)
                .bind { this, index in
                    this.imageOrientationImageView.transform = this.imageOrientationImageView.transform.rotated(by: .pi / 2)
                }
            
            reactor.pulse(\.$hardwarePostion)
                .skip(1) // 처음에 init되기 전에 들어가면 crash -> guard로 나중에 변경하기
                .withUnretained(self)
                .bind { this, position in
                    this.cameraPreview.switchCamera(postion: position) //
                }
        }
    }
    
    // MARK: - Function
    private func showAlert() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "카메라 방향 안내",
                                                    message: "아래의 사람 방향이랑 이미지 방향이 일치해요. 사람 방향을 클릭하여 변경할 수 있어요.",
                                                    preferredStyle: .alert)
            let confirmAction = UIAlertAction(
                title: "확인",
                style: .default
            )
            
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true)
        }
    }
    
    // MARK: - Initialzie
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
        self.showAlert()
    }
    
    // MARK: - UIComponents
    
    lazy var backBarButtonItem = ChevronBackwardBarButtonItem(tintColor: .white)
    
    lazy var checkmarkCircleBarButtonItem = CheckmarkCircleBarButtonItem(tintColor: .designSystem(.mainPoint))
    
    var cameraPreview = CameraPreviewView()
    lazy var preView: UIView = {
        $0.addSubview(cameraPreview)
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.designSystem(.mainPurple).cgColor
        return $0
    }(UIView())

    lazy var switchCameraImageView: UIImageView = {
        $0.image = UIImage(systemName: "arrow.triangle.2.circlepath.camera")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    lazy var imageOrientationImageView: UIImageView = {
        $0.image = UIImage(systemName: "person.circle")
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    lazy var 촬영하기버튼뷰: UIImageView = {
        $0.image = UIImage(systemName: "circle.inset.filled")
        $0.tintColor = .white
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        if let image = UIImage(data: imageData) {
            reactor?.action.onNext(.didFinishProcessingPhoto(image))
        }
    }
}

extension CameraViewController {
    func configureUI() {
        view.backgroundColor = .designSystem(.mainPurple)
        navigationItem.leftBarButtonItem = backBarButtonItem
        navigationItem.rightBarButtonItem = checkmarkCircleBarButtonItem
        
        // NOTE: - 가로찍기를 권장하자.
        let type = reactor?.initialState.makeType
        var weight: CGFloat
        switch type {
        case .basic_frame_1x1, .basic_frame_1x1_emoji: weight = 1.0
        case .basic_frame_4x1, .basic_frame_4x1_mongle: weight = 1.5
        case ._4by2: weight = 1.0
            print("🚨error : 4by2")
        case .none: weight = 1.0
            print("🚨 error : none")
        }
        
        view.addSubview(preView)
        preView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(view.frame.width * weight)
            $0.leading.trailing.equalToSuperview()
            $0.center.equalToSuperview()
        }
        cameraPreview.configurePreviewLayer(sender: preView)
        view.addSubview(촬영하기버튼뷰)
        촬영하기버튼뷰.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.width.equalTo(80)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(imageOrientationImageView)
        imageOrientationImageView.snp.makeConstraints {
            $0.centerY.equalTo(촬영하기버튼뷰.snp.centerY)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.width.height.equalTo(35)
        }
        
        view.addSubview(switchCameraImageView)
        switchCameraImageView.snp.makeConstraints {
            $0.centerY.equalTo(촬영하기버튼뷰.snp.centerY)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.width.height.equalTo(35)
        }
    }
}
