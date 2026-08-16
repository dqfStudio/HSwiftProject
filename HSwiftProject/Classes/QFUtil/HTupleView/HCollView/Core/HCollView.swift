//
//  HCollView.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  UICollectionView 封装：自己做 dataSource / delegate，业务只实现 HCollViewDelegate。
//

import UIKit

/// HCollView 数据与布局回调。
///
/// 列表自己担任 UIKit 的 `delegate` / `dataSource`。外部把 `delegate` 设为自己后，
/// 实际保存在 `collDelegate`。cell / header / footer 在对应回调里通过 `reuseCell` 等方法取出。
@objc protocol HCollViewDelegate: UICollectionViewDelegate {

    // MARK: - 数量

    /// section 数量，默认 1。
    @objc
    optional func numberOfSectionsInCollView() -> Int

    /// 指定 section 的 item 数量。
    @objc
    optional func numberOfItemsInSection(_ section: Int) -> Int

    // MARK: - 布局（HCollViewLayout）

    /// 瀑布流列数。仅 `HCollViewLayout` 有效，默认 2，至少 1。
    @objc
    optional func numberOfColumnsInSection(_ section: Int) -> Int

    /// section 背景色。仅 `HCollViewLayout` 有效。
    @objc
    optional func colorForSection(_ section: Int) -> UIColor

    /// header 尺寸。若同时实现了 `minimumHeaderSpacingForSectionAt`，则以间距作为高度（竖滑）或宽度（横滑）。
    @objc
    optional func sizeForHeaderInSection(_ section: Int) -> CGSize

    /// footer 尺寸。若同时实现了 `minimumFooterSpacingForSectionAt`，则以间距为准。
    @objc
    optional func sizeForFooterInSection(_ section: Int) -> CGSize

    /// item 尺寸。瀑布流模式下高度由此决定。
    @objc
    optional func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> CGSize

    /// header 最小间距。一旦实现，会覆盖 `sizeForHeaderInSection`。
    @objc
    optional func minimumHeaderSpacingForSectionAt(_ section: Int) -> CGFloat

    /// footer 最小间距。一旦实现，会覆盖 `sizeForFooterInSection`。
    @objc
    optional func minimumFooterSpacingForSectionAt(_ section: Int) -> CGFloat

    @objc
    optional func minimumLineSpacingForSectionAt(_ section: Int) -> CGFloat

    @objc
    optional func minimumInteritemSpacingForSectionAt(_ section: Int) -> CGFloat

    /// section 内边距。在 `numberOfItemsInSection` 时缓存，布局阶段读取。
    @objc
    optional func insetForSection(_ section: Int) -> UIEdgeInsets

    // MARK: - 复用入口

    /// 配置 header。内部应调用 `reuseHeader`。
    @objc
    optional func collHeader(_ coll: HCollView, atIndexPath indexPath: IndexPath)

    /// 配置 footer。内部应调用 `reuseFooter`。
    @objc
    optional func collFooter(_ coll: HCollView, atIndexPath indexPath: IndexPath)

    /// 配置 cell。内部应调用 `reuseCell`，随后 DataSource 会把同一实例返回给 UIKit。
    @objc
    optional func collItem(_ coll: HCollView, atIndexPath indexPath: IndexPath)

    @objc
    optional func willDisplayCell(_ cell: HCollBaseCell, atIndexPath indexPath: IndexPath)

    @objc
    optional func willDisplayHeader(_ header: HCollBaseApex, atIndexPath indexPath: IndexPath)

    @objc
    optional func willDisplayFooter(_ footer: HCollBaseApex, atIndexPath indexPath: IndexPath)

    @objc
    optional func didSelectCell(_ cell: HCollBaseCell, atIndexPath indexPath: IndexPath)

    // MARK: - 选中

    @objc
    optional func shouldSelectItemAtIndexPath(_ indexPath: IndexPath) -> Bool

    @objc
    optional func shouldDeselectItemAtIndexPath(_ indexPath: IndexPath) -> Bool

    @objc
    optional func didDeselectItemAtIndexPath(_ indexPath: IndexPath)

    // MARK: - 滚动（转发 UIScrollViewDelegate）

    @objc
    optional func collViewDidScroll(_ scrollView: UIScrollView)

    @objc
    optional func collViewDidZoom(_ scrollView: UIScrollView)

    @objc
    optional func collViewWillBeginDragging(_ scrollView: UIScrollView)

    @objc
    optional func collViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)

    @objc
    optional func collViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)

    @objc
    optional func collViewWillBeginDecelerating(_ scrollView: UIScrollView)

    @objc
    optional func collViewDidEndDecelerating(_ scrollView: UIScrollView)
}

/// `UICollectionView` 封装：自己做 dataSource / delegate，业务只实现 `HCollViewDelegate`。
/// 可选 Feature 通过 `HCollView+FeatureHooks` 挂到生命周期上，未加入工程则自动跳过。
class HCollView: UICollectionView {

