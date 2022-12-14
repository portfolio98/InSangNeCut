//
//  Pallete.swift
//  DesignSystemTests
//
//  Created by Woody on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public enum Pallete: String {
    /** 앱 메인 포인트 컬러 */ case mainPoint
    /** 앱  메인 퍼플 컬러 */ case mainPurple
    /** 앱  메인 블루 컬러 */ case mainBlue
    /** 앱  메인 옐로우 컬러 */ case mainYellow
    /** 앱  메인 아이보리 컬러 */ case mainIvory
    /** 앱  메인 아이보리2 컬러 */ case mainIvory2
    
    
    
    var hexInteger: Int {
        switch self {
        case .mainPoint: return 0xFF4F6D
        case .mainPurple: return 0xE2B9FF
        case .mainBlue: return 0x30BCF9
        case .mainYellow: return 0xFFDE37
        case .mainIvory: return 0xFFF7F0
        case .mainIvory2: return 0xFFB34D
        }
    }
}

