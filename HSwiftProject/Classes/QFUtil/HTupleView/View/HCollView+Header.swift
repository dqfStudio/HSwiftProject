//
//  HCollView+Header.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/6.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// 刷新头部样式
enum HCollRefreshHeaderStyle {
    case gray
    case red
}

/// 刷新底部样式
enum HCollRefreshFooterStyle {
    case style1
    case style2
}

enum HCollDirection {
    case vertical // Vertical design
    case horizontal // Horizontal design
}

enum HCollItemLayout {
    case manual // Manual
    case automatic // Automatic
}

/// 对齐方式
enum HCollAlign {
    case `default` // 垂直居上，水平居左
    case center // 垂直居中，水平居中
    case top(CGFloat) // 垂直距离顶部的距离，水平居中
    case ratio(CGFloat) // 垂直距离顶部的比例，水平居中
    case bottom(CGFloat) // 垂直距离底部的距离，水平居中
}

/// 页码配置
struct HCollPageConfig {
    static let defaultPageNo = 1
    static let defaultPageSize = 20
    static let maxTotalPages = 10000
}

// MARK: - 常量定义
/// 默认标签值，用于标识 HCollView 实例
let kCollDefaultTag = 1213141516

// MARK: - Associated Object Keys
/// 信号键，用于关联对象存储
let kCollSignalKey = UnsafeRawPointer(bitPattern: 1)!

/// 刷新回调
typealias HCollRefreshBlock = () -> Void

/// 加载更多回调
typealias HCollLoadMoreBlock = () -> Void

/// 点击内容区域外部回调闭包
typealias HCollOutsideCntBlock = () -> Void

/// 内容尺寸变化回调闭包
typealias HCollCntSizeBlock = (_ cntSize: CGSize) -> Void

