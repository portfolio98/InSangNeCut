//
//  OneDayModel.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/07.
//

import Foundation

struct OneDayModel {
    /** 아이디이자 이미지 키값*/ let id: String = UUID().uuidString
    
    /** 텍스트 */ var text: String
    /** 날짜 */ let time = Date()
//    var isFail
    
    init(text: String) {
        self.text = text
    }
}
