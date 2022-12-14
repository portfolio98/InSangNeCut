//
//  PencilCircleBarButtonItem.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/03.
//

import UIKit

final class PencilCircleBarButtonItem: BaseBarButtonItem {
    
    convenience init(tintColor: UIColor) {
        self.init()
        self.image = UIImage(systemName: "pencil.circle")
        self.tintColor = tintColor
    }
}

final class TrashCircleBarButtonItem: BaseBarButtonItem {
    
    convenience init(tintColor: UIColor) {
        self.init()
        self.image = UIImage(systemName: "trash.circle")
        self.tintColor = tintColor
    }
}

