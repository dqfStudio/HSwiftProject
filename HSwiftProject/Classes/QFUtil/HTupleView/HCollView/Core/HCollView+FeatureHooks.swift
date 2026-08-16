//
//  HCollView+FeatureHooks.swift
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
enum HCollFeatureSelector {
    static let observerSetup = "hcoll_observer_setup"
    static let observerDeinit = "hcoll_observer_deinit"
    static let memorySetup = "hcoll_memory_setup"
    static let alignLayout = "hcoll_align_layoutSubviews"
    static let emptyLayout = "hcoll_empty_layoutSubviews"
    static let emptyReloadData = "hcoll_empty_reloadData"
    static let refreshDidScroll = "hcoll_refresh_didScroll"
    static let imageSizeWillDisplay = "hcoll_imagesize_willDisplay:"
    static let imageSizeClearCache = "hcoll_imagesize_clearCache"
    static let refreshClearBlocks = "hcoll_refresh_clearBlocks"
    static let memoryRelease = "hcoll_memory_release"
    static let configApplyRefresh = "hcoll_config_applyRefresh:"
    static let configApplyEmpty = "hcoll_config_applyEmpty:"
}

extension HCollView {
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
    func hcollRunOnMain(_ body: () -> Void) {
        if Thread.isMainThread {
            body()
        } else {
            DispatchQueue.main.sync(execute: body)
        }
    }
}
