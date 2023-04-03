//
//  UIView+HExtension.swift
//  HSwiftProject
//
//  Created by Wind on 2020/2/21.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

func HColorCreater(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

extension UIView {

    var hc_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var temp = self.frame
            temp.size.height = newValue
            self.frame = temp
        }
    }
    
    var hc_width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var temp = self.frame
            temp.size.width = newValue
            self.frame = temp
        }
    }

    var hc_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var temp = self.frame
            temp.origin.y = newValue
            self.frame = temp
        }
    }
    
    var hc_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var temp = self.frame
            temp.origin.x = newValue
            self.frame = temp
        }
    }

}
