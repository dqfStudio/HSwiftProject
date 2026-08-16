//
//  HAdapterUtils.swift
//  HSwiftProject
//
//  Created by windy on 2025/11/13.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

// swiftlint:disable static_operator
// 当前文件的 |~| 运算符是 fileprivate 全局函数，用于屏幕适配
// 局部禁用该规则，避免 SwiftLint 报「运算符必须是静态函数」警告

/// 是否开启屏幕尺寸适配（适配或者关闭适配）
@objc
enum AdapterType: Int {
    /// 关闭适配
    case none = 0
    /// |~| 开启手机屏幕尺寸适配
    case flex = 1
}

// MARK: - 屏幕尺寸适配
@objcMembers
final class HAdapterUtils: NSObject {
    
    /// 默认是屏幕适配
    ///（外部可全局设置，设置 none 为全局禁止屏幕适配）
    static var fitType: AdapterType = .flex
    
    /// 按照屏幕宽适配，默认 iPhone 6 宽度。必须 > 0。
    static var fitWidth: Double = 375.0 {
        didSet {
            if fitWidth <= 0 {
                fitWidth = oldValue > 0 ? oldValue : 375.0
            }
        }
    }
}

// MARK: - Int CGFloat Double CGSize CGRect UIEdgeInsets扩展的分类
extension Int {
    var fitFloat: CGFloat { CGFloat(self)|~| }
    var fitInt: Int { Int((CGFloat(self)|~|).rounded()) }
}

extension CGFloat {
    var fitFloat: CGFloat { self|~| }
}

extension Double {
    var fitDouble: Double { self|~| }
}

extension CGSize {
    var fitSize: CGSize { self|~| }
}

extension CGRect {
    var fitRect: CGRect { self|~| }
}

extension CGPoint {
    var fitPoint: CGPoint { self|~| }
}

extension UIEdgeInsets {
    var fitEdgeInset: UIEdgeInsets { self|~| }
}

extension UIFont {
    var fitFont: UIFont { withSize(pointSize.fitFloat) }
}

// MARK: - 屏幕尺寸适配 扩展的分类 可以通过类方法调用，也可以通过以上的分类调用，更方便快捷
extension HAdapterUtils {
    static func fitInt(_ value: Int) -> CGFloat { value.fitFloat }
    static func fitFloat(_ value: CGFloat) -> CGFloat { value.fitFloat }
    static func fitDouble(_ value: Double) -> Double { value.fitDouble }
    static func fitPoint(_ value: CGPoint) -> CGPoint { value.fitPoint }
    /// 历史拼写错误，保留以免外部调用编译失败
    static func fitFoint(_ value: CGPoint) -> CGPoint { fitPoint(value) }
    static func fitSize(_ value: CGSize) -> CGSize { value.fitSize }
    static func fitRect(_ value: CGRect) -> CGRect { value.fitRect }
    static func fitEdgeInsets(_ value: UIEdgeInsets) -> UIEdgeInsets { value.fitEdgeInset }
    static func fitFont(_ font: UIFont) -> UIFont { font.fitFont }
}

// MARK: - 屏幕尺寸适配的api 当前文件可访问
fileprivate extension HAdapterUtils {
    
    static func fitSize(_ value: Double) -> Double {
        switch fitType {
        case .none:
            return value
        case .flex:
            let width = fitWidth > 0 ? fitWidth : 375.0
            return value * Double(UIScreen.main.bounds.width) / width
        }
    }
}

// MARK: - 自定义运算符 operator |~|
postfix operator |~|

fileprivate postfix func |~| (value: Double) -> Double {
    HAdapterUtils.fitSize(value)
}

fileprivate postfix func |~| (font: UIFont) -> UIFont {
    font.fitFont
}

fileprivate postfix func |~| (value: Int) -> Int {
    Int((Double(value)|~|).rounded())
}

fileprivate postfix func |~| (value: CGFloat) -> CGFloat {
    CGFloat(Double(value)|~|)
}

fileprivate postfix func |~| (value: CGPoint) -> CGPoint {
    CGPoint(x: Double(value.x)|~|, y: Double(value.y)|~|)
}

fileprivate postfix func |~| (value: CGSize) -> CGSize {
    CGSize(width: value.width|~|, height: value.height|~|)
}

fileprivate postfix func |~| (value: CGRect) -> CGRect {
    CGRect(
        x: value.origin.x|~|,
        y: value.origin.y|~|,
        width: value.size.width|~|,
        height: value.size.height|~|
    )
}

fileprivate postfix func |~| (value: UIEdgeInsets) -> UIEdgeInsets {
    UIEdgeInsets(
        top: value.top|~|,
        left: value.left|~|,
        bottom: value.bottom|~|,
        right: value.right|~|
    )
}
