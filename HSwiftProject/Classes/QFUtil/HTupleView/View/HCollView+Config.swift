//
//  HCollView+Config.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 配置类
///
/// 集中管理 HCollView 的所有配置选项
class HCollViewConfig {
    
    // MARK: - 单例
    static let shared = HCollViewConfig()
    private init() {}
    
    // MARK: - 布局配置
    
    /// 默认列数
    var defaultColumnCount: Int = 2
    
    /// 默认行间距
    var defaultLineSpacing: CGFloat = 10.0
    
    /// 默认 item 间距
    var defaultInteritemSpacing: CGFloat = 10.0
    
    /// 默认 section 内边距
    var defaultSectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    /// 默认 header 高度
    var defaultHeaderHeight: CGFloat = 0.0
    
    /// 默认 footer 高度
    var defaultFooterHeight: CGFloat = 0.0
    
    // MARK: - 刷新配置
    
    /// 默认刷新头部样式
    var defaultRefreshHeaderStyle: HCollRefreshHeaderStyle = .gray
    
    /// 默认加载更多底部样式
    var defaultRefreshFooterStyle: HCollRefreshFooterStyle = .style1
    
    /// 默认刷新节流间隔
    var defaultRefreshThrottleInterval: TimeInterval = 2.0
    
    /// 默认 item 刷新节流间隔
    var defaultItemRefreshThrottleInterval: TimeInterval = 0.25
    
    // MARK: - 缓存配置
    
    /// 默认最大追踪 cell 数量
    var defaultMaxTrackedCells: Int = 20
    
    /// 默认预加载距离比例
    var defaultPreloadDistanceRatio: CGFloat = 0.1
    
    /// 默认最小预加载距离
    var defaultMinPreloadDistance: CGFloat = 100.0
    
    // MARK: - 动画配置
    
    /// 默认动画类型
    var defaultAnimationType: HCollView.AnimationType = .fade
    
    /// 默认动画持续时间
    var defaultAnimationDuration: TimeInterval = 0.5
    
    // MARK: - 分页配置
    
    /// 默认页码
    var defaultPageNo: Int = 1
    
    /// 默认每页数量
    var defaultPageSize: Int = 20
    
    /// 默认总页数上限
    var defaultMaxTotalPages: Int = 10000
    
    // MARK: - 外观配置
    
    /// 默认背景色
    var defaultBackgroundColor: UIColor = .clear
    
    /// 默认滚动指示器显示状态
    var defaultShowsScrollIndicators: Bool = false
    
    /// 默认键盘 dismiss 模式
    var defaultKeyboardDismissMode: UIScrollView.KeyboardDismissMode = .onDrag
    
    // MARK: - 功能配置
    
    /// 默认预加载启用状态
    var defaultPreloadEnabled: Bool = true
    
    /// 默认空视图启用状态
    var defaultEmptyViewEnabled: Bool = true
    
    /// 默认头部固定状态
    var defaultSectionHeadersPinToVisibleBounds: Bool = false
    
    /// 默认底部固定状态
    var defaultSectionFootersPinToVisibleBounds: Bool = false
    
    // MARK: - 重置为默认配置
    
    /// 重置为默认配置
    func resetToDefaults() {
        defaultColumnCount = 2
        defaultLineSpacing = 10.0
        defaultInteritemSpacing = 10.0
        defaultSectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        defaultHeaderHeight = 0.0
        defaultFooterHeight = 0.0
        defaultRefreshHeaderStyle = .gray
        defaultRefreshFooterStyle = .style1
        defaultRefreshThrottleInterval = 2.0
        defaultItemRefreshThrottleInterval = 0.25
        defaultMaxTrackedCells = 20
        defaultPreloadDistanceRatio = 0.1
        defaultMinPreloadDistance = 100.0
        defaultAnimationType = .fade
        defaultAnimationDuration = 0.5
        defaultPageNo = 1
        defaultPageSize = 20
        defaultMaxTotalPages = 10000
        defaultBackgroundColor = .clear
        defaultShowsScrollIndicators = false
        defaultKeyboardDismissMode = .onDrag
        defaultPreloadEnabled = true
        defaultEmptyViewEnabled = true
        defaultSectionHeadersPinToVisibleBounds = false
        defaultSectionFootersPinToVisibleBounds = false
    }
}

/// HCollView 配置扩展
///
/// 提供基于配置的初始化和设置方法
extension HCollView {
    
    /// 使用默认配置初始化
    convenience init(frame: CGRect, withDefaultConfig: Bool) {
        self.init(frame: frame)
        applyDefaultConfig()
    }
    
    /// 应用默认配置
    func applyDefaultConfig() {
        let config = HCollViewConfig.shared
        
        // 外观配置
        backgroundColor = config.defaultBackgroundColor
        showsVerticalScrollIndicator = config.defaultShowsScrollIndicators
        showsHorizontalScrollIndicator = config.defaultShowsScrollIndicators
        keyboardDismissMode = config.defaultKeyboardDismissMode
        
        // 刷新配置
        refreshThrottleInterval = config.defaultRefreshThrottleInterval
        itemRefreshThrottleInterval = config.defaultItemRefreshThrottleInterval
        refreshHeaderStyle = config.defaultRefreshHeaderStyle
        refreshFooterStyle = config.defaultRefreshFooterStyle
        
        // 分页配置
        pageNo = config.defaultPageNo
        pageSize = config.defaultPageSize
        totalNo = config.defaultMaxTotalPages
        
        // 功能配置
        preloadEnabled = config.defaultPreloadEnabled
        emptyViewEnabled = config.defaultEmptyViewEnabled
        sectionHeadersPinToVisibleBounds = config.defaultSectionHeadersPinToVisibleBounds
        sectionFootersPinToVisibleBounds = config.defaultSectionFootersPinToVisibleBounds
    }
    
    /// 应用自定义配置
    /// - Parameter configBlock: 配置闭包
    func applyConfig(_ configBlock: (HCollViewConfig) -> Void) {
        let config = HCollViewConfig.shared
        configBlock(config)
        applyDefaultConfig()
    }
    
    /// 重置为默认配置
    func resetToDefaultConfig() {
        HCollViewConfig.shared.resetToDefaults()
        applyDefaultConfig()
    }
}
