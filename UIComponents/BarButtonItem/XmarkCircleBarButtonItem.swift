//
//  XmarkCircleBarButtonItem.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/02.
//

import UIKit

final class XmarkCircleBarButtonItem: BaseBarButtonItem {
    
    convenience init(tintColor: UIColor) {
        self.init()
        self.image = UIImage(systemName: "xmark.circle")
        self.tintColor = tintColor
    }
}
