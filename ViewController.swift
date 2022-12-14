//
//  ViewController.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Photos

class ViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    var 단일프레임이미지: UIImage?
    var 더블프레임이미지: UIImage?
    
    
    let 포도이미지 = UIImage(named: "포도")
    let 사과이미지 = UIImage(named: "사과")
    let 용과이미지 = UIImage(named: "용과")
    let 바나나이미지 = UIImage(named: "바나나")
    let grayFrame = UIImage(named: "GrayFrame")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        configureUI()
        linkedImage()

    }
    
    private func linkedImage() {
        // MARK: 프레임에 대한 수치값 정의
        
        /* 프레임:
         가로선: width: 316 height: 13
         세로선: width: 13 heigth: 813
         하단까지 감싸는 간격입니다.
         
         하단 배너: width: 316 height: 124
         */
        
        
        // MARK: - 인생네컷처럼 사진 4장 연결
        // width: 631 height: 960 (아래 비 960)
        let size = CGSize(width: 315, height: 960)
        UIGraphicsBeginImageContext(size)

        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        // width: 631 height: 832 / 4 = 208
        let 포도Size = CGRect(x: 0, y: 0, width: size.width, height: 208)
        let 사과Size = CGRect(x: 0, y: 208, width: size.width, height: 208)
        let 용과Size = CGRect(x: 0, y: 416, width: size.width, height: 208)
        let 바나나Size = CGRect(x: 0, y: 624, width: size.width, height: 208)
        포도이미지?.draw(in: 포도Size)
        사과이미지?.draw(in: 사과Size)
        용과이미지?.draw(in: 용과Size)
        바나나이미지?.draw(in: 바나나Size)
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // MARK: - 프레임 적용
        UIGraphicsBeginImageContext(size)
        let frameSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        newImage.draw(in: frameSize)
        grayFrame?.draw(in: frameSize, blendMode: .normal, alpha: 1.0)
        
        let frameNewImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // MARK: - 사진 저장
        savedImage(image: frameNewImage)
//        imageView.image = frameNewImage
        
        // MARK: - 이어붙이기용
        단일프레임이미지 = frameNewImage
        
        self.프레임2개이어붙히기()
    }
    
    private func 프레임2개이어붙히기() {
        let size = CGSize(width: 630, height: 960)
        UIGraphicsBeginImageContext(size)
        let left = CGRect(x: 0, y: 0, width: 315, height: 960)
        let right = CGRect(x: 315, y: 0, width: 315, height: 960)
        단일프레임이미지?.draw(in: left)
        단일프레임이미지?.draw(in: right)
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        더블프레임이미지 = newImage
        imageView.image = newImage
        // MARK: - 사진 저장
        savedImage(image: newImage)
    }
    
    private func overlayImage() {
        // 두개의 이미지를 겹칩니다.
        
        // MARK: - 스택오버플로
        let size = CGSize(width: 300, height: 300)
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        포도이미지?.draw(in: areaSize)
        사과이미지?.draw(in: areaSize, blendMode: .normal, alpha: 0.8)
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        imageView.image = newImage
        
        DispatchQueue.main.async {
            self.savedImage(image: newImage)
        }
    }
    
    func configureUI() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func savedImage(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                // 저장
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                } completionHandler: { (success, error) in
                    print("이미지 저장 완료 --> \(success)")
                }

            } else {
                // 다시 요청
                print("--> 권한을 얻지 못함")
            }
        }
    }
}
