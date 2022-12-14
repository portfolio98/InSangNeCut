//
//  BarButtonItem+.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/01.
//

import UIKit

extension UIBarButtonItem {
    typealias ImageType = UIBarButtonItemImageType
    func designSystem(_ type: ImageType) -> UIBarButtonItem {
//        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .default)
//        let image = UIImage(systemName: type.systemName, withConfiguration: config)

        return UIBarButtonItem(image: type.systemName, menu: .none)
    }
    
//    func designSystem(_ type: UIBarButtonItemType) -> UIBarButtonItem {
//        return UIBarButtonItem(image: .add, menu: .none)
//    }
}

public enum UIBarButtonItemImageType {
    case close
    case back
    case add
    
    var systemName: UIImage {
        switch self {
        case .close: return .orEmpty(systemName: "xmark.circle")
        case .back: return .orEmpty(systemName: "xmark.circle")
        case .add: return .orEmpty(systemName: "plus.circle")
        }
    }
}

public enum UIBarButtonItemTextType {
    
}

extension UIImage {
    static func orEmpty(systemName: String) -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image = UIImage(systemName: systemName, withConfiguration: config)
        
        return UIImage(systemName: systemName, withConfiguration: config) ?? UIImage()
    }
}
