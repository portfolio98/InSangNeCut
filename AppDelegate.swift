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
        print("๐๋๋ฒ๊ทธ ๋ชจ๋")
        #else
        print("๐๋ฆด๋ฆฌ์ฆ ๋ชจ๋")
        #endif
        
        return true
    }
}
