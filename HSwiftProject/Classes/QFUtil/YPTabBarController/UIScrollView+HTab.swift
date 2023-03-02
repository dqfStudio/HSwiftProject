//
//  UIScrollView+HTab.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/2.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import SwizzleSwift

private var minContentSizeHeightKey = "minContentSizeHeightKey"

extension UIScrollView {
    
    var minContentSizeHeight: CGFloat {
        get {
            self.getAssociatedValueForKey(&minContentSizeHeightKey) as? CGFloat ?? 0.0
        }
        set {
            self.setAssociateWeakValue(newValue, key: &minContentSizeHeightKey)
        }
    }
    
//    override class func swizzle() {
//        Swizzle(UIScrollView.self) {
//            #selector(setter: contentSize) <-> #selector(setter: h_contentSize)
//        }
//    }
    
//    @objc private var h_contentSize: CGSize {
//        get {
//            return self.contentSize
//        }
//        set {
//            if (self.contentSize.height < self.minContentSizeHeight) {
//                self.contentSize = CGSize(width: self.contentSize.width, height: self.minContentSizeHeight)
//            }
//            self.contentSize = newValue
//        }
//    }
    
    var h_contentSize: CGSize {
        get {
            return self.contentSize
        }
        set {
            if (self.contentSize.height < self.minContentSizeHeight) {
                self.contentSize = CGSize(width: self.contentSize.width, height: self.minContentSizeHeight)
            }
            self.contentSize = newValue
        }
    }

}
