//
//  HFlowView+Core.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import Combine
import MJRefresh
import SDWebImage
import Kingfisher

// MARK: - Core Functionality
///
/// 核心功能扩展，提供 HFlowView 的基础配置和初始化功能
///
/// 本扩展提供了以下功能：
/// - 框架和布局管理
/// - 初始化设置
/// - 节流刷新配置
/// - 内存警告处理
/// - 缓存管理
extension HFlowView {

    override var frame: CGRect {
        get { super.frame }
        set {
            let adjustedFrame = UIRectIntegral(newValue)
            guard adjustedFrame != super.frame else { return }
            super.frame = adjustedFrame
            // frame 变化仅更新空视图，不再触发全量 reloadData
            if window != nil && Thread.isMainThread {
                updateEmptyViewFrame()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 当 bounds 变化时更新空视图 frame
        updateEmptyViewFrame()
    }
    
    /// Update empty view frame to match current bounds
    internal func updateEmptyViewFrame() {
        subviews.forEach { view in
            if view.tag == Constants.emptyViewTag {
                view.frame = bounds
            }
        }
    }

    /// 初始化 HFlowView 的设置
    ///
    /// 此方法在 HFlowView 初始化时调用，配置各种默认设置，包括：
    /// - 注册全局刷新通知
    /// - 配置外观（背景色、键盘 Dismiss 模式、滚动指示器等）
    /// - 禁用自动内容内边距调整（iOS 11.0+）
    /// - 设置节流刷新
    /// - 监听内存警告
    internal func setup() {
        // 注册全局刷新通知
        HFlowObserver.addObserver(self)

        // 配置外观
        self.backgroundColor = .clear
        self.alwaysBounceVertical = true
        self.keyboardDismissMode = .onDrag
        self.estimatedSectionHeaderHeight = 0.0
        self.estimatedSectionFooterHeight = 0.0
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false

        // 禁用自动内容内边距调整（iOS 11.0+）
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0.0
        }
        
        self.separatorStyle = .none
        self.tableFooterView = UIView()
        
        // 设置自身为数据源和代理
        super.dataSource = self
        
        // 设置节流刷新
        setupRefreshThrottle()
        
        // 初始化各功能模块
        setupAccessibility()
        setupDeviceAdaptation()
        setupHapticFeedback()
        setupNetworkOptimization()
        setupSmartPreloading()
        setupThemeSupport()
        
        // 开始性能监控
        startPerformanceMonitoring()
        
        // 监听内存警告
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    /// 配置刷新节流操作
    ///
    /// 使用 Combine throttle 将短时间内的多次刷新请求合并为一次。
    /// 节流间隔由 `refreshThrottleInterval` 属性控制（默认 0.1 秒）。
    internal func setupRefreshThrottle() {
        cancellables.removeAll()
        refreshSubject
            .throttle(for: .seconds(refreshThrottleInterval), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                self?.reloadFlowData()
            }
            .store(in: &cancellables)
    }
    
    /// 生成唯一标识符
    internal func generateIdentifier(_ cls: AnyClass, _ pre: String?, _ idx: Bool, _ indexPath: IndexPath) -> String {
        var identifier = (pre ?? "") + NSStringFromClass(cls)
        identifier += idx ? "\(indexPath.section)-\(indexPath.row)" : ""
        return identifier
    }
    
    /// 处理内存警告
    @objc internal func handleMemoryWarning() {
        clearCache()
    }
    
    /// 清除缓存
    internal func clearCache() {
        cacheManager.clearAllCache()
        cacheManager.clearImageCache()
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk(onCompletion: {})
        KingfisherManager.shared.cache.clearMemoryCache()
    }
}
