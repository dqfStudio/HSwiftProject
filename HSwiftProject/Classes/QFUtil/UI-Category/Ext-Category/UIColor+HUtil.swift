//
//  UIColor+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/19.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

func HColorHex(_ hex: String) -> UIColor { return UIColor(hex: hex) }
func HColorHexAlpha(_ hex: String, _ alpha: CGFloat) -> UIColor { return UIColor(hex: hex, alpha: alpha) }

extension UIColor {
    var revertColor: UIColor? {
        guard let colorSpaceModel = self.cgColor.colorSpace?.model, colorSpaceModel == .rgb,
              let components = self.cgColor.components, components.count >= 3 else {
            return nil
        }
        let red: CGFloat = components[0]
        let green: CGFloat = components[1]
        let blue: CGFloat = components[2]
        let alpha: CGFloat = components.count >= 4 ? components[3] : 1.0
        return UIColor(red: 1.0 - red, green: 1.0 - green, blue: 1.0 - blue, alpha: alpha)
    }
    
    public convenience init(hex: String) {

        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex

        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }else if hex.hasPrefix("0X") || hex.hasPrefix("0x") {
            let index = hex.index(hex.startIndex, offsetBy: 2)
            hex = String(hex[index...])
        }

        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red  = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                blue = CGFloat(hexValue & 0x00F) / 15.0
            case 4:
                red  = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                alpha = CGFloat(hexValue & 0x000F) / 15.0
            case 6:
                red  = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                blue = CGFloat(hexValue & 0x0000FF) / 255.0
            case 8:
                red  = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                alpha = CGFloat(hexValue & 0x000000FF) / 255.0
            default:
                print("Invalid RGB string, number of characters after '#'('0x' or '0X') should be either 3, 4, 6 or 8", terminator: "")
            }
        }else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }

    public convenience init(hex: String, alpha: CGFloat) {

        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = alpha
        var hex:   String = hex

        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }else if hex.hasPrefix("0X") || hex.hasPrefix("0x") {
            let index = hex.index(hex.startIndex, offsetBy: 2)
            hex = String(hex[index...])
        }

        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red  = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                blue = CGFloat(hexValue & 0x00F) / 15.0
            case 4:
                red  = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                alpha = CGFloat(hexValue & 0x000F) / 15.0
            case 6:
                red  = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                blue = CGFloat(hexValue & 0x0000FF) / 255.0
            case 8:
                red  = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                alpha = CGFloat(hexValue & 0x000000FF) / 255.0
            default:
                print("Invalid RGB string, number of characters after '#'('0x' or '0X') should be either 3, 4, 6 or 8", terminator: "")
            }
        }else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red:   CGFloat = CGFloat((hex & 0xFF000000) >> 24) / 255.0
        let green: CGFloat = CGFloat((hex & 0x00FF0000) >> 16) / 255.0
        let blue:  CGFloat = CGFloat((hex & 0x0000FF00) >> 8) / 255.0
        let alpha: CGFloat = alpha
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(r: r / 255.0, g: g / 255.0, b: b / 255.0, a: 1.0)
    }
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }

    static var random: UIColor {
        return self.init(red:CGFloat(Int.random(in: 1...256) / 256), green:CGFloat(Int.random(in: 1...256) / 256), blue:CGFloat(Int.random(in: 1...256) / 256), alpha:1.0)
    }

    var isLighterColor: Bool {
        
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        if self.responds(to:#selector(getRed(_:green:blue:alpha:))) {
            self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        }else {
            red  = self.cgColor.components?[0] ?? 0.0
            green = self.cgColor.components?[1] ?? 0.0
            blue = self.cgColor.components?[2] ?? 0.0
        }
        
        var isLighter: Bool = false
        if (red * 0.299 + green * 0.578 + blue * 0.114 >= 0.75) {
            isLighter = true //浅色
        }
        
        return isLighter
    }

    //渐变色
    static func gradientColor(from startColor: UIColor, to endColor: UIColor, size: CGSize) -> UIColor {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return UIColor(patternImage: image)
            }
            UIGraphicsEndImageContext()
        }
        return UIColor.clear
    }

}
