//
//  HCollView+Header.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/6.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

enum HCollStyle {
    case coll // Singleton design
    case split // Split design
}

enum HCollDirection {
    case vertical // Vertical design
    case horizontal // Horizontal design
}

enum HCollItemLayout {
    case manual // Manual
    case automatic // Automatic
}

enum HCollAlign {
    case `default` // 垂直居上，水平居左
    case center // 垂直居中，水平居中
    case top(CGFloat) // 垂直距离顶部的距离，水平居中
    case ratio(CGFloat) // 垂直距离顶部的比例，水平居中
    case bottom(CGFloat) // 垂直距离底部的距离，水平居中
}

var kCollDefaultTag = 1213141516

var kCollPageNo = 1
var kCollPageSize = 20
var kCollTotalPageNo = 10000

var kCollDesignKey = "coll"
var kCollExaDesignKey = "collExa"

var kCollStateKey: Void?
var kCollSignalKey: Void?
var kCollStateSourceKey: Void?

/// Refresh & LoadMore block
typealias HCollRefreshBlock = () -> Void
typealias HCollLoadMoreBlock = () -> Void
typealias HCollOutsideCntBlock = () -> Void
typealias HCollCntSizeBlock = (_ cntSize: CGSize) -> Void


class HCollReload: NSObject {
    var isRefresh = false //是否正在刷新
    var needRefresh = false //是否需要刷新
}
