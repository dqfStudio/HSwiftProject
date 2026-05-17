//
//  HCollView.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import Combine
import Kingfisher
import MJRefresh

/// HCollView 代理协议
///
/// 继承自 UICollectionViewDelegate，提供额外的数据源和布局配置方法。
/// 所有回调都在主线程执行。
//@MainActor
@objc protocol HCollViewDelegate: UICollectionViewDelegate {
    /// 返回 section 数量
    /// - Returns: section 的数量，默认为 1
    @objc
    optional func numberOfSectionsInCollView() -> Int
    
    /// 返回指定 section 的 item 数量
    /// - Parameter section: section 索引
    /// - Returns: item 的数量
    @objc
    optional func numberOfItemsInSection(_ section: Int) -> Int
    
    /// 返回指定 section 的列数（仅当 layout 为 HCollViewLayout 时有效）
    /// - Parameter section: section 索引
    /// - Returns: 列数，默认为 2
    @objc
    optional func numberOfColumnsInSection(_ section: Int) -> Int
    
    /// 返回指定 section 的背景色（仅当 layout 为 HCollViewLayout 时有效）
    /// - Parameter section: section 索引
    /// - Returns: 背景色
    @objc
    optional func colorForSection(_ section: Int) -> UIColor

    /// 返回指定 section 的 header 尺寸
    /// - Parameter section: section 索引
    /// - Returns: header 的尺寸
    @objc
    optional func sizeForHeaderInSection(_ section: Int) -> CGSize
    
    /// 返回指定 section 的 footer 尺寸
    /// - Parameter section: section 索引
    /// - Returns: footer 的尺寸
    @objc
    optional func sizeForFooterInSection(_ section: Int) -> CGSize
    
    /// 返回指定 indexPath 的 item 尺寸
    /// - Parameter indexPath: item 的位置
    /// - Returns: item 的尺寸
    @objc
    optional func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> CGSize

    /// 返回指定 section 的 header 最小间距
    /// - Parameter section: section 索引
    /// - Returns: header 的最小间距
    @objc
    optional func minimumHeaderSpacingForSectionAt(_ section: Int) -> CGFloat
    
    /// 返回指定 section 的 footer 最小间距
    /// - Parameter section: section 索引
    /// - Returns: footer 的最小间距
    @objc
    optional func minimumFooterSpacingForSectionAt(_ section: Int) -> CGFloat
    
    /// 返回指定 section 的行间距
    /// - Parameter section: section 索引
    /// - Returns: 行间距
    @objc
    optional func minimumLineSpacingForSectionAt(_ section: Int) -> CGFloat
    
    /// 返回指定 section 的 item 间距
    /// - Parameter section: section 索引
    /// - Returns: item 间距
    @objc
    optional func minimumInteritemSpacingForSectionAt(_ section: Int) -> CGFloat

    /// 返回指定 section 的内边距
    /// - Parameter section: section 索引
    /// - Returns: 内边距
    @objc
    optional func insetForSection(_ section: Int) -> UIEdgeInsets
    
    /// Header 即将显示时的回调
    /// - Parameters:
    ///   - coll: HCollView 实例
    ///   - indexPath: header 的位置
    @objc
    optional func collHeader(_ coll: HCollView, atIndexPath indexPath: IndexPath)
    
    /// Footer 即将显示时的回调
    /// - Parameters:
    ///   - coll: HCollView 实例
    ///   - indexPath: footer 的位置
    @objc
    optional func collFooter(_ coll: HCollView, atIndexPath indexPath: IndexPath)
    
    /// Item 即将显示时的回调
    /// - Parameters:
    ///   - coll: HCollView 实例
    ///   - indexPath: item 的位置
    @objc
    optional func collItem(_ coll: HCollView, atIndexPath indexPath: IndexPath)

    /// Cell 即将显示时的回调
    /// - Parameters:
    ///   - cell: 即将显示的 cell
    ///   - indexPath: cell 的位置
    @objc
    optional func willDisplayCell(_ cell: HCollBaseCell, atIndexPath indexPath: IndexPath)
    
    /// Cell 被选中时的回调
    /// - Parameters:
    ///   - cell: 被选中的 cell
    ///   - indexPath: cell 的位置
    @objc
    optional func didSelectCell(_ cell: HCollBaseCell, atIndexPath indexPath: IndexPath)

    // MARK: - UICollectionViewDelegate
    
    /// 是否允许选中指定位置的 item
    /// - Parameter indexPath: item 的位置
    /// - Returns: 是否允许选中
    @objc
    optional func shouldSelectItemAtIndexPath(_ indexPath: IndexPath) -> Bool
    
    /// 是否允许取消选中指定位置的 item
    /// - Parameter indexPath: item 的位置
    /// - Returns: 是否允许取消选中
    @objc
    optional func shouldDeselectItemAtIndexPath(_ indexPath: IndexPath) -> Bool
    
