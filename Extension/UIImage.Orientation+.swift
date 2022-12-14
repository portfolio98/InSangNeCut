//
//  UIImage.Orientation+.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/09.
//

//import Foundation
import UIKit

extension UIImage.Orientation {
    static var frontOrientations: [UIImage.Orientation] = [
        .leftMirrored, // 위로 찍을 때
        .downMirrored, // 오른손으로 눕혀서 찍을 때
        .rightMirrored, // 뒤집어서 찍을 때
        .upMirrored // 왼손으로 눕혀서 찍을 때
    ]
    
    static var backOrientations: [UIImage.Orientation] = [
        .right, // 위로 찍을 때
        .up, // 오른손으로 눕혀서 찍을 때
        .left, // 뒤집어서 찍을 때
        .down // 왼손으로 눕혀서 찍을 때
    ]
}
