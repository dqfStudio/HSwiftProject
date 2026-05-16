//
//  HFlowView.swift
//  FreeChat
//
//  Created by owner on 2024/11/5.
//

import UIKit
import Kingfisher
import SDWebImage
import Combine
import MJRefresh

/// 用于控制刷新状态的辅助类
class HFlowReload: NSObject {
    /// 是否正在刷新
    var isRefresh = false
    /// 是否需要刷新
    var needRefresh = false
}

/// 关联对象的键
private var RefreshControlHandlerKey: UInt8 = 0
private var paginationManagerKey: UInt8 = 0

/// HFlowView 的代理协议，用于提供数据和处理事件
@MainActor
protocol HFlowViewDelegate: UITableViewDelegate {
    /// 返回 FlowView 中的 section 数量
    /// - Returns: section 数量
    func numberOfSectionsInFlowView() -> Int
    
    /// 返回指定 section 中的 row 数量
    /// - Parameter section: section 索引
    /// - Returns: row 数量
    func numberOfRowsInSection(_ section: Int) -> Int

    /// 返回指定 section 的 header 高度
    /// - Parameter section: section 索引
    /// - Returns: header 高度
    func heightForHeaderInSection(_ section: Int) -> CGFloat
    
    /// 返回指定 section 的 footer 高度
    /// - Parameter section: section 索引
    /// - Returns: footer 高度
    func heightForFooterInSection(_ section: Int) -> CGFloat
    
    /// 返回指定 indexPath 的 row 高度
    /// - Parameter indexPath: 索引路径
    /// - Returns: row 高度
    func heightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat
    
    /// 返回指定 section 的 header 视图
    /// - Parameters:
    ///   - flow: HFlowView 实例
    ///   - section: section 索引
    /// - Returns: header 视图
    func flowHeader(_ flow: HFlowView, inSection section: Int) -> UIView?
    
    /// 返回指定 section 的 footer 视图
    /// - Parameters:
    ///   - flow: HFlowView 实例
    ///   - section: section 索引
    /// - Returns: footer 视图
    func flowFooter(_ flow: HFlowView, inSection section: Int) -> UIView?
    
    /// 返回指定 indexPath 的 cell
    /// - Parameters:
    ///   - flow: HFlowView 实例
    ///   - indexPath: 索引路径
    /// - Returns: UITableViewCell 实例
    func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath) -> UITableViewCell?

    /// 当 cell 将要显示时调用
    /// - Parameters:
    ///   - cell: 将要显示的 cell
    ///   - indexPath: 索引路径
    func willDisplayCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
    
    /// 当 cell 结束显示时调用
    /// - Parameters:
    ///   - cell: 结束显示的 cell
    ///   - indexPath: 索引路径
    func didEndDisplayingCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
    
    /// 当 cell 被选中时调用
    /// - Parameter indexPath: 索引路径
    func didSelectCell(_ indexPath: IndexPath)
    
    /// UIScrollViewDelegate
    
    /// 当滚动视图滚动时调用
    /// - Parameter scrollView: 滚动视图
    func flowViewDidScroll(_ scrollView: UIScrollView)
    
    /// 当滚动视图滚动到顶部时调用
    /// - Parameter scrollView: 滚动视图
    func flowViewDidScrollToTop(_ scrollView: UIScrollView)
    
    /// 当滚动视图开始拖动时调用
    /// - Parameter scrollView: 滚动视图
    func flowViewWillBeginDragging(_ scrollView: UIScrollView)
    
    /// 当滚动视图将要结束拖动时调用
    /// - Parameters:
    ///   - velocity: 滚动速度
    ///   - targetContentOffset: 目标内容偏移量
    func flowViewWillEndDragging(_ velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    
    /// 当滚动视图结束拖动时调用
    /// - Parameters:
    ///   - scrollView: 滚动视图
    ///   - willDecelerate: 是否会减速
    func flowViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    
    /// 当滚动视图结束减速时调用
    /// - Parameter scrollView: 滚动视图
    func flowViewDidEndDecelerating(_ scrollView: UIScrollView)
    
    /// 当性能统计数据更新时调用
    /// - Parameter statistics: 性能统计数据
    func performanceStatisticsUpdated(_ statistics: HFlowPerformanceStatistics)
}

