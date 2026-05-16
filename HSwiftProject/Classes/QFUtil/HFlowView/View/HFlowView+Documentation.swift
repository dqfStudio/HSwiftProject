//
//  HFlowView+Documentation.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// HFlowView 文档与示例扩展
///
/// 提供详细的文档和使用示例，包括给开发者和AI系统的结构化文档
///
/// - Note: 本扩展包含完整的API文档、使用指南、示例代码和常见问题解答
/// - Version: 1.0.0
/// - LastUpdated: 2026-04-19
/// - Author: HSwiftProject Team
///
/// HFlowView 是一个功能强大的表视图扩展，提供了丰富的布局类型、交互模式和性能优化功能。
/// 本文档旨在帮助开发者快速了解和使用 HFlowView 的所有功能，同时也为 AI 系统提供结构化的文档信息。
extension HFlowView {
    
    /// 文档管理器
    ///
    /// 提供全面的文档和使用示例，帮助开发者快速上手HFlowView
    ///
    /// - Note: 文档管理器采用单例模式，确保全局只有一个实例
    /// - Version: 1.0.0
    ///
    /// 文档管理器负责管理 HFlowView 的所有文档内容，包括使用指南、API文档、示例代码和常见问题解答。
    class DocumentationManager {
        
        // MARK: - 单例
        /// 文档管理器单例
        static let shared = DocumentationManager()
        private init() {}
        
        // MARK: - 方法
        
