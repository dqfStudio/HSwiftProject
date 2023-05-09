//
//  CGRect.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/19.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var kRectEdgeInsetsKey = "kRectEdgeInsetsKey"

extension CGRect {
    
    var x: CGFloat {
        get { return self.origin.x }
        set { self.origin.x = newValue }
    }
    
    var y: CGFloat {
        get { return self.origin.y }
        set { self.origin.y = newValue }
    }
    
    public var width: CGFloat {
        get { return self.size.width }
        set { self.size.width = newValue }
    }
    
    public var height: CGFloat {
        get { return self.size.height }
        set { self.size.height = newValue }
    }
    
    // 根据UIEdgeInsets调整frame
    var edgeInsets: UIEdgeInsets {
        get {
            let edgeInsetsString = objc_getAssociatedObject(self, kRectEdgeInsetsKey) as? String ?? NSCoder.string(for: UIEdgeInsets.zero)
            return NSCoder.uiEdgeInsets(for: edgeInsetsString)
        }
        set {
            if edgeInsets != newValue {
                self = self.inset(by: newValue)
                objc_setAssociatedObject(self, NSCoder.string(for: newValue), kRectEdgeInsetsKey, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
}
