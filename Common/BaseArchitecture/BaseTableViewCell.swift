//
//  BaseTableViewCell.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/03.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() { /* overrind point*/ }
    
}
