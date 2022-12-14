//
//  UIBarButrtonItem+.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/02.
//

import UIKit

final class PlusCircleBarButtonItem: BaseBarButtonItem {
    
    convenience init(tintColor: UIColor) {
        self.init()
        self.image = UIImage(systemName: "plus.circle")
        self.tintColor = tintColor
    }
}
