//
//  NeCutMakeManager.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/27.
//

import UIKit

final class NeCutMakeManager {
    static let shared = NeCutMakeManager()
    
    private init() { }
    
    /// 프레임 사이즈
    struct Frame {
        struct Outer {
            static let _358x1015 = CGSize(width: 358, height: 1015) // basic 4x1
            static let _630x960 = CGSize(width: 630, height: 960) // basic 4x2 - 에러
            static let _710x894 = CGSize(width: 710, height: 894) // basic 1x1
            static let _646x810 = CGSize(width: 646, height: 810) // basicEmoji 1x1
            static let _316x960 = CGSize(width: 316, height: 960) // basicMongle 4x1
        }
        
        struct Inner {
            static let _290by206 = CGSize(width: 290, height: 206) // 4x1
            static let _542by542 = CGSize(width: 542, height: 542) // 1x1
        }
    }
    
    /// 네컷을 만들 메이크 타입
    enum NeCutMakeType {
        case _4by2 //= "4x2"
        case basic_frame_4x1 //= "4x1"
        case basic_frame_1x1 //= "1x1"
        case basic_frame_1x1_emoji
        case basic_frame_4x1_mongle
    }
    
    // MARK: - Fuction
    func makeBasicSticker4x1(frmaeImage: UIImage, chooseImages: [UIImage]) -> UIImage {
        let size = Frame.Outer._358x1015
        let inner = Frame.Inner._290by206
        
        UIGraphicsBeginImageContext(size)
        
        let orders = [CGRect(x: 34, y: 17, width: inner.width, height: inner.height),
                      CGRect(x: 34, y: inner.height + 17, width: inner.width, height: inner.height),
                      CGRect(x: 34, y: inner.height * 2 + 17, width: inner.width, height: inner.height),
                      CGRect(x: 34, y: inner.height * 3 + 17, width: inner.width, height: inner.height)]
        
        zip(orders, chooseImages).forEach { order, chooseImage in
            chooseImage.draw(in: order)
            
        }
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let necut = combineFrameAndImage(frameImage: frmaeImage,
                               targetImage: newImage,
                               size: size)
        
        return necut
    }
    
    @available(*, unavailable, message: "Asset 변화로 알고리즘를 다시 짜야합니다. 기존 알고리즘 사용 불가.")
    private func make4by2(frmaeImage: UIImage, chooseImages: [UIImage]) -> UIImage {
        let size = Frame.Outer._630x960
        
        UIGraphicsBeginImageContext(size)
        let left = CGRect(x: 0, y: 0, width: 315, height: 960)
        let right = CGRect(x: 315, y: 0, width: 315, height: 960)
        
        let singleFrameImage = makeBasicSticker4x1(frmaeImage: frmaeImage, chooseImages: chooseImages)
        
        singleFrameImage.draw(in: left)
        singleFrameImage.draw(in: right)
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let necut = combineFrameAndImage(frameImage: frmaeImage,
                               targetImage: newImage,
                               size: size)
        return necut
    }
    
    func makeBasicSticker1x1(frmaeImage: UIImage, chooseImages: [UIImage]) -> UIImage {
        let outer = Frame.Outer._710x894 // 정방형
        let inner = Frame.Inner._542by542
        
        // NOTE: - 1by1 52 - 542 - 52
        
        UIGraphicsBeginImageContext(outer)
        let orders = [CGRect(x: 84, y: 99, width: inner.width, height: inner.height)]
        
        zip(orders, chooseImages).forEach { order, chooseImage in
            chooseImage.draw(in: order)
        }
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let necut = combineFrameAndImage(frameImage: frmaeImage,
                               targetImage: newImage,
                               size: outer)
        
        return necut
    }
    
    func makeBasicEmoji1x1(frmaeImage: UIImage, chooseImages: [UIImage]) -> UIImage {
        let outer = Frame.Outer._646x810 // 정방형
        let inner = Frame.Inner._542by542
        
        UIGraphicsBeginImageContext(outer)
        let orders = [CGRect(x: 52, y: 76, width: inner.width, height: inner.height)]
        
        zip(orders, chooseImages).forEach { order, chooseImage in
            chooseImage.draw(in: order)
        }
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let necut = combineFrameAndImage(frameImage: frmaeImage,
                               targetImage: newImage,
                               size: outer)
        
        return necut
    }
    
    func makeBasicMongle4x1(frmaeImage: UIImage, chooseImages: [UIImage]) -> UIImage {
        let size = Frame.Outer._316x960
        let inner = Frame.Inner._290by206
        
        UIGraphicsBeginImageContext(size)
        
        let orders = [CGRect(x: 13, y: 13, width: inner.width, height: inner.height),
                      CGRect(x: 13, y: inner.height + 13, width: inner.width, height: inner.height),
                      CGRect(x: 13, y: inner.height * 2 + 13, width: inner.width, height: inner.height),
                      CGRect(x: 13, y: inner.height * 3 + 13, width: inner.width, height: inner.height)]
        
        zip(orders, chooseImages).forEach { order, chooseImage in
            chooseImage.draw(in: order)
            
        }
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let necut = combineFrameAndImage(frameImage: frmaeImage,
                               targetImage: newImage,
                               size: size)
        
        return necut
    }
    
//    func makeNoFrame(chooseImages: [UIImage]) -> UIImage {
//        
//    }
    
    // MARK: - 프레임을 만듭니다.
    private func combineFrameAndImage(frameImage: UIImage, targetImage: UIImage, size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        let frameSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        targetImage.draw(in: frameSize)
        frameImage.draw(in: frameSize, blendMode: .normal, alpha: 1.0)
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