    /// Item 被取消选中时的回调
    /// - Parameter indexPath: item 的位置
    @objc
    optional func didDeselectItemAtIndexPath(_ indexPath: IndexPath)

    // MARK: - UIScrollViewDelegate
    
    /// ScrollView 滚动时的回调
    /// - Parameter scrollView: ScrollView 实例
    @objc
    optional func collViewDidScroll(_ scrollView: UIScrollView)
    
    /// ScrollView 缩放时的回调
    /// - Parameter scrollView: ScrollView 实例
    @objc
    optional func collViewDidZoom(_ scrollView: UIScrollView)
    
    /// ScrollView 即将开始拖拽时的回调
    /// - Parameter scrollView: ScrollView 实例
    @objc
    optional func collViewWillBeginDragging(_ scrollView: UIScrollView)
    
    /// ScrollView 即将结束拖拽时的回调
    /// - Parameters:
    ///   - scrollView: ScrollView 实例
    ///   - velocity: 拖拽速度
    ///   - targetContentOffset: 目标内容偏移量
    @objc
    optional func collViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    
    /// ScrollView 结束拖拽时的回调
    /// - Parameters:
    ///   - scrollView: ScrollView 实例
    ///   - decelerate: 是否会减速
    @objc
    optional func collViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    
    /// ScrollView 即将开始减速时的回调
    /// - Parameter scrollView: ScrollView 实例
    @objc
    optional func collViewWillBeginDecelerating(_ scrollView: UIScrollView)
    
    /// ScrollView 结束减速时的回调
    /// - Parameter scrollView: ScrollView 实例
    @objc
    optional func collViewDidEndDecelerating(_ scrollView: UIScrollView)
}

/// HCollView 是一个功能强大的 UICollectionView 子类，提供了丰富的功能和便捷的 API。
///
/// 主要功能包括：
/// - 支持下拉刷新和上拉加载更多
/// - 支持预加载功能
/// - 支持空数据视图
/// - 支持多种对齐方式
/// - 支持信号发送机制
/// - 支持智能缓存管理
/// - 支持批量刷新
/// - 支持节流刷新，避免频繁刷新导致的性能问题
///
/// 所有回调都在主线程执行，确保 UI 操作的安全性。
class HCollView: UICollectionView {
    
    // MARK: - Constants
    internal enum Constants {
        /// 空视图标签值
        static let emptyViewTag = 9999
        
        /// 滚动清理缓存的最小阈值
        static let minScrollCleanupThreshold = 15
        
        /// 最大追踪 cell 数量
        static let maxTrackedCells = 20
        
        /// 默认预加载距离比例（内容高度的 10%）
        static let defaultPreloadDistanceRatio: CGFloat = 0.1
        
        /// 最小预加载距离（像素）
        static let minPreloadDistance: CGFloat = 100.0
        
        /// 刷新节流间隔（秒）
        static let defaultRefreshThrottleInterval: TimeInterval = 2.0
        
        /// Item 刷新节流间隔（秒）
        static let defaultItemRefreshThrottleInterval: TimeInterval = 0.25
        
        /// Cell 尺寸最小值（防止崩溃）
        static let minCellDimension: CGFloat = 1.0
    }
    
    // MARK: - Properties
    internal var flowLayout: UICollectionViewFlowLayout?
    internal weak var collDelegate: HCollViewDelegate?
    
    // MARK: - Identifier Tracking
    internal var allHeaderIdentifiers = Set<String>()
    internal var allFooterIdentifiers = Set<String>()
    internal var allCellIdentifiers = Set<String>()
    internal var allSectionInsets = [String: String]()
    internal var allReuseCells = HCollLRUCache<String, Weak<HCollBaseCell>>(capacity: Constants.maxTrackedCells)
    
    /// Header 缓存（用于信号发送）
    internal var allReuseHeaders = HCollLRUCache<String, Weak<HCollBaseApex>>(capacity: Constants.maxTrackedCells)
    
    /// Footer 缓存（用于信号发送）
    internal var allReuseFooters = HCollLRUCache<String, Weak<HCollBaseApex>>(capacity: Constants.maxTrackedCells)
    
    /// Track visited cells for smart cache cleanup
    internal var allPassedCells = Set<String>()
    
    /// Weak reference wrapper to prevent retain cycles
    internal struct Weak<T: AnyObject> {
        internal weak var value: T?
        init(_ value: T) { self.value = value }
    }

    // MARK: - Core Properties
    /// Callback when content size changes
    var contentSizeBlock: HCollCntSizeBlock?
    
    /// Current content size
    internal var currentContentSize: CGSize = .zero {
        didSet {
            if currentContentSize != oldValue {
                contentSizeBlock?(currentContentSize)
            }
        }
    }
    
    /// Callback when area outside content is tapped
    var outsideContentBlock: HCollOutsideCntBlock?

