//
//  UIImage+Extensions.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/19/23.
//

import UIKit
import AVFoundation

extension UIImage {
    static func resizeImage(originalImage: UIImage, rect: CGRect) -> UIImage {
        let rect = AVMakeRect(aspectRatio: originalImage.size, insideRect: rect)
        let size = CGSize(width: rect.width, height: rect.height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            originalImage.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
