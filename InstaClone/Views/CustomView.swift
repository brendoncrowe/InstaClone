//
//  CustomView.swift
//  InstaClone
//
//  Created by Brendon Crowe on 5/1/23.
//

import UIKit

class CustomView: UIView {
    
    // this is needed so that the inputAccessoryView is properly sized from the auto layout constraints
    // actual value is not important
    
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
}