// 提供默认实现
extension HFlowViewDelegate {
    func numberOfSectionsInFlowView() -> Int { 1 }
    func numberOfRowsInSection(_ section: Int) -> Int { 0 }
    func heightForHeaderInSection(_ section: Int) -> CGFloat { 0.0 }
    func heightForFooterInSection(_ section: Int) -> CGFloat { 0.0 }
    func heightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat { 0.0 }
    func flowHeader(_ flow: HFlowView, inSection section: Int) -> UIView? { nil }
    func flowFooter(_ flow: HFlowView, inSection section: Int) -> UIView? { nil }
    func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath) -> UITableViewCell? { nil }
    func willDisplayCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath) {}
    func didEndDisplayingCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath) {}
    func didSelectCell(_ indexPath: IndexPath) {}
    func flowViewDidScroll(_ scrollView: UIScrollView) {}
    func flowViewDidScrollToTop(_ scrollView: UIScrollView) {}
    func flowViewWillBeginDragging(_ scrollView: UIScrollView) {}
    func flowViewWillEndDragging(_ velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {}
    func flowViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    func flowViewDidEndDecelerating(_ scrollView: UIScrollView) {}
    func performanceStatisticsUpdated(_ statistics: HFlowPerformanceStatistics) {}
}

/**
 HFlowView 是一个基于 UITableView 的流式布局视图，提供了更灵活的数据管理和刷新控制
 
 主要特性：
 - 支持多 section 和多 row
 - 支持自定义 header 和 footer
 - 支持自动高度计算
 - 支持滚动到顶部和底部
 - 支持异步刷新和防抖
 - 支持内存管理和缓存优化
 - 支持下拉刷新和上拉加载更多
 - 支持动画效果
 - 支持空视图显示
 - 支持预加载功能

 所有回调都在主线程执行，确保 UI 操作的安全性。
 */
