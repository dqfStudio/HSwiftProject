//
//  HCollView+Config.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//
//  一次性套用外观、分页、吸顶。Refresh / EmptyView 未加入工程时对应项跳过。
//

import UIKit

struct HCollViewConfig {
    var backgroundColor: UIColor = .clear
    var showsScrollIndicators = false
    var keyboardDismissMode: UIScrollView.KeyboardDismissMode = .onDrag
    var refreshThrottleInterval: TimeInterval = HCollView.Constants.defaultRefreshThrottleInterval
    var itemRefreshThrottleInterval: TimeInterval = HCollView.Constants.defaultItemRefreshThrottleInterval
    var pageNo = HCollPageConfig.defaultPageNo
    var pageSize = HCollPageConfig.defaultPageSize
    var totalNo = HCollPageConfig.maxTotalPages
    var preloadEnabled = true
    var emptyViewEnabled = true
    var refreshHeaderStyleRaw = 0
    var refreshFooterStyleRaw = 0
    var sectionHeadersPinToVisibleBounds = false
    var sectionFootersPinToVisibleBounds = false
}

extension HCollView {

    /// 一次性套用外观、分页、吸顶。Refresh / EmptyView 未加入工程时对应项会被忽略。
    func apply(_ config: HCollViewConfig = HCollViewConfig()) {
        backgroundColor = config.backgroundColor
        showsVerticalScrollIndicator = config.showsScrollIndicators
        showsHorizontalScrollIndicator = config.showsScrollIndicators
        keyboardDismissMode = config.keyboardDismissMode
        refreshThrottleInterval = config.refreshThrottleInterval
        itemRefreshThrottleInterval = config.itemRefreshThrottleInterval
        pageNo = config.pageNo
        pageSize = config.pageSize
        totalNo = config.totalNo
        preloadEnabled = config.preloadEnabled
        sectionHeadersPinToVisibleBounds = config.sectionHeadersPinToVisibleBounds
        sectionFootersPinToVisibleBounds = config.sectionFootersPinToVisibleBounds

        invokeFeature(
            HCollFeatureSelector.configApplyRefresh,
            with: [
                "header": config.refreshHeaderStyleRaw,
                "footer": config.refreshFooterStyleRaw
            ] as NSDictionary
        )
        invokeFeature(
            HCollFeatureSelector.configApplyEmpty,
            with: NSNumber(value: config.emptyViewEnabled)
        )
    }
}
