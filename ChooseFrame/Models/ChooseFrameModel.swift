//
//  ChooseFrameModel.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/27.
//

import UIKit
import Differentiator

struct ChooseFrameModel: Hashable, Equatable {
    typealias MakeType = NeCutMakeManager.NeCutMakeType
    
    enum Category: Int, CaseIterable {
        case basicFrame4x1
        case basicFrame1x1
        case basicFrame1x1Emoji
        case basicFrame4x1Mongle
    }
    
    var id = UUID().uuidString
    
    /** 메이크 타입 */ var makeType: MakeType
    /** 카테고리 */ var category: Category
    /** 촬영한 이미지*/  var image: UIImage
    /** 선택된지 여부. */ var isChoose: Bool
    
    init(
        makeType: MakeType,
        category: Category,
        image: UIImage,
        isChoose: Bool = false
    ) {
        self.image = image
        self.isChoose = isChoose
        self.makeType = makeType
        self.category = category
    }
}

extension ChooseFrameModel {
    
    static var photoFrames: [ChooseFrameModel] = [
        // MARK: - basic_frame_4x1
        ChooseFrameModel(makeType: .basic_frame_4x1, category: .basicFrame4x1, image: UIImage(named: "basic_frame_4x1/E30005")!, isChoose: true),
        ChooseFrameModel(makeType: .basic_frame_4x1, category: .basicFrame4x1, image: UIImage(named: "basic_frame_4x1/FF7F00")!),
        ChooseFrameModel(makeType: .basic_frame_4x1, category: .basicFrame4x1, image: UIImage(named: "basic_frame_4x1/FDC909")!),
        ChooseFrameModel(makeType: .basic_frame_4x1, category: .basicFrame4x1, image: UIImage(named: "basic_frame_4x1/00FF00")!),
        ChooseFrameModel(makeType: .basic_frame_4x1, category: .basicFrame4x1, image: UIImage(named: "basic_frame_4x1/2A63E9")!),
        ChooseFrameModel(makeType: .basic_frame_4x1, category: .basicFrame4x1, image: UIImage(named: "basic_frame_4x1/8600E3")!),
        ChooseFrameModel(makeType: .basic_frame_4x1, category: .basicFrame4x1, image: UIImage(named: "basic_frame_4x1/C8A2C8")!),
        ChooseFrameModel(makeType: .basic_frame_4x1, category: .basicFrame4x1, image: UIImage(named: "basic_frame_4x1/F55FC1")!),
        ChooseFrameModel(makeType: .basic_frame_4x1, category: .basicFrame4x1, image: UIImage(named: "basic_frame_4x1/FF007F")!),
        ChooseFrameModel(makeType: .basic_frame_4x1, category: .basicFrame4x1, image: UIImage(named: "basic_frame_4x1/000000")!),
        
        // MARK: - basic_frame_1x1
        ChooseFrameModel(makeType: .basic_frame_1x1, category: .basicFrame1x1, image: UIImage(named: "basic_frame_1x1/E30005")!),
        ChooseFrameModel(makeType: .basic_frame_1x1, category: .basicFrame1x1, image: UIImage(named: "basic_frame_1x1/FF7F00")!),
        ChooseFrameModel(makeType: .basic_frame_1x1, category: .basicFrame1x1, image: UIImage(named: "basic_frame_1x1/FDC909")!),
        ChooseFrameModel(makeType: .basic_frame_1x1, category: .basicFrame1x1, image: UIImage(named: "basic_frame_1x1/00FF00")!),
        ChooseFrameModel(makeType: .basic_frame_1x1, category: .basicFrame1x1, image: UIImage(named: "basic_frame_1x1/2A63E9")!),
        ChooseFrameModel(makeType: .basic_frame_1x1, category: .basicFrame1x1, image: UIImage(named: "basic_frame_1x1/8600E3")!),
        ChooseFrameModel(makeType: .basic_frame_1x1, category: .basicFrame1x1, image: UIImage(named: "basic_frame_1x1/C8A2C8")!),
        ChooseFrameModel(makeType: .basic_frame_1x1, category: .basicFrame1x1, image: UIImage(named: "basic_frame_1x1/F55FC1")!),
        ChooseFrameModel(makeType: .basic_frame_1x1, category: .basicFrame1x1, image: UIImage(named: "basic_frame_1x1/FF007F")!),
        ChooseFrameModel(makeType: .basic_frame_1x1, category: .basicFrame1x1, image: UIImage(named: "basic_frame_1x1/000000")!),
        
        // MARK: - basic_frame_1x1_emoji
        ChooseFrameModel(makeType: .basic_frame_1x1_emoji, category: .basicFrame1x1Emoji, image: UIImage(named: "basic_frame_1x1_emoji/E30005")!),
        ChooseFrameModel(makeType: .basic_frame_1x1_emoji, category: .basicFrame1x1Emoji, image: UIImage(named: "basic_frame_1x1_emoji/FF7F00")!),
        ChooseFrameModel(makeType: .basic_frame_1x1_emoji, category: .basicFrame1x1Emoji, image: UIImage(named: "basic_frame_1x1_emoji/FDC909")!),
        ChooseFrameModel(makeType: .basic_frame_1x1_emoji, category: .basicFrame1x1Emoji, image: UIImage(named: "basic_frame_1x1_emoji/265E10")!),
        ChooseFrameModel(makeType: .basic_frame_1x1_emoji, category: .basicFrame1x1Emoji, image: UIImage(named: "basic_frame_1x1_emoji/2A63E9")!),
        ChooseFrameModel(makeType: .basic_frame_1x1_emoji, category: .basicFrame1x1Emoji, image: UIImage(named: "basic_frame_1x1_emoji/8600E3")!),
        ChooseFrameModel(makeType: .basic_frame_1x1_emoji, category: .basicFrame1x1Emoji, image: UIImage(named: "basic_frame_1x1_emoji/F55FC1")!),
        
        // MARK: - basic_frame_4x1_mongle
        ChooseFrameModel(makeType: .basic_frame_4x1_mongle, category: .basicFrame4x1Mongle, image: UIImage(named: "basic_frame_4x1_mongle/68D6FF")!),
        ChooseFrameModel(makeType: .basic_frame_4x1_mongle, category: .basicFrame4x1Mongle, image: UIImage(named: "basic_frame_4x1_mongle/E2B9FF")!),
        ChooseFrameModel(makeType: .basic_frame_4x1_mongle, category: .basicFrame4x1Mongle, image: UIImage(named: "basic_frame_4x1_mongle/FAEBD7")!),
        ChooseFrameModel(makeType: .basic_frame_4x1_mongle, category: .basicFrame4x1Mongle, image: UIImage(named: "basic_frame_4x1_mongle/FFC0CB")!),
        ChooseFrameModel(makeType: .basic_frame_4x1_mongle, category: .basicFrame4x1Mongle, image: UIImage(named: "basic_frame_4x1_mongle/FFDF40")!),
        
        
    ]
    
    // NOTE: - 이건 나중에 만들자
    static func 에셋자동분류알고리즘() {
        typealias MakeType = NeCutMakeManager.NeCutMakeType

        let allAssets = Asset.allCases
//        var makeType: MakeType

        var result = [ChooseFrameModel]()
        allAssets.forEach { asset in
            let assetString = asset.rawValue
            print("asset \(assetString)")
            

//            if assetString.contains(MakeType._4by1.rawValue) {
//                let item = ChooseFrameModel(makeType: ._4by1, category: .basic, image: UIImage(assetName: assetString)!)
//                result.append(item)
//            } else if assetString.contains(MakeType._4by2.rawValue) {
//                let item = ChooseFrameModel(makeType: ._4by2, category: .special, image: UIImage(assetName: assetString)!)
//                result.append(item)
//            } else {
//                let item = ChooseFrameModel(makeType: ._4by2, category: .special, image: UIImage(assetName: assetString)!)
//                result.append(item)
//            }

        }
    }
}