        /// 获取使用指南
        ///
        /// 提供 HFlowView 的详细使用指南，包含基本用法和高级用法
        ///
        /// - Returns: 详细的使用指南，包含基本用法和高级用法
        /// - Version: 1.0.0
        ///
        /// 使用指南包括 HFlowView 的创建、布局设置、交互模式设置、内容加载、性能优化等方面的详细说明和示例代码。
        func getUsageGuide() -> String {
            return """
            # HFlowView 使用指南
            
            ## 1. 基本用法
            
            ### 1.1 创建 HFlowView
            ```swift
            // 创建 HFlowView 实例
            let hFlowView = HFlowView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
            hFlowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(hFlowView)
            
            // 设置代理
            hFlowView.delegate = self
            ```
            
            ### 1.2 设置刷新和加载更多
            ```swift
            // 设置下拉刷新
            hFlowView.refreshBlock = {
                print("开始刷新")
                // 模拟网络请求
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.loadData()
                    self.hFlowView.endRefreshing {}
                }
            }
            
            // 设置上拉加载更多
            hFlowView.loadMoreBlock = {
                print("开始加载更多")
                // 模拟网络请求
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.loadMoreData()
                    self.hFlowView.endLoadMore {}
                }
            }
            ```
            
            ### 1.3 配置空视图
            ```swift
            // 设置默认空视图
            hFlowView.setDefaultEmptyView(title: "暂无数据", message: "下拉刷新重试")
            
            // 或者创建自定义空视图
            let emptyView = UIView()
            emptyView.backgroundColor = .lightGray
            
            let label = UILabel()
            label.text = "暂无数据"
            label.textAlignment = .center
            label.textColor = .gray
            label.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
            label.center = emptyView.center
            
            emptyView.addSubview(label)
            
            // 设置空视图
            hFlowView.emptyView = emptyView
            ```
            
            ### 1.4 滚动控制
            ```swift
            // 滚动到顶部
            hFlowView.scrollToTop(animated: true)
            
            // 滚动到底部
            hFlowView.scrollToBottom(animated: true)
            
            // 滚动到指定索引路径
            let indexPath = IndexPath(row: 5, section: 0)
            hFlowView.scrollToIndexPath(indexPath, at: .middle, animated: true)
            ```
            
            ### 1.5 性能优化
            ```swift
            // 启用内存监控
            hFlowView.enableMemoryMonitoring()
            
            // 清理缓存
            hFlowView.clearCache()
            
            // 启用预加载
            hFlowView.preloadBlock = {
                print("触发预加载")
                // 这里可以添加预加载逻辑
            }
            ```
            
            ## 2. 高级用法
            
            ### 2.1 分页管理
            ```swift
            // 初始化分页
            hFlowView.setupPagination(pageSize: 20, initialPage: 1, refresh: {
                // 刷新逻辑
                self.loadData()
            }, loadMore: {
                // 加载更多逻辑
                self.loadMoreData()
            })
            
            // 结束刷新
            hFlowView.endRefresh(totalItems: 100, pageSize: 20)
            
            // 结束加载更多
            hFlowView.endLoadMore(totalItems: 100, pageSize: 20)
            ```
            
            ### 2.2 批量刷新
            ```swift
            // 批量刷新指定的索引路径
            let indexPaths = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)]
            hFlowView.reloadItemsIfNeeded(at: indexPaths)
            
            // 节流刷新（防抖）
            hFlowView.reloadIfNeeded()
            ```
            
            ### 2.3 自定义刷新
            ```swift
            // 设置自定义下拉刷新头部
            let customHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: hFlowView.bounds.width, height: 60))
            // 配置自定义头部视图
            hFlowView.setCustomRefreshHeader(customHeaderView) {
                // 刷新逻辑
            }
            
            // 设置自定义上拉加载更多底部
            let customFooterView = UIView(frame: CGRect(x: 0, y: 0, width: hFlowView.bounds.width, height: 60))
            // 配置自定义底部视图
            hFlowView.setCustomLoadMoreFooter(customFooterView) {
                // 加载更多逻辑
            }
            ```
            
            ### 2.4 内存管理
            ```swift
            // 监听内存警告
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleMemoryWarning),
                name: UIApplication.didReceiveMemoryWarningNotification,
                object: nil
            )
            
            @objc private func handleMemoryWarning() {
                hFlowView.clearCache()
            }
            ```
            
            ### 2.5 观察者模式
            ```swift
            // 注册为观察者
            hFlowView.registerAsObserver()
            
            // 通知所有 HFlowView 实例刷新
            HFlowView.notifyAllRefresh()
            
            // 移除观察者
            hFlowView.removeObserver()
            ```
            
            ### 2.6 性能监控
            ```swift
            // 开始性能监控
            hFlowView.startPerformanceMonitoring()
            
            // 获取性能统计信息
            // if let stats = hFlowView.getPerformanceStatistics() {
            //     print("帧率: stats.frameRate")
            //     print("内存使用: stats.memoryUsage MB")
            //     print("网络请求平均耗时: stats.averageNetworkRequestTime ms")
            //     print("缓存命中率: stats.cacheHitRate")
            // }
            
            // 重置性能统计信息
            hFlowView.resetPerformanceStatistics()
            ```
            
            ### 2.7 微交互
            ```swift
            // 启用微交互
            hFlowView.enableMicroInteraction = true
            
            // 配置微交互参数
            hFlowView.microInteractionConfig = HFlowMicroInteractionConfig(
                pressScale: 0.95,
                pressDuration: 0.1,
                highlightColor: .lightGray.withAlphaComponent(0.3)
            )
            ```
            
            ### 2.8 骨架屏
            ```swift
            // 启用骨架屏
            hFlowView.enableSkeleton = true
            
            // 配置骨架屏
            hFlowView.skeletonConfig = HFlowSkeletonConfig(
                lineHeight: 15,
                lineSpacing: 10,
                lineCount: 3,
                animationDuration: 1.5
            )
            
            // 显示骨架屏
            hFlowView.showSkeleton()
            
            // 隐藏骨架屏
            hFlowView.hideSkeleton()
            ```
            
            ### 2.9 智能预加载
            ```swift
            // 启用智能预加载
            hFlowView.preloadManager.enablePreloading = true
            
            // 配置预加载参数
            hFlowView.preloadManager.preloadOffset = 1000 // 预加载触发距离
            hFlowView.preloadManager.preloadThreshold = 3 // 预加载阈值
            ```
            
            ### 2.10 SwiftUI集成
            ```swift
            // 在SwiftUI中使用HFlowView
            struct HFlowViewSwiftUI: View {
                var body: some View {
                    HFlowViewWrapper { flowView in
                        // 配置HFlowView
                        flowView.delegate = self
                        flowView.refreshBlock = {
                            // 刷新逻辑
                        }
                    }
                }
            }
            ```
            
            ### 2.11 主题支持
            ```swift
            // 启用跟随系统主题
            hFlowView.followSystemTheme = true

            // 手动设置主题
            hFlowView.currentTheme = HFlowTheme(
                type: .light,
                colors: HFlowThemeColors(
                    backgroundColor: .white,
                    textColor: .black
                ),
                fonts: HFlowThemeFonts()
            )
            ```
            
            ### 2.12 设备适配
            ```swift
            // 设备适配自动生效，可直接查询设备信息
            if hFlowView.isiPhone { ... }
            if hFlowView.hasSafeArea { ... }
            
            // 获取当前设备类型
            // if let deviceType = hFlowView.currentDeviceType {
            //     print("当前设备类型: deviceType")
            // }
            
            // 获取当前设备方向
            // let deviceOrientation = UIDevice.current.orientation
            // print("当前设备方向: deviceOrientation")
            ```
            
            ### 2.13 触觉反馈
            ```swift
            // 启用触觉反馈（默认已启用）
            var config = hFlowView.hapticFeedbackConfig
            config.enabled = true
            hFlowView.hapticFeedbackConfig = config
            
            // 触发触觉反馈
            hFlowView.triggerHapticFeedback(type: .light)
            ```
            
            ### 2.14 无障碍支持
            ```swift
            // 启用无障碍支持
            hFlowView.enableAccessibility = true
            
            // 为cell添加无障碍标签
            func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath) -> UITableViewCell? {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = dataSource[indexPath.row]
                
                // 添加无障碍标签
                cell.accessibilityLabel = "项目 indexPath.row + 1"
                cell.accessibilityValue = dataSource[indexPath.row]
                cell.accessibilityTraits = .button
                
                return cell
            }
            ```
            
            ### 2.15 异步布局
            ```swift
            // 启用异步布局
            hFlowView.enableAsyncLayout = true
            
            // 配置异步布局参数
            hFlowView.asyncLayoutConfig = HFlowAsyncLayoutConfig(
                enabled: true,
                concurrentOperations: 2
            )
            ```
            """
        }
        
