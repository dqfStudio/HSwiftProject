//
//  HGeometry.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

public struct UITBEdgeInsets {

    public var top: CGFloat

    public var bottom: CGFloat

    public init() {
        self.top = 0.0
        self.bottom = 0.0
    }

    public init(top: CGFloat, bottom: CGFloat) {
        self.top = top
        self.bottom = bottom
    }
}

public struct UILREdgeInsets {

    public var left: CGFloat

    public var right: CGFloat

    public init() {
        self.left = 0.0
        self.right = 0.0
    }

    public init(left: CGFloat, right: CGFloat) {
        self.left = left
        self.right = right
    }
}

public struct UILimitInsets {

    public var min: CGFloat

    public var max: CGFloat

    public init() {
        self.min = 0.0
        self.max = 0.0
    }

    public init(min: CGFloat, max: CGFloat) {
        self.min = min
        self.max = max
    }
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

func  UIRectIntegral(_ rect: CGRect) -> CGRect {
    let x: CGFloat = rect.origin.x.rounded(.down)
    let y: CGFloat = rect.origin.y.rounded(.down)
    let width: CGFloat = (rect.origin.x + rect.width - x).rounded(.down)
    let height: CGFloat = (rect.origin.y + rect.height - y).rounded(.down)
    return CGRect(x: x, y: y, width: width, height: height)
}

func UISizeIntegral(_ size: CGSize) -> CGSize {
    return CGSize(width: floor(size.width), height: floor(size.height))
}

public var UILimitInsetsZero = UILimitInsets(min: 0.0, max: 0.0)
public var UITBEdgeInsetsZero = UITBEdgeInsets(top: 0.0, bottom: 0.0)
public var UILREdgeInsetsZero = UILREdgeInsets(left: 0.0, right: 0.0)
public var UIEdgeInsetsZero = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

func UILimitInsetsMake(_ min: CGFloat, _ max: CGFloat) -> UILimitInsets { return UILimitInsets(min: min, max: max) }
func UITBEdgeInsetsMake(_ top: CGFloat, _ bottom: CGFloat) -> UITBEdgeInsets { return UITBEdgeInsets(top: top, bottom: bottom) }
func UILREdgeInsetsMake(_ left: CGFloat, _ right: CGFloat) -> UILREdgeInsets { return UILREdgeInsets(left: left, right: right) }
func UIEdgeInsetsMake(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> UIEdgeInsets { return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right) }
func CGSizeMake(_ width: CGFloat, _ height: CGFloat) -> CGSize { return CGSize(width: width, height: height) }
func CGPointMake(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }


public func NSStringFromUIEdgeInsets(_ edgeInsets: UIEdgeInsets) -> String {
    return NSCoder.string(for: edgeInsets)
}
public func UIEdgeInsetsFromString(_ namestr: String) -> UIEdgeInsets {
    return NSCoder.uiEdgeInsets(for: namestr)
}

public func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}
