//
//  HFlowView+FeatureHooks.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//
//  Core 用 responds(to:) 调用可选 Feature，未加入工程则跳过。
//

import UIKit

/// Feature 用 `@objc` 方法挂到 Core 生命周期上。Core 用 `responds(to:)` 探测，未实现则跳过。
/// 字符串必须与 Feature 文件里的方法名一致，改一边会静默失效。
enum HFlowFeatureSelector {
    static let observerSetup = "hflow_observer_setup"
    static let observerDeinit = "hflow_observer_deinit"
    static let memorySetup = "hflow_memory_setup"
    static let emptyLayout = "hflow_empty_layoutSubviews"
    static let emptyReloadData = "hflow_empty_reloadData"
    static let refreshDidScroll = "hflow_refresh_didScroll"
    static let imageSizeWillDisplay = "hflow_imagesize_willDisplay:"
    static let imageSizeClearCache = "hflow_imagesize_clearCache"
    static let refreshClearBlocks = "hflow_refresh_clearBlocks"
    static let memoryRelease = "hflow_memory_release"
    static let configApplyRefresh = "hflow_config_applyRefresh:"
    static let configApplyEmpty = "hflow_config_applyEmpty:"
    static let prerenderSetup = "hflow_prerender_setup"
    static let prerenderWillDisplay = "hflow_prerender_willDisplay:"
    static let prerenderDidScroll = "hflow_prerender_didScroll"
    static let prerenderClear = "hflow_prerender_clear"
}

extension HFlowView {
    /// Feature 文件已加入工程则调用对应 `@objc` 方法，否则直接返回。
    @discardableResult
    func invokeFeature(_ selectorName: String, with object: Any? = nil) -> Unmanaged<AnyObject>? {
        let selector = NSSelectorFromString(selectorName)
        guard responds(to: selector) else { return nil }
        if let object {
            return perform(selector, with: object)
        }
        return perform(selector)
    }

    func invokeFeatures(_ selectorNames: [String]) {
        selectorNames.forEach { invokeFeature($0) }
    }

    /// `deinit` 里用 `sync` 切回主线程，避免 Feature 在后台拆关联对象。
    func hflowRunOnMain(_ body: () -> Void) {
        if Thread.isMainThread {
            body()
        } else {
            DispatchQueue.main.sync(execute: body)
        }
    }
}
