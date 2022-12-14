//
//  NeCutViewController.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/27.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import Photos

final class NeCutViewController: UIViewController {
    var disposeBag = DisposeBag()
    let neCutMakeManager = NeCutMakeManager.shared
    
    // MARK: - Properties
    /** 선택한 프레임 이미지*/ var chooseFrameImage: UIImage?
    /** 선택한 사진 이미지*/ var choosePhotoImages: [UIImage]?
    /** 사진생성 타입  */ var makeType: NeCutMakeManager.NeCutMakeType = .basic_frame_4x1 // 기본값 4by1
    
    private var neCutImage: UIImage?
    
    // MARK: - Binding
    func bind() {
        backBarButtonItem.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        saveButton.rx.tapGesture().when(.recognized)
            .withUnretained(self)
            .bind { this, _ in
                // 첫 화면으로 돌아가기
                if let image = this.neCutImage {
                    this.savedImage(image: image)
                }
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Function
    func configureNecutImage() {
        guard let chooseFrameImage,
              let choosePhotoImages else {
            print("🚨 프레임이나 선택한사진들 중 어떤 값이 nil이에요.")
            return
        }
        
        // 레이아웃을 다시 잡아주기 위함.
        imageView.setNeedsLayout()
        switch makeType {
        case ._4by2:
//            self.neCutImage = neCutMakeManager.make4by2(frmaeImage: chooseFrameImage,
//                                                        chooseImages: choosePhotoImages)
            imageView.snp.updateConstraints {
                $0.edges.equalToSuperview().inset(30)
            }
        case .basic_frame_4x1:
            neCutImage = neCutMakeManager.makeBasicSticker4x1(frmaeImage: chooseFrameImage,
                                                   chooseImages: choosePhotoImages)
            imageView.snp.updateConstraints {
                $0.edges.equalToSuperview().inset(100)
            }
        case .basic_frame_1x1:
            neCutImage = neCutMakeManager.makeBasicSticker1x1(frmaeImage: chooseFrameImage,
                                                   chooseImages: choosePhotoImages)
            imageView.snp.updateConstraints {
                $0.edges.equalToSuperview().inset(30)
            }
        case .basic_frame_1x1_emoji:
            neCutImage = neCutMakeManager.makeBasicEmoji1x1(frmaeImage: chooseFrameImage,
                                                   chooseImages: choosePhotoImages)
            imageView.snp.updateConstraints {
                $0.edges.equalToSuperview().inset(30)
            }
        case .basic_frame_4x1_mongle:
            neCutImage = neCutMakeManager.makeBasicMongle4x1(frmaeImage: chooseFrameImage,
                                                   chooseImages: choosePhotoImages)
            
            imageView.snp.updateConstraints {
                $0.edges.equalToSuperview().inset(100)
            }
        }
        
        imageView.layoutIfNeeded()
        
        self.imageView.image = neCutImage
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.bind()
        self.configureNecutImage()
    }
    
    // MARK: - UIComponents
    lazy var backBarButtonItem = ChevronBackwardBarButtonItem(tintColor: .designSystem(.mainPoint))
    
    lazy var neCutBackgroundView: UIView = {
        var view = UIView()
        let backgroundView = UIHostingController(rootView: NeCutBackgroundView()).view
        view = backgroundView!
        return view
    }()
    
    lazy var saveButton: UIImageView = {
        $0.image = UIImage(systemName: "checkmark.circle.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .designSystem(.mainPoint)
        
        return $0
    }(UIImageView())
    
    lazy var imageView: UIImageView = {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
}

extension NeCutViewController {
    func configureUI() {
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        view.addSubview(neCutBackgroundView)
        neCutBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(50)
        }
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
            $0.width.height.equalTo(80)
        }
    }
}

extension NeCutViewController: UIImagePickerControllerDelegate {
    
    func savedImage(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                // 저장
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                } completionHandler: { (success, error) in
                    if success {
                        
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: nil,
                                                                    message: "갤러리에 저장 완료",
                                                                    preferredStyle: .alert)
                            let confirmAction = UIAlertAction(
                                title: "확인",
                                style: .default
                            ) { _ in
                                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                            }
                            
                            alertController.addAction(confirmAction)
                            self.present(alertController, animated: true)
                        }
                        
                    }
                    print("이미지 저장 완료 --> \(success)")
                }
                
            } else {
                // 다시 요청
                print("--> 권한을 얻지 못함")
            }
        }
    }
}