    /// Reload management
    internal var collReload = HCollReload()
    
    /// Subject for throttled refresh events
    let refreshSubject = PassthroughSubject<Void, Never>()
    
    /// Cancellables for Combine subscriptions
    internal var cancellables = Set<AnyCancellable>()
    
    /// Refresh throttle interval (default: 2 seconds)
    var refreshThrottleInterval: TimeInterval = Constants.defaultRefreshThrottleInterval {
        didSet { setupRefreshThrottle() }
    }
    
    /// Item refresh throttle interval (default: 0.25 seconds)
    var itemRefreshThrottleInterval: TimeInterval = Constants.defaultItemRefreshThrottleInterval
    
    /// Item reload tracking
    internal var allReloadItems: [IndexPath] = []
    internal var reloadedItems: [IndexPath] = []
    internal var itemReload = HCollReload()
    
    /// Queue for pending reload batches to avoid deep recursion
    internal var pendingReloadQueue: [Set<IndexPath>] = []
    internal var isProcessingReloadQueue = false
    
    /// Alignment
    internal var alignStrategy: HCollAlignStrategy = HCollDefaultAlignStrategy()
    var collAlign: HCollAlign = .default {
        didSet {
            alignStrategy = HCollAlignStrategyFactory.createStrategy(for: collAlign)
            updateAlign()
        }
    }

    // MARK: - Associated Properties

    /// Key for batch reload by key
    var reloadCollKey: String = ""

    /// Key for batch release by key
    var releaseCollKey: String = ""

    // MARK: - Refresh and Load More
    /// 刷新回调
    var refreshBlock: HCollRefreshBlock?
    
    /// 加载更多回调
    var loadMoreBlock: HCollLoadMoreBlock?
    
    /// 预加载是否启用
    var preloadEnabled: Bool = true
    
    /// 当前页码，默认为 1
    var pageNo: Int = HCollPageConfig.defaultPageNo {
        didSet {
            // 确保页码不小于默认值
            if pageNo < HCollPageConfig.defaultPageNo {
                pageNo = HCollPageConfig.defaultPageNo
            }
            if pageNo == HCollPageConfig.defaultPageNo {
                self.lastPreloadTriggered = false
            }
        }
    }

    /// 每页数量，默认为 20
    var pageSize: Int = HCollPageConfig.defaultPageSize {
        didSet {
            // 确保每页数量不小于默认值
            if pageSize < HCollPageConfig.defaultPageSize {
                pageSize = HCollPageConfig.defaultPageSize
            }
        }
    }
    
    /// Callback when preload is triggered
    var preloadBlock: (() -> Void)?
    
    /// Tracks whether the preload threshold has been crossed, to avoid duplicate triggers
    internal var lastPreloadTriggered: Bool = false

    /// 总页数上限，默认为 10000
    var totalNo: Int = HCollPageConfig.maxTotalPages {
        didSet {
            // 确保总页数不小于默认值
            if totalNo < HCollPageConfig.maxTotalPages {
                totalNo = HCollPageConfig.maxTotalPages
            }
        }
    }

    /// Refresh header style
    var refreshHeaderStyle: HCollRefreshHeaderStyle = .gray

    /// Load more footer style
    var refreshFooterStyle: HCollRefreshFooterStyle = .style1

    // MARK: - Empty View
    /// 空视图是否启用
    var emptyViewEnabled: Bool = true
    
    /// 自定义空视图
    var emptyView: UIView? {
        get {
            return subviews.first { $0.tag == Constants.emptyViewTag }
        }
        set {
            // 移除旧的空视图
            subviews.forEach { view in
                if view.tag == Constants.emptyViewTag {
                    view.removeFromSuperview()
                }
            }
            
            // 添加新的空视图
            if let newView = newValue {
                newView.tag = Constants.emptyViewTag
                newView.frame = bounds
                insertSubview(newView, at: 0)
                newView.isHidden = true
            }
        }
    }

    // MARK: - Initialization
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Default scrolling direction is vertical
    convenience init(frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: HCollViewLayout())
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        flowLayout = layout as? UICollectionViewFlowLayout
        self.setup()
    }
    
    // MARK: - Delegate and DataSource
    weak override var delegate: UICollectionViewDelegate? {
        get { return super.delegate }
        set { collDelegate = newValue as? HCollViewDelegate }
    }
    
    weak override var dataSource: UICollectionViewDataSource? {
        get { return super.dataSource }
        set { _ = newValue }
    }
    
    deinit {
        // 移除通知观察者
        NotificationCenter.default.removeObserver(self)
        
        // 从全局观察者中移除（在主线程执行）
        DispatchQueue.main.sync {
            HCollObserver.removeObserver(self)
            
            // 清除代理和数据源
            self.collDelegate = nil
            self.dataSource = nil
            self.delegate = nil
        }
    }
}
