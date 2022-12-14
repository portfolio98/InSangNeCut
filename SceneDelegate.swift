//
//  SceneDelegate.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/24.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        
        let ld = HomeViewController()
//        let ld = LockerDetailViewController(reactor: .init(initialState: .init(lockerModel: .init())))
        window?.rootViewController = UINavigationController(rootViewController: ld)
//        window?.rootViewController = NeCutViewController()
//        window?.rootViewController = LockerViewController(reactor: .init(initialState: .init()))
//        window?.rootViewController = ChooseFrameViewController(reactor: .init(initialState: .init(choosePhotoImages: [])))
//        window?.rootViewController = UINavigationController(rootViewController: PhotoCutViewController(reactor: .init(initialState: .init())))
        window?.makeKeyAndVisible()
    }
    
}

