//
//  GeometryProxy+.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/27.
//

import SwiftUI

public extension GeometryProxy {
    var minSize: CGFloat {
        min(self.size.width, self.size.height)
    }
    
    var maxSize: CGFloat {
        max(self.size.width, self.size.height)
    }
}
