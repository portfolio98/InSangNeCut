//
//  Pallete.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/01.
//

import Foundation

public enum Pallete {
    // MARK: - 앱 메인 컬러를 정의합니다.
    /** 앱 메인 포인트 컬러 */ case mainPoint
    
    /** 앱 메인 컬러 */ case mainPurple
    /** 앱 메인 컬러 */ case mainBlue
    /** 앱 메인 컬러 */ case mainYellow
    
    var hexInteger: Int {
        switch self {
        case .mainPoint: return 0xFF4F6D
        case .mainPurple: return 0xD292FF
        case .mainBlue: return 0x30BCF9
        case .mainYellow: return 0xFFDE37
        }
    }
}