@MainActor
class HFlowView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Constants
    internal enum Constants {
        /// 空视图标签值
        static let emptyViewTag = 9999
        
        /// 默认预估高度
        static let defaultEstimatedHeight: CGFloat = 50.0
        
        /// 刷新节流间隔（秒）
        static let defaultRefreshThrottleInterval: TimeInterval = 0.1

        /// Item 刷新节流间隔（秒）
        static let defaultItemRefreshThrottleInterval: TimeInterval = 0.016
        
        /// Cell 尺寸最小值（防止崩溃）
        static let minCellDimension: CGFloat = 1.0
    }
    
    // MARK: - Private Properties
    
    /// 用于控制整体刷新状态
    private var flowReload = HFlowReload()
    
    /// 用于存储需要刷新的 indexPath
    private var allReloadItems: Set<IndexPath> = []
    
    /// 用于存储已经刷新的 indexPath
    private var reloadedItems: Set<IndexPath> = []
    
    /// 用于控制 item 刷新状态
    private var itemReload = HFlowReload()
    
    /// 用于处理待刷新的队列
    private var pendingReloadQueue: [Set<IndexPath>] = []
    
    /// 标记是否正在处理刷新队列
    private var isProcessingReloadQueue = false
    
    /// 标记是否已被销毁
    private var isDeallocating = false
    
    // MARK: - Combine Properties
    
    /// 用于节流刷新的 Subject
    let refreshSubject = PassthroughSubject<Void, Never>()

    /// 用于存储 Combine 订阅
    var cancellables = Set<AnyCancellable>()
    
    /// 刷新节流间隔
    public var refreshThrottleInterval: TimeInterval = Constants.defaultRefreshThrottleInterval
    
    
    // MARK: - Managers
    
    /// 刷新管理器
    internal lazy var refreshManager: HFlowRefreshManager = {
        return HFlowRefreshManager(flowView: self)
    }()
    
    /// 缓存管理器
    internal lazy var cacheManager: HFlowCacheManager = {
        return HFlowCacheManager(flowView: self)
    }()
    
    /// 预加载管理器
    internal lazy var preloadManager: HFlowPreloadManager = {
        return HFlowPreloadManager(flowView: self)
    }()

    
    // MARK: - Animation Properties
    
    /// 是否启用动画效果
    public var enableAnimations = true
    
    // MARK: - Initialization
    
    /// 禁用通过 Interface Builder 初始化
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 使用指定的 frame 初始化 HFlowView
    /// - Parameter frame: 视图的 frame
    convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain)
    }
    
    /// 使用指定的 frame 和 style 初始化 HFlowView
    /// - Parameters:
    ///   - frame: 视图的 frame
    ///   - style: 表格的样式
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    // MARK: - Properties
    
    /// HFlowView 的代理
    internal weak var flowDelegate: HFlowViewDelegate?
    
    /// 重写 delegate 属性，将其转换为 HFlowViewDelegate
    override weak var delegate: UITableViewDelegate? {
        get { flowDelegate }
        set { 
            flowDelegate = newValue as? HFlowViewDelegate
            // 确保 super.delegate 始终指向 self，以处理 UITableView 的回调
            super.delegate = self
        }
    }
    
    /// 重写 dataSource 属性，始终返回 self
    override weak var dataSource: UITableViewDataSource? {
        get { self }
        set { /* 忽略外部设置，始终使用 self 作为 dataSource */ }
    }
    
    /// 通知代理性能数据更新
    /// - Parameter statistics: 性能统计数据
    func notifyPerformanceStatisticsUpdated(_ statistics: HFlowPerformanceStatistics) {
        flowDelegate?.performanceStatisticsUpdated(statistics)
    }

    
    /// 滚动到顶部
    /// - Parameter animated: 是否使用动画
    func scrollToTop(_ animated: Bool) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        scrollRectToVisible(rect, animated: animated)
    }

    /// 滚动到底部
    /// - Parameter animated: 是否使用动画
    func scrollToBottom(_ animated: Bool) {
        let sections = numberOfSections
        guard sections > 0 else { return }
        let items = numberOfRows(inSection: sections - 1)
        guard items > 0 else { return }
        let indexPath = IndexPath(row: items - 1, section: sections - 1)
        scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
    /// 配置下拉刷新
    /// - Parameters:
    ///   - tintColor: 刷新控件的颜色
    ///   - title: 刷新控件的标题
    ///   - handler: 刷新回调
    func setupRefreshControl(tintColor: UIColor = .gray, title: String? = nil, handler: @escaping () -> Void) {
        refreshManager.setupRefresh(headerStyle: .gray, block: handler)
    }
    
    /// 结束下拉刷新
    func endRefreshing() {
        refreshManager.endRefreshing {}
    }
    
    /// 开始下拉刷新
    func beginRefreshing() {
        refreshManager.beginRefreshing {}
    }
    
    /// 配置上拉加载更多
    /// - Parameter handler: 加载更多回调
    func setupLoadMore(handler: @escaping () -> Void) {
        refreshManager.setupLoadMore(footerStyle: .style1, block: handler)
    }
    
    /// 结束上拉加载更多
    func endLoadingMore() {
        refreshManager.endLoadMore {}
    }
    
    /// 插入新的 row
    /// - Parameters:
    ///   - indexPaths: 要插入的 indexPath 数组
    ///   - animation: 动画效果
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .automatic) {
        guard !isDeallocating else { return }
        if enableAnimations {
            super.insertRows(at: indexPaths, with: animation)
        } else {
            super.insertRows(at: indexPaths, with: .none)
        }
    }
    
    /// 删除 row
    /// - Parameters:
    ///   - indexPaths: 要删除的 indexPath 数组
    ///   - animation: 动画效果
    override func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .automatic) {
        guard !isDeallocating else { return }
        if enableAnimations {
            super.deleteRows(at: indexPaths, with: animation)
        } else {
            super.deleteRows(at: indexPaths, with: .none)
        }
    }
    
    /// 重新加载 row
    /// - Parameters:
    ///   - indexPaths: 要重新加载的 indexPath 数组
    ///   - animation: 动画效果
    override func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .automatic) {
        guard !isDeallocating else { return }
        if enableAnimations {
            super.reloadRows(at: indexPaths, with: animation)
        } else {
            super.reloadRows(at: indexPaths, with: .none)
        }
    }
    
    /// 批量安全插入（无动画，防崩溃）
    func batchInsertRows(at indexPaths: [IndexPath]) {
        guard !isDeallocating, !indexPaths.isEmpty else { return }
        performBatchUpdates({
            insertRows(at: indexPaths, with: .none)
        }, completion: nil)
    }

    /// 批量安全删除
    func batchDeleteRows(at indexPaths: [IndexPath]) {
        guard !isDeallocating, !indexPaths.isEmpty else { return }
        performBatchUpdates({
            deleteRows(at: indexPaths, with: .none)
        }, completion: nil)
    }

    /// 高并发消息防抖插入 — 16ms 内合并所有插入
    private var pendingInsertions: [IndexPath] = []
    private var insertDebounceWorkItem: DispatchWorkItem?

    func debouncedInsertRows(at indexPaths: [IndexPath]) {
        guard !isDeallocating else { return }
        pendingInsertions.append(contentsOf: indexPaths)
        insertDebounceWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self, !self.isDeallocating else { return }
            let batch = self.pendingInsertions
            self.pendingInsertions.removeAll()
            self.batchInsertRows(at: batch)
        }
        insertDebounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(16), execute: workItem)
    }

    /// 增量刷新 — 替换全量 reloadData，避免主线程卡死
    func reloadFlowDataIncremental(changedSections: IndexSet? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, !self.isDeallocating else { return }
            let sections = changedSections ?? IndexSet(integersIn: 0..<self.numberOfSections)
            if sections.count > self.numberOfSections / 2 || self.numberOfSections <= 1 {
                self.reloadData()
            } else {
                self.performBatchUpdates({
                    self.reloadSections(sections, with: .none)
                }, completion: nil)
            }
            self.updateEmptyView()
        }
    }

    /// 在指定时间内只刷新一次，用于防抖
    /// - Parameter delay: 延迟时间，默认为 0.1 秒（聊天场景优化）
    func reloadIfNeeded(_ delay: TimeInterval = Constants.defaultRefreshThrottleInterval) {
        refreshSubject.send()
    }
    
    /// 在指定时间内只刷新指定的 item，用于防抖
    /// - Parameters:
    ///   - indexPaths: 需要刷新的 indexPath 数组
    ///   - delay: 延迟时间，默认为 0.25 秒
    func reloadItemsIfNeeded(at indexPaths: [IndexPath], _ delay: TimeInterval = Constants.defaultItemRefreshThrottleInterval) {
        guard !isDeallocating else { return }
        let indexPathSet = Set(indexPaths)
        allReloadItems.formUnion(indexPathSet)
        
        // 将刷新任务添加到队列
        pendingReloadQueue.append(indexPathSet)
        
        // 如果队列未在处理中，开始处理
        if !isProcessingReloadQueue {
            processReloadQueue(delay: delay)
        }
    }

    /// 处理刷新队列
    /// - Parameter delay: 延迟时间
    private func processReloadQueue(delay: TimeInterval) {
        guard !isDeallocating, !pendingReloadQueue.isEmpty else {
            isProcessingReloadQueue = false
            return
        }
        
        isProcessingReloadQueue = true
        
        // 取出队列中的所有待刷新项
        let allItemsToReload = pendingReloadQueue.flatMap { $0 }
        let uniqueItemsToReload = Array(Set(allItemsToReload))
        
        // 清空队列
        pendingReloadQueue.removeAll()
        
        // 执行刷新
        DispatchQueue.main.async { [weak self] in
            guard let self = self, !self.isDeallocating else { return }
            self.reloadRows(at: uniqueItemsToReload, with: .none)
            
            // 延迟后检查是否有新的刷新任务
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                guard let self = self, !self.isDeallocating else { return }
                // 处理完当前批次后，继续处理队列
                self.processReloadQueue(delay: delay)
            }
        }
    }
    
    /// 异步刷新所有数据
    func reloadFlowData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, !self.isDeallocating else { return }
            self.reloadData()
            self.updateEmptyView()
        }
    }
    

    
    // MARK: - Private Methods
    
    /// 检查是否需要加载更多
    private func checkLoadMore() {
        // 如果启用了预加载，则不需要此方法，因为预加载会处理
        guard !preloadManager.enablePreloading else { return }
        
        let contentOffset = contentOffset.y
        let contentHeight = contentSize.height
        let frameHeight = frame.size.height
        
        // 当滚动到底部时，触发加载更多
        if contentOffset + frameHeight >= contentHeight - 100.0 {
            mj_footer?.beginRefreshing()
        }
    }

    
    /// 析构方法，清理资源
    deinit {
        isDeallocating = true
        NotificationCenter.default.removeObserver(self)
        flowDelegate = nil
        // 清空所有数组，释放内存
        allReloadItems.removeAll()
        reloadedItems.removeAll()
        pendingReloadQueue.removeAll()
        // 清理 Combine 订阅
        cancellables.removeAll()
    }
    
    // MARK: - UITableViewDataSource
    
    /// 返回表格的 section 数量
    /// - Parameter tableView: UITableView 实例
    /// - Returns: section 数量
    func numberOfSections(in tableView: UITableView) -> Int {
        // table Style
        let sections = flowDelegate?.numberOfSectionsInFlowView() ?? 1
        // Prevents quantity from being less than 1
        return max(sections, 1)
    }
    
    /// 返回指定 section 的 row 数量
    /// - Parameters:
    ///   - tableView: UITableView 实例
    ///   - section: section 索引
    /// - Returns: row 数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = flowDelegate?.numberOfRowsInSection(section) ?? 0
        // Prevents quantity from being less than 0
        return max(items, 0)
    }

    /// 返回指定 section 的 header 高度
    /// - Parameters:
    ///   - tableView: UITableView 实例
    ///   - section: section 索引
    /// - Returns: header 高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = flowDelegate?.heightForHeaderInSection(section) ?? 0.0
        // Prevent negative size
        return max(height, 0.0)
    }

    /// 返回指定 section 的 footer 高度
    /// - Parameters:
    ///   - tableView: UITableView 实例
    ///   - section: section 索引
    /// - Returns: footer 高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height = flowDelegate?.heightForFooterInSection(section) ?? 0.0
        // Prevent negative size
        return max(height, 0.0)
    }
    
    /// 返回指定 indexPath 的预估高度
    /// - Parameters:
    ///   - tableView: UITableView 实例
    ///   - indexPath: 索引路径
    /// - Returns: 预估高度
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = cacheManager.getCachedCellHeight(for: indexPath) {
            return height
        } else if tableView.estimatedRowHeight != UITableView.automaticDimension {
            return tableView.estimatedRowHeight
        }
        return Constants.defaultEstimatedHeight
    }
    
    /// 返回指定 indexPath 的实际高度
    /// - Parameters:
    ///   - tableView: UITableView 实例
    ///   - indexPath: 索引路径
    /// - Returns: 实际高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.rowHeight != UITableView.automaticDimension {
            return tableView.rowHeight
        } else {
            let height = flowDelegate?.heightForRowAtIndexPath(indexPath) ?? 0.0
            // Prevent negative size
            let validHeight = max(height, 0.0)
            if validHeight > 0 { return validHeight }
        }
        return UITableView.automaticDimension
    }
    
    
    /// 返回指定 indexPath 的 cell
    /// - Parameters:
    ///   - tableView: UITableView 实例
    ///   - indexPath: 索引路径
    /// - Returns: UITableViewCell 实例
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Call delegate method
        if let cell = flowDelegate?.flowRow(self, atIndexPath: indexPath) {
            // 设置cell的无障碍支持
            setupAccessibilityForCell(cell, at: indexPath)
            return cell
        }
        register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        return dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
    }
    
    /// 返回指定 section 的 header 视图
    /// - Parameters:
    ///   - tableView: UITableView 实例
    ///   - section: section 索引
    /// - Returns: header 视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Call delegate method
        return flowDelegate?.flowHeader(self, inSection: section)
    }
    
    /// 返回指定 section 的 footer 视图
    /// - Parameters:
    ///   - tableView: UITableView 实例
    ///   - section: section 索引
    /// - Returns: footer 视图
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Call delegate method
        return flowDelegate?.flowFooter(self, inSection: section)
    }

    /// 当 cell 将要显示时调用
    /// - Parameters:
    ///   - tableView: UITableView 实例
    ///   - cell: 将要显示的 cell
    ///   - indexPath: 索引路径
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 关闭离屏渲染优化
        cell.layer.shouldRasterize = false
        cell.layer.drawsAsynchronously = true
        // Save cell height to cache
        cacheManager.cacheCellHeight(cell.frame.size.height, for: indexPath)
        
        // 添加cell进入动画
        addEnterAnimation(to: cell, at: indexPath)
        
        // 触发预渲染
        preRenderCell(at: indexPath)
        
        // Call delegate method
        flowDelegate?.willDisplayCell(cell, atIndexPath: indexPath)
    }
    
    /// 当 cell 结束显示时调用
    /// - Parameters:
    ///   - tableView: UITableView 实例
    ///   - cell: 结束显示的 cell
    ///   - indexPath: 索引路径
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        flowDelegate?.didEndDisplayingCell(cell, atIndexPath: indexPath)
    }

    /// 当 cell 被选中时调用
    /// - Parameters:
    ///   - tableView: UITableView 实例
    ///   - indexPath: 索引路径
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        flowDelegate?.didSelectCell(indexPath)
    }
    
    // MARK: - UIScrollViewDelegate
    
    /// 当滚动视图滚动时调用
    /// - Parameter scrollView: 滚动视图
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        flowDelegate?.flowViewDidScroll(scrollView)
        // 检查是否需要加载更多
        checkLoadMore()
        // 检查是否需要预加载
        if preloadManager.enablePreloading {
            preloadManager.checkPreload()
        }
        // 处理智能预加载
        handleScrollForSmartPreloading(scrollView)
    }
    

    
    /// 当滚动视图滚动到顶部时调用
    /// - Parameter scrollView: 滚动视图
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        flowDelegate?.flowViewDidScrollToTop(scrollView)
    }
    
    /// 当滚动视图开始拖动时调用
    /// - Parameter scrollView: 滚动视图
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        flowDelegate?.flowViewWillBeginDragging(scrollView)
    }
    
    /// 当滚动视图将要结束拖动时调用
    /// - Parameters:
    ///   - scrollView: 滚动视图
    ///   - velocity: 滚动速度
    ///   - targetContentOffset: 目标内容偏移量
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        flowDelegate?.flowViewWillEndDragging(velocity, targetContentOffset: targetContentOffset)
    }
    
    /// 当滚动视图结束拖动时调用
    /// - Parameters:
    ///   - scrollView: 滚动视图
    ///   - willDecelerate: 是否会减速
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        flowDelegate?.flowViewDidEndDragging(scrollView, willDecelerate: decelerate)
        if !decelerate {
            checkCacheCleanup()
            trimDistantCells()
        }
    }

    /// 当滚动视图结束减速时调用
    /// - Parameter scrollView: 滚动视图
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        flowDelegate?.flowViewDidEndDecelerating(scrollView)
        checkCacheCleanup()
        trimDistantCells()
    }

    // MARK: - Memory Control

    /// 释放远离可见区域的预渲染缓存和布局缓存
    private func trimDistantCells() {
        guard let visibleIndexPaths = indexPathsForVisibleRows, !visibleIndexPaths.isEmpty else { return }
        guard let firstVisible = visibleIndexPaths.first, let lastVisible = visibleIndexPaths.last else { return }
        let keepRange = 50
        let minSafeRow = max(0, firstVisible.row - keepRange)
        let maxSafeRow = lastVisible.row + keepRange

        // 清理预渲染缓存
        preRenderLock.lock()
        preRenderedCells = preRenderedCells.filter { indexPath, _ in
            indexPath.row >= minSafeRow && indexPath.row <= maxSafeRow
        }
        preRenderLock.unlock()

        // 清理异步布局缓存
        layoutCacheStore.filter { indexPath in
            indexPath.row >= minSafeRow && indexPath.row <= maxSafeRow
        }
    }
}
