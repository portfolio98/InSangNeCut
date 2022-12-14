//
//  PhotoCutModel.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/28.
//

import UIKit

struct PhotoCutModel: Equatable {
    var id = UUID().uuidString
    
    var image: UIImage? = nil
    
    static func == (lhs: PhotoCutModel, rhs: PhotoCutModel) -> Bool {
        return lhs.id == rhs.id
    }
}
