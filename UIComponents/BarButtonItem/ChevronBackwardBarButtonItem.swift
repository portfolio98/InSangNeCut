//
//  BackBarButtonItem.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/02.
//

import UIKit

final class ChevronBackwardBarButtonItem: BaseBarButtonItem {
    
    convenience init(tintColor: UIColor) {
        self.init()
        self.image = UIImage(systemName: "chevron.backward")
        self.tintColor = tintColor
    }
}

