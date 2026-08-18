//
//  HFlowView+Config.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//
//  一次性套用外观、分页。Refresh / EmptyView 未加入工程时对应项跳过。
//

import UIKit

/// 一次性套用的外观与分页参数。Refresh / EmptyView 未加入工程时对应字段会被忽略。
struct HFlowViewConfig {
    var backgroundColor: UIColor = .clear
    var showsScrollIndicators = false
    var keyboardDismissMode: UIScrollView.KeyboardDismissMode = .onDrag
    var refreshThrottleInterval: TimeInterval = HFlowView.Constants.defaultRefreshThrottleInterval
    var itemRefreshThrottleInterval: TimeInterval = HFlowView.Constants.defaultItemRefreshThrottleInterval
    var pageNo = HFlowPageConfig.defaultPageNo
    var pageSize = HFlowPageConfig.defaultPageSize
    var totalNo = HFlowPageConfig.maxTotalPages
    var preloadEnabled = true
    var emptyViewEnabled = true
    var refreshHeaderStyleRaw = 0
    var refreshFooterStyleRaw = 0
}

extension HFlowView {

    /// 一次性套用外观、分页。Refresh / EmptyView 未加入工程时对应项会被忽略。
    func apply(_ config: HFlowViewConfig = HFlowViewConfig()) {
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

        invokeFeature(
            HFlowFeatureSelector.configApplyRefresh,
            with: [
                "header": config.refreshHeaderStyleRaw,
                "footer": config.refreshFooterStyleRaw
            ] as NSDictionary
        )
        invokeFeature(
            HFlowFeatureSelector.configApplyEmpty,
            with: NSNumber(value: config.emptyViewEnabled)
        )
    }
}