        /// 获取 API 文档
        ///
        /// 提供 HFlowView 的详细 API 文档，包含所有方法和属性的说明
        ///
        /// - Returns: 详细的 API 文档，包含所有方法和属性的说明
        /// - Version: 1.0.0
        ///
        /// API 文档包括 HFlowView 的所有方法的签名、参数说明、返回值、功能描述和使用场景。
        func getAPIDocumentation() -> String {
            return """
            # HFlowView API 文档
            
            ## 1. 核心功能
            
            ### 1.1 初始化
            
            #### init(frame: CGRect)
            ```swift
            convenience init(frame: CGRect)
            ```
            - **参数**:
              - `frame`: 视图的 frame
            - **功能**: 使用指定的 frame 初始化 HFlowView
            - **使用场景**: 当需要以代码方式创建 HFlowView 时使用
            
            #### init(frame: CGRect, style: UITableView.Style)
            ```swift
            override init(frame: CGRect, style: UITableView.Style)
            ```
            - **参数**:
              - `frame`: 视图的 frame
              - `style`: 表格的样式
            - **功能**: 使用指定的 frame 和 style 初始化 HFlowView
            - **使用场景**: 当需要指定表格样式创建 HFlowView 时使用
            
            ### 1.2 代理方法
            
            #### HFlowViewDelegate
            ```swift
            protocol HFlowViewDelegate: UITableViewDelegate {
                func numberOfSectionsInFlowView() -> Int
                func numberOfRowsInSection(_ section: Int) -> Int
                func heightForHeaderInSection(_ section: Int) -> CGFloat
                func heightForFooterInSection(_ section: Int) -> CGFloat
                func heightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat
                func flowHeader(_ flow: HFlowView, inSection section: Int) -> UIView?
                func flowFooter(_ flow: HFlowView, inSection section: Int) -> UIView?
                func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath) -> UITableViewCell?
                func willDisplayCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
                func didEndDisplayingCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
                func didSelectCell(_ indexPath: IndexPath)
                func flowViewDidScroll(_ scrollView: UIScrollView)
                func flowViewDidScrollToTop(_ scrollView: UIScrollView)
                func flowViewWillBeginDragging(_ scrollView: UIScrollView)
                func flowViewWillEndDragging(_ velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
                func flowViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
                func flowViewDidEndDecelerating(_ scrollView: UIScrollView)
            }
            ```
            - **功能**: 定义了 HFlowView 的代理方法，用于提供数据和处理事件
            - **使用场景**: 当需要为 HFlowView 提供数据和处理事件时使用
            
            ## 2. 刷新和加载更多
            
            ### 2.1 刷新方法
            
            #### setupRefreshBlock
            ```swift
            var refreshBlock: (() -> Void)?
            ```
            - **功能**: 设置下拉刷新的回调
            - **使用场景**: 当需要实现下拉刷新功能时使用
            
            #### setupLoadMoreBlock
            ```swift
            var loadMoreBlock: (() -> Void)?
            ```
            - **功能**: 设置上拉加载更多的回调
            - **使用场景**: 当需要实现上拉加载更多功能时使用
            
            #### beginRefreshing
            ```swift
            func beginRefreshing(_ completion: @escaping () -> Void)
            ```
            - **参数**:
              - `completion`: 完成回调
            - **功能**: 开始下拉刷新
            - **使用场景**: 当需要手动触发下拉刷新时使用
            
            #### endRefreshing
            ```swift
            func endRefreshing(_ completion: @escaping () -> Void)
            ```
            - **参数**:
              - `completion`: 完成回调
            - **功能**: 结束下拉刷新
            - **使用场景**: 当下拉刷新完成时使用
            
            #### endLoadMore
            ```swift
            func endLoadMore(_ completion: @escaping () -> Void)
            ```
            - **参数**:
              - `completion`: 完成回调
            - **功能**: 结束上拉加载更多
            - **使用场景**: 当上拉加载更多完成时使用
            
            #### endLoadMoreWithNoMoreData
            ```swift
            func endLoadMoreWithNoMoreData(_ completion: @escaping () -> Void)
            ```
            - **参数**:
              - `completion`: 完成回调
            - **功能**: 结束加载更多（无更多数据）
            - **使用场景**: 当没有更多数据时使用
            
            #### resetNoMoreData
            ```swift
            func resetNoMoreData(_ completion: @escaping () -> Void)
            ```
            - **参数**:
              - `completion`: 完成回调
            - **功能**: 重置无更多数据状态
            - **使用场景**: 当需要重新启用加载更多时使用
            
            ## 3. 滚动控制
            
            ### 3.1 滚动方法
            
            #### scrollToTop
            ```swift
            func scrollToTop(animated: Bool = true)
            ```
            - **参数**:
              - `animated`: 是否带动画
            - **功能**: 滚动到顶部
            - **使用场景**: 当需要滚动到列表顶部时使用
            
            #### scrollToBottom
            ```swift
            func scrollToBottom(animated: Bool = true)
            ```
            - **参数**:
              - `animated`: 是否带动画
            - **功能**: 滚动到底部
            - **使用场景**: 当需要滚动到列表底部时使用
            
            #### scrollToIndexPath
            ```swift
            func scrollToIndexPath(_ indexPath: IndexPath, at position: UITableView.ScrollPosition = .middle, animated: Bool = true)
            ```
            - **参数**:
              - `indexPath`: 索引路径
              - `position`: 滚动位置
              - `animated`: 是否带动画
            - **功能**: 滚动到指定索引路径
            - **使用场景**: 当需要滚动到列表指定位置时使用
            
            ## 4. 空视图
            
            ### 4.1 空视图方法
            
            #### setDefaultEmptyView
            ```swift
            func setDefaultEmptyView(title: String = "暂无数据", message: String = "下拉刷新重试", image: UIImage? = nil)
            ```
            - **参数**:
              - `title`: 空视图标题
              - `message`: 空视图消息
              - `image`: 空视图图片
            - **功能**: 设置默认空视图
            - **使用场景**: 当需要显示默认空视图时使用
            
            #### emptyView
            ```swift
            var emptyView: UIView?
            ```
            - **功能**: 自定义空视图
            - **使用场景**: 当需要显示自定义空视图时使用
            
            #### emptyViewEnabled
            ```swift
            var emptyViewEnabled: Bool = true
            ```
            - **功能**: 空视图是否启用
            - **使用场景**: 当需要启用或禁用空视图时使用
            
            ## 5. 性能优化
            
            ### 5.1 性能优化方法
            
            #### clearCache
            ```swift
            internal func clearCache()
            ```
            - **功能**: 清除缓存
            - **使用场景**: 当需要释放内存时使用
            
            #### reloadIfNeeded
            ```swift
            func reloadIfNeeded(_ delay: TimeInterval = Constants.defaultRefreshThrottleInterval)
            ```
            - **参数**:
              - `delay`: 延迟时间，默认为 2.0 秒
            - **功能**: 在指定时间内只刷新一次，用于防抖
            - **使用场景**: 当需要避免频繁刷新导致的性能问题时使用
            
            #### reloadItemsIfNeeded
            ```swift
            func reloadItemsIfNeeded(at indexPaths: [IndexPath], _ delay: TimeInterval = Constants.defaultItemRefreshThrottleInterval)
            ```
            - **参数**:
              - `indexPaths`: 需要刷新的 indexPath 数组
              - `delay`: 延迟时间，默认为 0.25 秒
            - **功能**: 在指定时间内只刷新指定的 item，用于防抖
            - **使用场景**: 当需要避免频繁刷新指定 item 导致的性能问题时使用
            
            ## 6. 分页管理
            
            ### 6.1 分页管理方法
            
            #### setupPagination
            ```swift
            func setupPagination(pageSize: Int = 20, initialPage: Int = 1, refresh: (() -> Void)? = nil, loadMore: (() -> Void)? = nil)
            ```
            - **参数**:
              - `pageSize`: 每页数量，默认为 20
              - `initialPage`: 初始页码，默认为 1
              - `refresh`: 刷新回调，可选
              - `loadMore`: 加载更多回调，可选
            - **功能**: 配置分页参数，并设置刷新和加载更多的回调
            - **使用场景**: 当需要实现分页功能时使用
            
            #### endRefresh
            ```swift
            func endRefresh(totalItems: Int, pageSize: Int)
            ```
            - **参数**:
              - `totalItems`: 总数据量
              - `pageSize`: 每页数量
            - **功能**: 结束刷新操作，更新分页状态
            - **使用场景**: 当下拉刷新完成时使用
            
            #### endLoadMore
            ```swift
            func endLoadMore(totalItems: Int, pageSize: Int)
            ```
            - **参数**:
              - `totalItems`: 总数据量
              - `pageSize`: 每页数量
            - **功能**: 结束加载更多操作，更新分页状态
            - **使用场景**: 当上拉加载更多完成时使用
            
            #### resetPagination
            ```swift
            func resetPagination()
            ```
            - **功能**: 重置分页状态
            - **使用场景**: 当需要重置分页状态时使用
            
            ## 7. 观察者模式
            
            ### 7.1 观察者方法
            
            #### registerAsObserver
            ```swift
            func registerAsObserver()
            ```
            - **功能**: 注册为观察者
            - **使用场景**: 当需要接收全局刷新通知时使用
            
            #### removeObserver
            ```swift
            func removeObserver()
            ```
            - **功能**: 移除观察者
            - **使用场景**: 当不再需要接收全局刷新通知时使用
            
            #### notifyAllRefresh
            ```swift
            static func notifyAllRefresh()
            ```
            - **功能**: 通知所有 HFlowView 实例刷新
            - **使用场景**: 当需要通知所有 HFlowView 实例刷新时使用
            
            ## 8. 性能监控
            
            ### 8.1 性能监控方法
            
            #### startPerformanceMonitoring
            ```swift
            func startPerformanceMonitoring()
            ```
            - **功能**: 开始性能监控
            - **使用场景**: 当需要监控 HFlowView 的性能时使用
            
            #### stopPerformanceMonitoring
            ```swift
            func stopPerformanceMonitoring()
            ```
            - **功能**: 停止性能监控
            - **使用场景**: 当不再需要监控 HFlowView 的性能时使用
            
            #### getPerformanceStatistics
            ```swift
            func getPerformanceStatistics() -> HFlowPerformanceStatistics
            ```
            - **返回值**: 性能统计信息，包含帧率、内存使用、网络请求耗时等
            - **功能**: 获取当前性能统计信息
            - **使用场景**: 当需要获取 HFlowView 的性能统计信息时使用
            
            #### resetPerformanceStatistics
            ```swift
            func resetPerformanceStatistics()
            ```
            - **功能**: 重置性能统计信息
            - **使用场景**: 当需要重置 HFlowView 的性能统计信息时使用
            
            ## 9. 微交互
            
            ### 9.1 微交互方法
            
            #### enableMicroInteraction
            ```swift
            var enableMicroInteraction: Bool = true
            ```
            - **功能**: 是否启用微交互
            - **使用场景**: 当需要启用或禁用微交互时使用
            
            #### microInteractionConfig
            ```swift
            var microInteractionConfig: HFlowMicroInteractionConfig
            ```
            - **功能**: 微交互配置
            - **使用场景**: 当需要配置微交互参数时使用
            
            ## 10. 骨架屏
            
            ### 10.1 骨架屏方法
            
            #### enableSkeleton
            ```swift
            var enableSkeleton: Bool = false
            ```
            - **功能**: 是否启用骨架屏
            - **使用场景**: 当需要启用或禁用骨架屏时使用
            
            #### skeletonConfig
            ```swift
            var skeletonConfig: HFlowSkeletonConfig
            ```
            - **功能**: 骨架屏配置
            - **使用场景**: 当需要配置骨架屏参数时使用
            
            #### showSkeleton
            ```swift
            func showSkeleton()
            ```
            - **功能**: 显示骨架屏
            - **使用场景**: 当需要显示骨架屏时使用
            
            #### hideSkeleton
            ```swift
            func hideSkeleton()
            ```
            - **功能**: 隐藏骨架屏
            - **使用场景**: 当需要隐藏骨架屏时使用
            
            ## 11. 智能预加载
            
            ### 11.1 智能预加载方法
            
            #### preloadManager
            ```swift
            var preloadManager: HFlowPreloadManager
            ```
            - **功能**: 预加载管理器
            - **使用场景**: 当需要配置和管理预加载功能时使用
            
            ## 12. SwiftUI集成
            
            ### 12.1 SwiftUI集成方法
            
            #### HFlowViewWrapper
            ```swift
            struct HFlowViewWrapper: UIViewRepresentable
            ```
            - **功能**: SwiftUI 包装器，用于在 SwiftUI 中使用 HFlowView
            - **使用场景**: 当需要在 SwiftUI 中使用 HFlowView 时使用
            
            ## 13. 主题支持

            ### 13.1 主题支持方法

            #### currentTheme
            ```swift
            var currentTheme: HFlowTheme
            ```
            - **功能**: 当前应用的主题
            - **使用场景**: 当需要设置或切换主题时使用

            #### followSystemTheme
            ```swift
            var followSystemTheme: Bool
            ```
            - **功能**: 是否跟随系统主题（深色/浅色模式）
            - **使用场景**: 当需要跟随系统主题切换时使用
            
            ## 14. 设备适配

            ### 14.1 设备适配方法

            #### currentDeviceType
            ```swift
            var currentDeviceType: HFlowDeviceType
            ```
            - **功能**: 当前设备类型（iPhone/iPad）
            - **使用场景**: 当需要根据设备类型调整布局时使用

            #### hasSafeArea
            ```swift
            var hasSafeArea: Bool
            ```
            - **功能**: 当前设备是否有安全区域
            - **使用场景**: 当需要适配刘海屏等设备时使用
            
            #### currentDeviceType
            ```swift
            var currentDeviceType: HFlowDeviceType
            ```
            - **返回值**: 当前设备类型
            - **功能**: 获取当前设备类型
            - **使用场景**: 当需要根据设备类型进行适配时使用
            
            #### currentDeviceOrientation
            ```swift
            var currentDeviceOrientation: UIDeviceOrientation
            ```
            - **返回值**: 当前设备方向
            - **功能**: 获取当前设备方向
            - **使用场景**: 当需要根据设备方向进行适配时使用
            
            ## 15. 触觉反馈
            
            ### 15.1 触觉反馈方法
            
            #### hapticFeedbackConfig.enabled
            ```swift
            var hapticFeedbackConfig: HFlowHapticFeedbackConfig
            ```
            - **功能**: 触觉反馈配置，通过 `hapticFeedbackConfig.enabled` 控制是否启用触觉反馈（默认启用）
            - **使用场景**: 当需要启用或禁用触觉反馈时使用
            
            #### triggerHapticFeedback
            ```swift
            func triggerHapticFeedback(type: HFlowHapticFeedbackType)
            ```
            - **参数**: 
              - `type`: 触觉反馈类型
            - **功能**: 触发触觉反馈
            - **使用场景**: 当需要触发触觉反馈时使用
            
            ## 16. 无障碍支持
            
            ### 16.1 无障碍支持方法
            
            #### enableAccessibility
            ```swift
            var enableAccessibility: Bool = true
            ```
            - **功能**: 是否启用无障碍支持
            - **使用场景**: 当需要启用或禁用无障碍支持时使用
            
            #### setupAccessibilityForCell
            ```swift
            func setupAccessibilityForCell(_ cell: UITableViewCell, at indexPath: IndexPath)
            ```
            - **参数**: 
              - `cell`: 表格单元格
              - `indexPath`: 索引路径
            - **功能**: 为单元格设置无障碍支持
            - **使用场景**: 当需要为单元格添加无障碍支持时使用
            
            ## 17. 异步布局
            
            ### 17.1 异步布局方法
            
            #### enableAsyncLayout
            ```swift
            var enableAsyncLayout: Bool = true
            ```
            - **功能**: 是否启用异步布局
            - **使用场景**: 当需要启用或禁用异步布局时使用
            
            #### asyncLayoutConfig
            ```swift
            var asyncLayoutConfig: HFlowAsyncLayoutConfig
            ```
            - **功能**: 异步布局配置
            - **使用场景**: 当需要配置异步布局参数时使用
            """
        }
        
