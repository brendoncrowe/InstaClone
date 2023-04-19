//
//  UIColor+Extensions.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/18/23.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
