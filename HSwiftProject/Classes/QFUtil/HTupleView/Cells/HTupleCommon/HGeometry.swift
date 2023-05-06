//
//  HGeometry.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

public struct UITBEdgeInsets {
    public var top: CGFloat = 0.0
    public var bottom: CGFloat = 0.0

    // Use default initializer in combination with default values
    public init(top: CGFloat = 0.0, bottom: CGFloat = 0.0) {
        self.top = top
        self.bottom = bottom
    }
    
    // Define zero as an instance of the struct
    static let zero = UITBEdgeInsets(top: 0.0, bottom: 0.0)
}

public struct UILREdgeInsets {
    public var left: CGFloat
    public var right: CGFloat
    
    // Use default initializer in combination with default values
    public init(left: CGFloat = 0.0, right: CGFloat = 0.0) {
        self.left = left
        self.right = right
    }
    
    // Define zero as an instance of the struct
    static let zero = UILREdgeInsets(left: 0.0, right: 0.0)
}

public struct UILimitInsets {
    public var min: CGFloat
    public var max: CGFloat
    
    // Use default initializer in combination with default values
    public init(min: CGFloat = 0.0, max: CGFloat = 0.0) {
        self.min = min
        self.max = max
    }
    
    // Define zero as an instance of the struct
    static let zero = UILimitInsets(min: 0.0, max: 0.0)
}


extension UITBEdgeInsets : Equatable {
    public static func == (lhs: UITBEdgeInsets, rhs: UITBEdgeInsets) -> Bool {
        return (lhs.top == rhs.top && lhs.bottom == rhs.bottom)
    }
}

extension UILREdgeInsets : Equatable {
    public static func == (lhs: UILREdgeInsets, rhs: UILREdgeInsets) -> Bool {
        return (lhs.left == rhs.left && lhs.right == rhs.right)
    }
}

extension UILimitInsets : Equatable {
    public static func == (lhs: UILimitInsets, rhs: UILimitInsets) -> Bool {
        return (lhs.min == rhs.min && lhs.max == rhs.max)
    }
}

func UIRectIntegral(_ rect: CGRect) -> CGRect {
    let x: CGFloat = rect.origin.x.rounded(.down)
    let y: CGFloat = rect.origin.y.rounded(.down)
    let width: CGFloat = (rect.origin.x + rect.width - x).rounded(.down)
    let height: CGFloat = (rect.origin.y + rect.height - y).rounded(.down)
    return CGRect(x: x, y: y, width: width, height: height)
}

func UISizeIntegral(_ size: CGSize) -> CGSize {
    return CGSize(width: floor(size.width), height: floor(size.height))
}

public func NSStringFromUIEdgeInsets(_ edgeInsets: UIEdgeInsets) -> String {
    return NSCoder.string(for: edgeInsets)
}

public func UIEdgeInsetsFromString(_ namestr: String) -> UIEdgeInsets {
    return NSCoder.uiEdgeInsets(for: namestr)
}
