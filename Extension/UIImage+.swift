//
//  UIImage+.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/02.
//

import UIKit
import ImageIO

extension UIImage {
    
    func cropImage1x1() -> UIImage {
        // 정방형
        let width = self.size.width
        let height = self.size.height
        
        var targetFrame: CGRect
        let frameSize = CGSize(width: width, height: width)
        
        let 차이 = (height - width) / 2
        let point = CGPoint(x: 차이, y: 0)
        targetFrame = .init(origin: point, size: frameSize)
        
        let cgImage = self.cgImage!
        let croppedImage = cgImage.cropping(to: targetFrame)!
        
        return UIImage(cgImage: croppedImage)
    }
    
    func cropImage4x1() -> UIImage {
        // 가로
        let width = self.size.width
        let height = self.size.height
        
        var targetFrame: CGRect
        let frameSize = CGSize(width: width * 1.5, height: width)
        
        let 차이 = (height - width * 1.5) / 2
        let point = CGPoint(x: 차이, y: 0)
        targetFrame = .init(origin: point, size: frameSize)
        
        let cgImage = self.cgImage!
        let croppedImage = cgImage.cropping(to: targetFrame)!
        
        return UIImage(cgImage: croppedImage)
    }
    
    
    // NOTE: - 이거 강제 언래핑이라 유의주시해야 함.
    func cropImage(makeType: NeCutMakeManager.NeCutMakeType) -> UIImage {
        typealias Size = NeCutMakeManager.Frame.Inner
        
        var targetFrame: CGRect
        var frameSize: CGSize
        var 차이: CGFloat
        
        switch makeType {
        case .basic_frame_4x1, .basic_frame_4x1_mongle:
            frameSize = Size._290by206
            차이 = self.size.height - frameSize.height
            targetFrame = .init(origin: .init(x: 0, y: 차이 / 2), size: Size._290by206)
        case ._4by2:
            frameSize = Size._290by206
            차이 = self.size.height - frameSize.height
            targetFrame = .init(origin: .init(x: 0, y: 차이 / 2), size: Size._290by206)
            targetFrame = .init(origin: .init(x: 0, y: 0), size: Size._290by206)
        case .basic_frame_1x1, .basic_frame_1x1_emoji:
            frameSize = Size._542by542
            차이 = self.size.height - frameSize.height
            targetFrame = .init(origin: .init(x: 0, y: 차이 / 2), size: Size._542by542)
        }
        
        let cgImage = self.cgImage!
        let croppedImage = cgImage.cropping(to: targetFrame)!
        return UIImage(cgImage: croppedImage)
    }
    
    // 원하는 해상도에 맞게 조절
    func downSampling(makeType: NeCutMakeManager.NeCutMakeType) -> UIImage {
        typealias Size = NeCutMakeManager.Frame.Inner
        
        var newWidth: CGFloat
        var scale: CGFloat
        
        switch makeType {
        case .basic_frame_4x1, .basic_frame_4x1_mongle:
            newWidth = Size._290by206.width
            scale = newWidth / self.size.width
        case ._4by2:
            newWidth = Size._290by206.width
            scale = newWidth / self.size.width
        case .basic_frame_1x1, .basic_frame_1x1_emoji:
            newWidth = Size._542by542.width
            scale = newWidth / self.size.width
        }
        
        let imageSourceOption = [kCGImageSourceShouldCache: false] as CFDictionary
        let data = self.pngData()! as CFData
        let imageSource = CGImageSourceCreateWithData(data, nil)!
        let maxPixel = max(self.size.width, self.size.height) * scale
        let downSampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel
        ] as CFDictionary

        let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions)!

        var newImage = UIImage(cgImage: downSampledImage)
        return newImage
    }
    
    // MARK: - Asset
    convenience init?(_ asset: Asset) {
        self.init(named: asset.rawValue, in: Bundle.main, with: nil)
    }

    convenience init?(assetName: String) {
        self.init(named: assetName, in: Bundle.main, with: nil)
    }
}
