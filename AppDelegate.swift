//
//  AppDelegate.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/24.
//

import UIKit


@main
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        self.configureFirebase(application)
        
        #if DEBUG
        print("💕디버그 모드")
        #else
        print("💕릴리즈 모드")
        #endif
        
        return true
    }
}
