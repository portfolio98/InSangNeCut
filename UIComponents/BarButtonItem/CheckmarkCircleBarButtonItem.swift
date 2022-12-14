//
//  CheckmarkCircle.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/02.
//

import UIKit

final class CheckmarkCircleBarButtonItem: BaseBarButtonItem {
    
    convenience init(tintColor: UIColor) {
        self.init()
        self.image = UIImage(systemName: "checkmark.circle")
        self.tintColor = tintColor
    }
}
