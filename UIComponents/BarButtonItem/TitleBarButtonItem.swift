//
//  TitleBarButtonItem.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/02.
//

import UIKit

final class TitleBarButtonItem: BaseBarButtonItem {
    
    convenience init(title: String) {
        self.init()
        self.tintColor = .darkGray
        self.title = title
        
        let font = UIFont.pretendardFont(size: 16, style: .semiBold)
        self.setTitleTextAttributes([.font: font], for: .normal)
    }
}
