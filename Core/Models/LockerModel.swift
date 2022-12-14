//
//  LockerModel.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/28.
//

import UIKit

struct LockerModel: Codable, Equatable {
    /** 사진의 id값 */ var id = UUID().uuidString
    
    /** 이미지 설명 텍스트*/ var text: String = ""
    
    static func == (lhs: LockerModel, rhs: LockerModel) -> Bool {
        return lhs.id == rhs.id
    }
}
