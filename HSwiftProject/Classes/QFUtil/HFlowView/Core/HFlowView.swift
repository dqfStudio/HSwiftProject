//
//  HFlowView.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  UITableView 封装：自己做 dataSource / delegate，业务只实现 HFlowViewDelegate。
//

import UIKit

/// HFlowView 数据与布局回调。
///
/// 列表自己担任 UIKit 的 `delegate` / `dataSource`。外部把 `delegate` 设为自己后，
/// 实际保存在 `flowDelegate`。cell / header / footer 在对应回调里通过 `reuseCell` 等方法取出。
@objc protocol HFlowViewDelegate: UITableViewDelegate {

    // MARK: - 数量

    /// section 数量，默认 1。
    @objc
    optional func numberOfSectionsInFlowView() -> Int

    /// 指定 section 的 row 数量。
    @objc
    optional func numberOfRowsInSection(_ section: Int) -> Int

    // MARK: - 高度

    /// header 高度。未实现或 0 表示不显示 header。
    @objc
    optional func heightForHeaderInSection(_ section: Int) -> CGFloat

    /// footer 高度。未实现或 0 表示不显示 footer。
    @objc
    optional func heightForFooterInSection(_ section: Int) -> CGFloat

    /// row 高度。未实现则用估计高度；实现了则 `max(height, 0)`（0 可隐藏行）。frame 布局 cell 不要依赖 Auto Dimension。
    @objc
    optional func heightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat

    // MARK: - 复用入口

    /// 配置 header。内部应调用 `reuseHeader`。
    @objc
    optional func flowHeader(_ flow: HFlowView, inSection section: Int)

    /// 配置 footer。内部应调用 `reuseFooter`。
    @objc
    optional func flowFooter(_ flow: HFlowView, inSection section: Int)

    /// 配置 cell。内部应调用 `reuseCell`，随后 DataSource 会把同一实例返回给 UIKit。
    @objc
    optional func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath)

    @objc
    optional func willDisplayCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)

    @objc
    optional func willDisplayHeader(_ header: HFlowBaseApex, atIndexPath indexPath: IndexPath)

    @objc
    optional func willDisplayFooter(_ footer: HFlowBaseApex, atIndexPath indexPath: IndexPath)

    @objc
    optional func didEndDisplayingCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)

    // MARK: - 选中

    /// row 被点中。cell 上的 `selectBlock` 会先于本回调执行。
    @objc
    optional func didSelectCell(_ indexPath: IndexPath)

    @objc
    optional func shouldSelectRowAtIndexPath(_ indexPath: IndexPath) -> Bool

    @objc
    optional func shouldDeselectRowAtIndexPath(_ indexPath: IndexPath) -> Bool

    @objc
    optional func didDeselectRowAtIndexPath(_ indexPath: IndexPath)

    // MARK: - 滚动（转发 UIScrollViewDelegate）

    @objc
    optional func flowViewDidScroll(_ scrollView: UIScrollView)

    @objc
    optional func flowViewDidZoom(_ scrollView: UIScrollView)

    @objc
    optional func flowViewWillBeginDragging(_ scrollView: UIScrollView)

    @objc
    optional func flowViewWillEndDragging(_ velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)

    @objc
    optional func flowViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)

    @objc
    optional func flowViewWillBeginDecelerating(_ scrollView: UIScrollView)

    @objc
    optional func flowViewDidEndDecelerating(_ scrollView: UIScrollView)

    @objc
    optional func flowViewDidScrollToTop(_ scrollView: UIScrollView)
}

/// `UITableView` 封装：自己做 dataSource / delegate，业务只实现 `HFlowViewDelegate`。
/// 可选 Feature 通过 `HFlowView+FeatureHooks` 挂到生命周期上，未加入工程则自动跳过。
class HFlowView: UITableView {

    // MARK: - 常量

    internal enum Constants {
        static let emptyViewTag = 9999
        /// 未实现 `heightForRowAtIndexPath` 时的估计 / 实际行高。
        static let defaultEstimatedHeight: CGFloat = 50.0
        /// `reloadIfNeeded` 的默认防抖间隔。
        static let defaultRefreshThrottleInterval: TimeInterval = 0.15
        /// `reloadItemsIfNeeded` 的默认防抖间隔。
        static let defaultItemRefreshThrottleInterval: TimeInterval = 0.25
        static let minCellDimension: CGFloat = 1.0
        static let defaultPreloadDistanceRatio: CGFloat = 0.1
        static let minPreloadDistance: CGFloat = 100.0
    }

