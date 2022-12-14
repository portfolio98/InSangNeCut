//
//  UIFont+.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/28.
//

import UIKit

extension UIFont {
    enum FontType {
        enum Pretentdard: String {
            case bold = "Pretendard-Bold"
            case extraBold = "Pretendard-ExtraBold"
            case light = "Pretendard-Light"
            case medium = "Pretendard-Medium"
            case regular = "Pretendard-Regular"
            case semiBold = "Pretendard-semiBold"
        }
    }
    
    static func pretendardFont(size: CGFloat, style: FontType.Pretentdard) -> UIFont {
        return UIFont(name: style.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .semibold)
    }
}
