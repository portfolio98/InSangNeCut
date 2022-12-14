//
//  BaseBarButtonItem.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/02.
//

import UIKit

class BaseBarButtonItem: UIBarButtonItem {
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() { /* override point */ }
}