    // MARK: - 常量

    internal enum Constants {
        static let emptyViewTag = 9999
        static let defaultPreloadDistanceRatio: CGFloat = 0.1
        static let minPreloadDistance: CGFloat = 100.0
        /// `reloadIfNeeded` 的默认防抖间隔。
        static let defaultRefreshThrottleInterval: TimeInterval = 0.15
        /// `reloadItemsIfNeeded` 的默认防抖间隔。
        static let defaultItemRefreshThrottleInterval: TimeInterval = 0.25
        /// item 尺寸下限，避免 UICollectionView 因 0 尺寸崩溃。
        static let minCellDimension: CGFloat = 1.0
    }

    // MARK: - 属性

    internal var flowLayout: UICollectionViewFlowLayout?
    internal weak var collDelegate: HCollViewDelegate?

    // MARK: - 复用登记

    internal var allHeaderIdentifiers = Set<String>()
    internal var allFooterIdentifiers = Set<String>()
    internal var allCellIdentifiers = Set<String>()
    /// 在 `numberOfItems` 时写入，布局阶段读取。
    internal var allSectionInsets = [Int: UIEdgeInsets]()
    /// 仅供当前这一次 `cellForItem` / supplementary 回调把 `reuseCell` 的实例交回 UIKit。
    internal var pendingReuseCell: HCollBaseCell?
    internal var pendingReuseHeader: HCollBaseApex?
    internal var pendingReuseFooter: HCollBaseApex?

    // MARK: - 内容与点击

    var contentSizeBlock: HCollCntSizeBlock?

    internal var currentContentSize: CGSize = .zero {
        didSet {
            if currentContentSize != oldValue {
                contentSizeBlock?(currentContentSize)
            }
        }
    }

    /// 点在空白处（非 cell / header / footer）时回调。设置后 `point(inside:)` 仍返回 true。
    var outsideContentBlock: HCollOutsideCntBlock?

    // MARK: - 刷新防抖

    internal var reloadWorkItem: DispatchWorkItem?
    internal var itemReloadWorkItem: DispatchWorkItem?
    internal var pendingItemReloads = Set<IndexPath>()

    /// `reloadIfNeeded` 的防抖间隔。
    var refreshThrottleInterval: TimeInterval = Constants.defaultRefreshThrottleInterval

    /// `reloadItemsIfNeeded` 的防抖间隔。
    var itemRefreshThrottleInterval: TimeInterval = Constants.defaultItemRefreshThrottleInterval

    // MARK: - Observer 分组

    /// `HCollObserver.refreshByKey` 用。
    var reloadCollKey: String = ""

    /// `HCollObserver.releaseByKey` 用。
    var releaseCollKey: String = ""

    // MARK: - 分页

    var preloadEnabled: Bool = true

    /// 当前页，默认 1。小于 1 时回退到 1。
    var pageNo: Int = HCollPageConfig.defaultPageNo {
        didSet {
            if pageNo < 1 {
                pageNo = HCollPageConfig.defaultPageNo
            }
            if pageNo == HCollPageConfig.defaultPageNo {
                self.lastPreloadTriggered = false
            }
        }
    }

    /// 每页条数，默认 20。小于 1 时回退到 20，允许小于默认值。
    var pageSize: Int = HCollPageConfig.defaultPageSize {
        didSet {
            if pageSize < 1 {
                pageSize = HCollPageConfig.defaultPageSize
            }
        }
    }

    /// 接近底部时触发，不增加 `pageNo`，与上拉加载互相独立。
    var preloadBlock: (() -> Void)?

    /// 是否已越过预加载阈值，避免同一位置重复触发。
    internal var lastPreloadTriggered: Bool = false

    /// 数据总条数。默认 10000 表示尚未设置上限，小于 1 时回退到该占位值。
    var totalNo: Int = HCollPageConfig.maxTotalPages {
        didSet {
            if totalNo < 1 {
                totalNo = HCollPageConfig.maxTotalPages
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

    /// 默认垂直滚动，使用 `HCollViewLayout`。
    convenience init(frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: HCollViewLayout())
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        flowLayout = layout as? UICollectionViewFlowLayout
        self.setup()
    }

    // MARK: - Delegate / DataSource

    /// 外部赋值只捕获 `HCollViewDelegate`；UIKit 的 delegate 始终是自身。
    weak override var delegate: UICollectionViewDelegate? {
        get { return super.delegate }
        set { collDelegate = newValue as? HCollViewDelegate }
    }

    /// 永远是自己的 dataSource，忽略外部赋值。
    weak override var dataSource: UICollectionViewDataSource? {
        get { return super.dataSource }
        set { _ = newValue }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        hcollRunOnMain {
            self.invokeFeature(HCollFeatureSelector.observerDeinit)
            self.collDelegate = nil
        }
    }
}
