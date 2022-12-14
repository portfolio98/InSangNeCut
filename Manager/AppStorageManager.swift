//
//  UserDefaultManager.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/29.
//

import Foundation
import SwiftUI
import WidgetKit

enum AppStorageKey: String {
    case suiteName = "group.com.booth.home.lgvv"
    case locker
    case photosKey
}

final class AppStorageManager {
    typealias Key = AppStorageKey
    static let storage = UserDefaults(suiteName: "group.com.booth.home.lgvv") ?? .standard
    static var shared = AppStorageManager()
    
    private init() {
        print("🌊 \(AppStorageManager.storage)")
    }
    
    @UserDefault(key: AppStorageKey.locker.rawValue, defaultValue: [], storage: storage)
    var lockerModels: [LockerModel]
}

extension AppStorageManager {
    // TODO: - Migration
    func migration() {
        
    }
}
