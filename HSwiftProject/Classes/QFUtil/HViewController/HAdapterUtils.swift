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
    
    ///默认是屏幕适配
    ///（外部可全局设置，设置none为全局禁止屏幕适配，默认是屏幕适配）
     static var fitType: AdapterType = AdapterType.flex
    
    /// 按照屏幕宽适配 默认是iphone6 适配标准 可自行修改 适配的标准以宽度为准
    /// 如果修改适配标准，推荐在启动程序时就设置，以免在设置之前使用不准确问题
     static var fitWidth: Double = 375.0
}

// MARK: - Int CGFloat Double CGSize CGRect UIEdgeInsets扩展的分类
extension Int {
    /// Int 屏幕尺寸大小适配
     var fitFloat: CGFloat { return CGFloat(self)|~| }
    
    /// Int 屏幕尺寸大小适配 取整计算
     var fitInt: Int { return Int(CGFloat(self)|~|) }
}

extension CGFloat {
    /// CGFloat 屏幕尺寸大小适配
     var fitFloat: CGFloat { self|~| }
}

extension Double {
    /// Double 屏幕尺寸大小适配
     var fitDouble: Double { self|~| }
}

extension CGSize {
    /// CGSize 屏幕尺寸大小适配
     var fitSize: CGSize { self|~| }
}

extension CGRect {
    /// CGRect 屏幕尺寸大小适配
     var fitRect: CGRect { self|~| }
}

extension CGPoint {
    /// CGPoint 屏幕尺寸大小适配
     var fitPoint: CGPoint { self|~| }
}

extension UIEdgeInsets {
    /// UIEdgeInsets 屏幕尺寸大小适配
     var fitEdgeInset: UIEdgeInsets { self|~| }
}

// MARK: - 屏幕尺寸适配 扩展的分类 可以通过类方法调用，也可以通过以上的分类调用，更方便快捷
extension HAdapterUtils {
    /// Int 屏幕尺寸大小适配
    static func fitInt(_ value: Int) -> CGFloat { value.fitFloat }
    
    /// CGFloat 屏幕尺寸大小适配
    static func fitFloat(_ value: CGFloat) -> CGFloat { value.fitFloat }
    
    /// Double 屏幕尺寸大小适配
    static func fitDouble(_ value: Double) -> Double { value.fitDouble }
    
    /// CGPoint 屏幕尺寸大小适配
    static func fitFoint(_ value: CGPoint) -> CGPoint { value.fitPoint }
    
    /// CGSize 屏幕尺寸大小适配
    static func fitSize(_ value: CGSize) -> CGSize { value.fitSize }
    
    /// CGRect 屏幕尺寸大小适配
    static func fitRect(_ value: CGRect) -> CGRect { value.fitRect }
    
    /// UIEdgeInsets 屏幕尺寸大小适配
    static func fitEdgeInsets(_ value: UIEdgeInsets) -> UIEdgeInsets { value.fitEdgeInset }
}

// MARK: - 屏幕尺寸适配的api 当前文件可访问
fileprivate extension HAdapterUtils {
    
    /// 尺寸适配
    ///
    /// - Parameters:
    ///   - value: 尺寸大小
    static func fitSize( _ value: Double) -> Double {
        switch HAdapterUtils.fitType {
        case .none: return value
        case .flex: return value * Double(UIScreen.main.bounds.width) / HAdapterUtils.fitWidth
        }
    }
}

// MARK: - 自定义运算符 operator |~|
postfix operator |~|

/// 重载运算符
fileprivate postfix func |~| (value: Double) -> Double {
    HAdapterUtils.fitSize(Double(value))
}

fileprivate postfix func |~| (font: UIFont) -> UIFont {
    font.withSize(CGFloat(font.pointSize)|~|)
}

fileprivate postfix func |~| (value: Int) -> Int {
    Int(Double(value)|~|)
}

fileprivate postfix func |~| (value: CGFloat) -> CGFloat {
    CGFloat(Double(value)|~|)
}

fileprivate postfix func |~| (value: CGPoint) -> CGPoint {
    CGPoint(x: Double(value.x)|~|,
            y: Double(value.y)|~|)
}

fileprivate postfix func |~| (value: CGSize) -> CGSize {
    CGSize(width:value.width|~|,
           height: value.height|~|)
    
}

fileprivate postfix func |~| (value: CGRect) -> CGRect {
    CGRect(x:value.origin.x|~|,
           y: value.origin.y|~|,
           width:value.size.width|~|,
           height: value.size.height|~|)
}

fileprivate postfix func |~| (value: UIEdgeInsets) -> UIEdgeInsets {
    UIEdgeInsets(top: value.top|~|,
                 left: value.left|~|,
                 bottom: value.bottom|~|,
                 right: value.right|~|)
}
