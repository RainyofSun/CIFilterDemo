//
//  UIColorExtension.swift
//  GPUImage3Demo
//
//  Created by 苍蓝猛兽 on 2023/7/21.
//

import UIKit

extension UIColor {
    class func getColorImage(red: Int, green: Int, blue: Int, alpha: Int = 255, rect: CGRect) -> CIImage {
        let color = CIColor(red: CGFloat(Double(red) / 255.0),
                                   green: CGFloat(Double(green) / 255.0),
                                   blue: CGFloat(Double(blue) / 255.0),
                                   alpha: CGFloat(Double(alpha) / 255.0))
        return CIImage(color: color).cropped(to: rect)
    }
}
