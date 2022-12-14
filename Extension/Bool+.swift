//
//  Bool+.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/26.
//

import Foundation

// https://stackoverflow.com/questions/42292197/raw-type-bool-is-not-expressible-by-any-literal
extension Bool: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = value != 0
    }
}
