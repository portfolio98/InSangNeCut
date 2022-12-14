//
//  ChoosePhotoModel.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/27.
//

import UIKit

struct ChoosePhotoModel: Equatable {
    let id = UUID().uuidString
    
    /** 촬영한 이미지*/  var image: UIImage
    /** 선택된 순서 nil일 경우 선택되지 않음. */ var chooseOrder: Int?
    
    init(image: UIImage, chooseOrder: Int? = nil) {
        self.image = image
        self.chooseOrder = chooseOrder
    }
    
    static func == (lhs: ChoosePhotoModel, rhs: ChoosePhotoModel) -> Bool {
        return lhs.id == lhs.id
    }
}