    // MARK: - 属性

    internal weak var flowDelegate: HFlowViewDelegate?

    // MARK: - 复用登记

    internal var allHeaderIdentifiers = Set<String>()
    internal var allFooterIdentifiers = Set<String>()
    internal var allCellIdentifiers = Set<String>()
    /// 仅供当前这一次 `cellForRow` / header / footer 回调把 `reuseCell` 的实例交回 UIKit。
    internal var pendingReuseCell: HFlowBaseCell?
    internal var pendingReuseHeader: HFlowBaseApex?
    internal var pendingReuseFooter: HFlowBaseApex?

    // MARK: - 内容与点击

    var contentSizeBlock: HFlowCntSizeBlock?

    internal var currentContentSize: CGSize = .zero {
        didSet {
            if currentContentSize != oldValue {
                contentSizeBlock?(currentContentSize)
            }
        }
    }

    /// 点在空白处（非可见 cell / header / footer）时回调。设置后 `point(inside:)` 仍返回 true。
    var outsideContentBlock: HFlowOutsideCntBlock?

    // MARK: - 刷新防抖

    internal var reloadWorkItem: DispatchWorkItem?
    internal var itemReloadWorkItem: DispatchWorkItem?
    internal var pendingItemReloads = Set<IndexPath>()

    /// `reloadIfNeeded` 的防抖间隔。
    var refreshThrottleInterval: TimeInterval = Constants.defaultRefreshThrottleInterval
    /// `reloadItemsIfNeeded` 的防抖间隔。
    var itemRefreshThrottleInterval: TimeInterval = Constants.defaultItemRefreshThrottleInterval

    // MARK: - Observer 分组

    /// `HFlowObserver.refreshByKey` 用。
    var reloadFlowKey: String = ""
    /// `HFlowObserver.releaseByKey` 用。
    var releaseFlowKey: String = ""

    // MARK: - 分页

    var preloadEnabled: Bool = true

    /// 当前页，默认 1。小于 1 时回退到 1。回到第 1 页时清预加载闩锁。
    var pageNo: Int = HFlowPageConfig.defaultPageNo {
        didSet {
            if pageNo < 1 {
                pageNo = HFlowPageConfig.defaultPageNo
            }
            if pageNo == HFlowPageConfig.defaultPageNo {
                lastPreloadTriggered = false
            }
        }
    }

    /// 每页条数，默认 20。小于 1 时回退到 20。
    var pageSize: Int = HFlowPageConfig.defaultPageSize {
        didSet {
            if pageSize < 1 {
                pageSize = HFlowPageConfig.defaultPageSize
            }
        }
    }

    /// 接近底部时触发，不增加 `pageNo`，与上拉加载互相独立。
    var preloadBlock: (() -> Void)?

    /// 是否已越过预加载阈值，避免同一位置重复触发。
    internal var lastPreloadTriggered: Bool = false

    /// 数据总条数。默认 10000 表示尚未设置上限，小于 1 时回退到该占位值。
    var totalNo: Int = HFlowPageConfig.maxTotalPages {
        didSet {
            if totalNo < 1 {
                totalNo = HFlowPageConfig.maxTotalPages
            }
        }
    }

    /// 已加载条数 `pageSize * pageNo` 是否仍小于 `totalNo`。
    var hasMorePages: Bool {
        pageSize > 0 && pageSize * pageNo < totalNo
    }

    // MARK: - 初始化

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain)
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }

    /// 外部赋值只捕获 `HFlowViewDelegate`；UIKit 的 delegate 始终是自身。未实现的 UITableViewDelegate 方法会转发给 `flowDelegate`。
    weak override var delegate: UITableViewDelegate? {
        get { return super.delegate }
        set { flowDelegate = newValue as? HFlowViewDelegate }
    }

    /// 永远是自己的 dataSource，忽略外部赋值。
    weak override var dataSource: UITableViewDataSource? {
        get { return super.dataSource }
        set { _ = newValue }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        hflowRunOnMain {
            self.invokeFeature(HFlowFeatureSelector.observerDeinit)
            self.flowDelegate = nil
        }
    }
}