        /// 获取示例代码
        ///
        /// 提供 HFlowView 的详细示例代码，覆盖各种使用场景
        ///
        /// - Returns: 详细的示例代码，覆盖各种使用场景
        /// - Version: 1.0.0
        ///
        /// 示例代码包括 HFlowView 的基本使用、高级布局、高级交互、性能优化、网络优化、稳定性、扩展性等方面的完整示例。
        func getSampleCode() -> String {
            return """
            # HFlowView 示例代码
            
            ## 示例 1: 基本使用
            
            ```swift
            import UIKit
            
            class ViewController: UIViewController, HFlowViewDelegate {
                
                private var hFlowView: HFlowView!
                private var dataSource: [String] = []
                
                override func viewDidLoad() {
                    super.viewDidLoad()
                    setupFlowView()
                    loadData()
                }
                
                private func setupFlowView() {
                    // 创建 HFlowView 实例
                    hFlowView = HFlowView(frame: view.bounds)
                    hFlowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    hFlowView.backgroundColor = .white
                    view.addSubview(hFlowView)
                    
                    // 设置代理
                    hFlowView.delegate = self
                    
                    // 配置刷新和加载更多
                    setupRefresh()
                    
                    // 配置空视图
                    setupEmptyView()
                }
                
                private func setupRefresh() {
                    // 设置下拉刷新
                    hFlowView.refreshBlock = {
                        print("开始刷新")
                        // 模拟网络请求
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.loadData()
                            self.hFlowView.endRefreshing {}
                        }
                    }
                    
                    // 设置上拉加载更多
                    hFlowView.loadMoreBlock = {
                        print("开始加载更多")
                        // 模拟网络请求
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.loadMoreData()
                            self.hFlowView.endLoadMore {}
                        }
                    }
                }
                
                private func setupEmptyView() {
                    // 设置默认空视图
                    hFlowView.setDefaultEmptyView(title: "暂无数据", message: "下拉刷新重试")
                }
                
                private func loadData() {
                    // 模拟加载数据
                    dataSource = Array(0..<20).map { "Item $0" }
                    hFlowView.reloadData()
                }
                
                private func loadMoreData() {
                    // 模拟加载更多数据
                    let moreData = Array(dataSource.count..<dataSource.count+20).map { "Item $0" }
                    dataSource.append(contentsOf: moreData)
                    hFlowView.reloadData()
                }
                
                // MARK: - HFlowViewDelegate
                
                func numberOfSectionsInFlowView() -> Int {
                    return 1
                }
                
                func numberOfRowsInSection(_ section: Int) -> Int {
                    return dataSource.count
                }
                
                func heightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
                    return 50.0
                }
                
                func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath) -> UITableViewCell? {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                    cell.textLabel?.text = dataSource[indexPath.row]
                    return cell
                }
                
                func didSelectCell(_ indexPath: IndexPath) {
                    print("选中了: dataSource[indexPath.row]")
                }
            }
            ```
            
            ## 示例 2: 分页管理
            
            ```swift
            import UIKit
            
            class PaginationViewController: UIViewController, HFlowViewDelegate {
                
                private var hFlowView: HFlowView!
                private var dataSource: [String] = []
                
                override func viewDidLoad() {
                    super.viewDidLoad()
                    setupFlowView()
                    setupPagination()
                }
                
                private func setupFlowView() {
                    // 创建 HFlowView 实例
                    hFlowView = HFlowView(frame: view.bounds)
                    hFlowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    hFlowView.backgroundColor = .white
                    view.addSubview(hFlowView)
                    
                    // 设置代理
                    hFlowView.delegate = self
                }
                
                private func setupPagination() {
                    // 初始化分页
                    hFlowView.setupPagination(pageSize: 20, initialPage: 1, refresh: {
                        // 刷新逻辑
                        self.loadData()
                    }, loadMore: {
                        // 加载更多逻辑
                        self.loadMoreData()
                    })
                }
                
                private func loadData() {
                    // 模拟加载数据
                    dataSource = Array(0..<20).map { "Item $0" }
                    hFlowView.reloadData()
                    // 结束刷新
                    hFlowView.endRefresh(totalItems: 100, pageSize: 20)
                }
                
                private func loadMoreData() {
                    // 模拟加载更多数据
                    let moreData = Array(dataSource.count..<dataSource.count+20).map { "Item $0" }
                    dataSource.append(contentsOf: moreData)
                    hFlowView.reloadData()
                    // 结束加载更多
                    hFlowView.endLoadMore(totalItems: 100, pageSize: 20)
                }
                
                // MARK: - HFlowViewDelegate
                
                func numberOfSectionsInFlowView() -> Int {
                    return 1
                }
                
                func numberOfRowsInSection(_ section: Int) -> Int {
                    return dataSource.count
                }
                
                func heightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
                    return 50.0
                }
                
                func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath) -> UITableViewCell? {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                    cell.textLabel?.text = dataSource[indexPath.row]
                    return cell
                }
                
                func didSelectCell(_ indexPath: IndexPath) {
                    print("选中了: dataSource[indexPath.row]")
                }
            }
            ```
            
            ## 示例 3: 性能优化
            
            ```swift
            import UIKit
            
            class PerformanceViewController: UIViewController, HFlowViewDelegate {
                
                private var hFlowView: HFlowView!
                private var dataSource: [String] = []
                
                override func viewDidLoad() {
                    super.viewDidLoad()
                    setupFlowView()
                    setupPerformanceOptimization()
                    loadData()
                }
                
                private func setupFlowView() {
                    // 创建 HFlowView 实例
                    hFlowView = HFlowView(frame: view.bounds)
                    hFlowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    hFlowView.backgroundColor = .white
                    view.addSubview(hFlowView)
                    
                    // 设置代理
                    hFlowView.delegate = self
                }
                
                private func setupPerformanceOptimization() {
                    // 监听内存警告
                    NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(handleMemoryWarning),
                        name: UIApplication.didReceiveMemoryWarningNotification,
                        object: nil
                    )
                    
                    // 启用预加载
                    hFlowView.preloadBlock = {
                        print("触发预加载")
                        // 这里可以添加预加载逻辑
                    }
                }
                
                @objc private func handleMemoryWarning() {
                    // 清理缓存
                    hFlowView.clearCache()
                    print("内存缓存已清理")
                }
                
                private func loadData() {
                    // 模拟加载数据
                    dataSource = Array(0..<100).map { "Item $0" }
                    // 使用节流刷新
                    hFlowView.reloadIfNeeded()
                }
                
                // MARK: - HFlowViewDelegate
                
                func numberOfSectionsInFlowView() -> Int {
                    return 1
                }
                
                func numberOfRowsInSection(_ section: Int) -> Int {
                    return dataSource.count
                }
                
                func heightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
                    return 50.0
                }
                
                func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath) -> UITableViewCell? {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                    cell.textLabel?.text = dataSource[indexPath.row]
                    return cell
                }
                
                func didSelectCell(_ indexPath: IndexPath) {
                    print("选中了: dataSource[indexPath.row]")
                }
            }
            ```
            """
        }
    }
}
