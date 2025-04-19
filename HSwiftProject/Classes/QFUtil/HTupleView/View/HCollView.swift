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
import SDWebImage

@objc protocol HCollViewDelegate: UICollectionViewDelegate {
    @objc
    optional func numberOfSectionsInCollView() -> Any
    @objc
    optional func numberOfItemsInSection(_ section: Any) -> Any
    /// layout == HCollViewFlowLayout
    @objc
    optional func numberOfColumnsInSection(_ section: Any) -> Any
    /// layout == HCollViewLayout
    @objc
    optional func colorForSection(_ section: Any) -> UIColor

    @objc
    optional func sizeForHeaderInSection(_ section: Any) -> Any
    @objc
    optional func sizeForFooterInSection(_ section: Any) -> Any
    @objc
    optional func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any

    @objc
    optional func edgeInsetsForHeaderInSection(_ section: Any) -> Any
    @objc
    optional func edgeInsetsForFooterInSection(_ section: Any) -> Any
    @objc
    optional func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any

    @objc
    optional func minimumHeaderSpacingForSectionAt(_ section: Any) -> Any
    @objc
    optional func minimumFooterSpacingForSectionAt(_ section: Any) -> Any
    @objc
    optional func minimumLineSpacingForSectionAt(_ section: Any) -> Any
    @objc
    optional func minimumInteritemSpacingForSectionAt(_ section: Any) -> Any

    @objc
    optional func insetForSection(_ section: Any) -> Any
    
    @objc
    optional func collHeader(_ coll: HCollView, atIndexPath indexPath: IndexPath)
    @objc
    optional func collFooter(_ coll: HCollView, atIndexPath indexPath: IndexPath)
    @objc
    optional func collItem(_ coll: HCollView, atIndexPath indexPath: IndexPath)

    @objc
    optional func willDisplayCell(_ cell: HCollBaseCell, atIndexPath indexPath: IndexPath)
    
    @objc
    optional func didSelectCell(_ cell: HCollBaseCell, atIndexPath indexPath: IndexPath)

    /// UICollectionViewDelegate
    @objc
    optional func shouldHighlightItemAtIndexPath(_ indexPath: IndexPath) -> Bool
    @objc
    optional func didHighlightItemAtIndexPath(_ indexPath: IndexPath)
    @objc
    optional func didUnhighlightItemAtIndexPath(_ indexPath: IndexPath)
    @objc
    optional func shouldSelectItemAtIndexPath(_ indexPath: IndexPath) -> Bool
    @objc
    optional func shouldDeselectItemAtIndexPath(_ indexPath: IndexPath) -> Bool
    @objc
    optional func didDeselectItemAtIndexPath(_ indexPath: IndexPath)

    @objc
    optional func willDisplayElementKind(_ elementKind: String, atIndexPath indexPath: IndexPath)
    @objc
    optional func didEndDisplayingCell(_ cell: HCollBaseCell, forItemAtIndexPath indexPath: IndexPath)
    @objc
    optional func didEndDisplayingElementOfKind(_ elementKind: String, atIndexPath indexPath: IndexPath)

    /// UIScrollViewDelegate
    @objc
    optional func collViewDidScroll(_ scrollView: UIScrollView)
    @objc
    optional func collViewDidZoom(_ scrollView: UIScrollView)

    @objc
    optional func collViewWillBeginDragging(_ scrollView: UIScrollView)

    @objc
    optional func collViewWillEndDragging(_ velocity: CGPoint, targetContentOffset: CGPoint)

    @objc
    optional func collViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)

    @objc
    optional func collViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @objc
    optional func collViewDidEndDecelerating(_ scrollView: UIScrollView)

    @objc
    optional func collViewDidEndScrollingAnimation(_ scrollView: UIScrollView)

    @objc
    optional func collViewForZoomingInScrollView(_ scrollView: UIScrollView) -> UIView?
    @objc
    optional func collViewWillBeginZooming(_ scrollView: UIScrollView, withView view: UIView?)
    @objc
    optional func collViewDidEndZooming(_ view: UIView?, atScale scale: CGFloat)

    @objc
    optional func collViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool
    @objc
    optional func collViewDidScrollToTop(_ scrollView: UIScrollView)

    @objc
    optional func collViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)
}

class HCollView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, HCollViewLayoutDelegate {

    private var flowLayout: UICollectionViewFlowLayout?

    // 获取到实际内容大小时的回调
    var cntSizeBlock: HCollCntSizeBlock?
    private var oldCntSize: CGSize = .zero {
        didSet {
            if oldCntSize != oldValue {
                cntSizeBlock?(oldCntSize)
            }
        }
    }
    
    // 实际内容之外的区域被点击回调
    var outsideCntBlock: HCollOutsideCntBlock?

    // coll style
    private var collStyle: HCollStyle = .coll
    
    // delay reload coll
    private var collReload = HCollReload()
    
    // 用于发送刷新列表的事件
    let refreshSubject = PassthroughSubject<Void, Never>()
    
    // 用于存储订阅关系，避免提前释放
    private var cancellables = Set<AnyCancellable>()
    
    // delay reload item
    private var allReloadItems: [IndexPath] = []
    private var reloadedItems: [IndexPath] = []
    private var itemReload = HCollReload()
    
    // coll align
    private var alignStrategy: HCollAlignStrategy = HCollDefaultAlignStrategy()
    var collAlign: HCollAlign = .default {
        didSet {
            alignStrategy = HCollAlignStrategyFactory.createStrategy(for: collAlign)
            updateAlign()
        }
    }
    
    // cell height
    var cellHeights: [Int: CGFloat] = [:]

    private var sectionPaths = NSArray()
    private var allReuseIdentifiers = NSMutableSet()
    var allSectionInsets = NSMapTable<NSString, NSString>.strongToStrongObjects()
    var allReuseCells    = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    var allPassedCells   = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    var allReuseHeaders  = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    var allReuseFooters  = NSMapTable<NSString, AnyObject>.strongToWeakObjects()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Default scrolling direction is vertical
    convenience init(frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: HCollViewLayout(.vertical))
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        flowLayout = layout as? UICollectionViewFlowLayout
        self.setup()
    }

    static func splitFrame(_ frame: () -> CGRect, exclusiveSections sections: () -> NSArray, layout: () -> UICollectionViewFlowLayout) -> HCollView {
        return HCollView(frame(), style: .split, exclusiveSections: sections(), layout: layout())
    }
    
    static func collFrame(_ frame: () -> CGRect, layout: () -> UICollectionViewFlowLayout) -> HCollView {
        return HCollView(frame(), style: .coll, exclusiveSections: [], layout: layout())
    }

    private convenience init(_ frame: CGRect, style: HCollStyle, exclusiveSections sectionPaths: NSArray, layout: UICollectionViewFlowLayout) {
        self.init(frame: UIRectIntegral(frame), collectionViewLayout: layout)
        self.sectionPaths = sectionPaths
        self.collStyle = style
    }

    private weak var collDelegate: HCollViewDelegate?
    weak override var delegate: UICollectionViewDelegate? {
        get { return super.delegate }
        set { collDelegate = newValue as? HCollViewDelegate }
    }
    weak override var dataSource: UICollectionViewDataSource? {
        get { return super.dataSource }
        set { _ = newValue }
    }

    override var frame: CGRect {
        get { return super.frame }
        set {
            let frame = UIRectIntegral(newValue)
            guard frame != super.frame else { return }
            super.frame = frame
            self.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 更新对齐方式
        self.updateAlign()
    }
    
    // 更新对齐方式
    private func updateAlign() {
        let cntSize = self.contentSize
        let cntInset = self.contentInset
        self.oldCntSize = cntSize //保存contentSize
        self.contentInset = alignStrategy.calculateCntInset(for: self, cntSize: cntSize, cntInset: cntInset)
    }

    private func setup() {
        // Save collView for global refresh
        HCollObserver.shared.addObserver(self)

        // Set default tag
        self.tag = kCollDefaultTag

        if self.flowLayout?.scrollDirection == .vertical {
            self.enableVerticalBounce()
        }else {
            self.enableHorizontalBounce()
        }
        self.backgroundColor = .clear
        self.keyboardDismissMode = .onDrag
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false

        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        super.delegate = self
        super.dataSource = self
        
        // 配置节流操作
        refreshSubject
            .throttle(for: .seconds(2), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] in
                self?.reloadData()
            }
            .store(in: &cancellables)

    }

    /// Page number, Default 1
    var pageNo: Int = kCollPageNo {
        didSet {
            if pageNo <= 0 {
                pageNo = kCollPageNo
            }
        }
    }

    /// Page size, Default 20
    var pageSize: Int = kCollPageSize {
        didSet {
            if pageSize <= 0 {
                pageSize = kCollPageSize
            }
        }
    }

    /// Total number. Default 10000
    var totalNo: Int = kCollTotalPageNo {
        didSet {
            if totalNo <= 0 {
                totalNo = kCollTotalPageNo
            }
        }
    }

    /// Refresh header style
    var refreshHeaderStyle: HCollRefreshHeaderStyle = .gray

    /// Load more footer style
    var refreshFooterStyle: HCollRefreshFooterStyle = .style1

    /// Block to refresh data
    var refreshBlock: HCollRefreshBlock? {
        didSet {
            if let refreshBlock = refreshBlock {
                self.mj_header = HCollRefresh.refreshHeaderWithStyle(refreshHeaderStyle) { [weak self] in
                    guard let self = self else { return }
                    self.pageNo = 1
                    refreshBlock()
                }
            } else {
                self.mj_header = nil
            }
        }
    }

    /// Block to load more data
    var loadMoreBlock: HCollLoadMoreBlock? {
        didSet {
            if let loadMoreBlock = loadMoreBlock {
                self.pageNo = 1
                self.mj_footer = HCollRefresh.refreshFooterWithStyle(refreshFooterStyle) { [weak self] in
                    guard let self = self else { return }
                    self.pageNo += 1
                    if self.pageSize * self.pageNo < self.totalNo {
                        loadMoreBlock()
                    } else {
                        self.mj_footer?.endRefreshing()
                    }
                }
            } else {
                self.mj_footer = nil
            }
        }
    }

    /// Block refresh & loadMore
    func beginRefreshing(_ completion: @escaping () -> Void) {
        guard self.refreshBlock != nil else { return }
        self.pageNo = 1
        self.mj_header?.beginRefreshing(completionBlock: completion)
    }

    /// Stop refresh
    func endRefreshing(_ completion: @escaping () -> Void) {
        self.mj_header?.endRefreshing(completionBlock: completion)
    }

    func endLoadMore(_ completion: @escaping () -> Void) {
        self.mj_footer?.endRefreshing(completionBlock: completion)
    }

    /// Whether the header and footer are sticky
    var sectionHeadersPinToVisibleBounds: Bool {
        get { return flowLayout?.sectionHeadersPinToVisibleBounds ?? false }
        set { flowLayout?.sectionHeadersPinToVisibleBounds = newValue }
    }

    var sectionFootersPinToVisibleBounds: Bool {
        get { return flowLayout?.sectionFootersPinToVisibleBounds ?? false }
        set { flowLayout?.sectionFootersPinToVisibleBounds = newValue }
    }

    /// Bounce method
    func enableHorizontalBounce() {
        self.bounces = true
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = false
    }

    func enableVerticalBounce() {
        self.bounces = true
        self.alwaysBounceHorizontal = false
        self.alwaysBounceVertical = true
    }

    func enableBounce() {
        self.bounces = true
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = true
    }

    func disableBounce() {
        self.bounces = false
    }
    
    /// Scroll to top
    func scrollToTop(_ animated: Bool) {
        DispatchQueue.mainAsync { [weak self] in
            guard let self = self else { return }
            let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
            self.scrollRectToVisible(rect, animated: animated)
        }
    }

    /// Scroll to bottom
    func scrollsToBottom(_ animated: Bool) {
        DispatchQueue.mainAsync { [weak self] in
            guard let self = self else { return }
            let sections = self.numberOfSections
            let items = self.numberOfItems(inSection: sections - 1)
            let indexPath = IndexPath(row: items - 1, section: sections - 1)
            self.scrollToItem(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    // 多少秒内只刷新一次
    func reloadIfNeeded(_ delay: TimeInterval = 2.0) {
        if self.collReload.isRefresh {
            self.collReload.needRefresh = true
        }else {
            self.reloadAsync(delay)
        }
    }
    
    private func reloadAsync(_ delay: TimeInterval) {
        self.collReload.isRefresh = true
        self.collReload.needRefresh = false
        self.reloadCollData()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            if self.collReload.needRefresh {
                self.reloadAsync(delay)
            }else {
                self.collReload.isRefresh = false
            }
        }
    }
    
    // 多少秒内只刷新一次
    func reloadItemsIfNeeded(at indexPaths: [IndexPath], _ delay: TimeInterval = 0.25) {
        self.allReloadItems.append(contentsOf: indexPaths)
        
        if self.itemReload.isRefresh {
            self.itemReload.needRefresh = true
        }else {
            self.reloadItemsAsync(at: indexPaths, delay)
        }
    }
    
    private func reloadItemsAsync(at indexPaths: [IndexPath], _ delay: TimeInterval) {
        self.itemReload.isRefresh = true
        self.itemReload.needRefresh = false
        self.reloadedItems.append(contentsOf: indexPaths)
        DispatchQueue.mainAsync { [weak self] in
            self?.reloadItems(at: indexPaths)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            if self.itemReload.needRefresh {
                // 更改标签
                self.itemReload.needRefresh = false
                // 将数组转换为集合，通过集合差集操作实现删除效果
                let finalArrayAll = Array(Set(self.allReloadItems).subtracting(Set(self.reloadedItems)))
                if !finalArrayAll.isEmpty { //递归调用
                    self.reloadItemsAsync(at: finalArrayAll, delay)
                }
            }else {
                self.itemReload.isRefresh = false
                self.allReloadItems.removeAll()
                self.reloadedItems.removeAll()
            }
        }
    }
    
    @objc
    func reloadCollData() {
        DispatchQueue.mainAsync { [weak self] in
            self?.reloadData()
        }
    }

    /// Release method
    @objc
    func releaseCollBlock() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.releaseAllSignal()
            self?.clearCollState()

            DispatchQueue.main.async { [weak self] in
                self?.collDelegate = nil
                self?.loadMoreBlock = nil
                self?.refreshBlock = nil
                self?.dataSource = nil
                self?.delegate = nil
            }
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let outsideCntBlock = self.outsideCntBlock else {
            return super.point(inside: point, with: event)
        }
        // 将点击的点转换为collectionView的坐标系
        let pointForCollectionView = convert(point, from: self)
        
        // 检查点击是否在任何可见的item或者supplementary view上
        guard let layoutAttributes = collectionViewLayout.layoutAttributesForElements(in: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)) else {
            return true
        }
        
        // 点击是否在cell或header/footer上
        for attribute in layoutAttributes {
            if attribute.representedElementCategory == .cell || attribute.representedElementCategory == .supplementaryView {
                if attribute.frame.contains(pointForCollectionView) {
                    return true
                }
            }
        }
        // 如果点击不在任何cell或header/footer上
        outsideCntBlock()
        return true
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        HCollObserver.shared.removeObserver(self)
        self.removeFromSuperview()
        self.collDelegate = nil
        self.dataSource = nil
        self.delegate = nil
    }

    /// Register class
    @discardableResult
    func reuseHeader(_ cls: AnyClass, _ pre: String?, _ idx: Bool, _ indexPath: IndexPath) -> AnyObject {
        // Unique identifier
        var identifier = (pre ?? "") + NSStringFromClass(cls)
        // Determine whether it contains an index
        identifier += idx ? indexPath.stringValue : ""
        // Determine if there is a coll state value
        identifier += "\(self.collState)"
        // Register cell if not already registered
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as! HCollBaseApex
        cell.indexPath = indexPath
        cell.isHeader = true
        cell.coll = self
        // Save cell
        self.allReuseHeaders.setObject(cell, forKey: IndexPath.nsStringValue(0, indexPath.section))
        // Call delegate method
        var edgeInsets: UIEdgeInsets = .zero
        if let delegate = self.collDelegate {
            let prefix = self.collSplitPrefix(indexPath.section)
            let selector: Selector = #selector(delegate.edgeInsetsForHeaderInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                edgeInsets = delegate.performWithUnretainedValue(selector, with: indexPath.section, withPre: prefix) as! UIEdgeInsets
            }
        }
        // Set properties
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        // Return cell
        return cell
    }

    @discardableResult
    func reuseFooter(_ cls: AnyClass, _ pre: String?, _ idx: Bool, _ indexPath: IndexPath) -> AnyObject {
        // Unique identifier
        var identifier = (pre ?? "") + NSStringFromClass(cls)
        // Determine whether it contains an index
        identifier += idx ? indexPath.stringValue : ""
        // Determine if there is a coll state value
        identifier += "\(self.collState)"
        // Register cell if not already registered
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath) as! HCollBaseApex
        cell.indexPath = indexPath
        cell.isHeader = false
        cell.coll = self
        // Save cell
        self.allReuseFooters.setObject(cell, forKey: IndexPath.nsStringValue(0, indexPath.section))
        // Call delegate method
        var edgeInsets: UIEdgeInsets = .zero
        if let delegate = self.collDelegate {
            let prefix = self.collSplitPrefix(indexPath.section)
            let selector = #selector(delegate.edgeInsetsForFooterInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                edgeInsets = delegate.performWithUnretainedValue(selector, with: indexPath.section, withPre: prefix) as! UIEdgeInsets
            }
        }
        // Set properties
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        // Return cell
        return cell
    }
    
    @discardableResult
    func reuseCell(_ cls: AnyClass, _ pre: String?, _ idx: Bool, _ indexPath: IndexPath) -> AnyObject {
        // Unique identifier
        var identifier = (pre ?? "") + NSStringFromClass(cls)
        // Determine whether it contains an index
        identifier += idx ? indexPath.stringValue : ""
        // Determine if there is a coll state value
        identifier += "\(self.collState)"
        // Register cell if not already registered
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forCellWithReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! HCollBaseCell
        cell.indexPath = indexPath
        cell.coll = self
        // Save cell
        self.allReuseCells.setObject(cell, forKey: indexPath.nsStringValue)
        // Call delegate method
        var edgeInsets: UIEdgeInsets = .zero
        if let delegate = self.collDelegate {
            let prefix = self.collSplitPrefix(indexPath.section)
            let selector = #selector(delegate.edgeInsetsForItemAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                edgeInsets = delegate.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! UIEdgeInsets
            }
        }
        // Set properties
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        // Return cell
        return cell
    }

    /// UICollectionViewDatasource  & delegate
    private func scrollSplitPrefix() -> String {
        var prefix = ""
        if self.collStyle == .split {
            if self.sectionPaths.contains(self.collState) {
                prefix = kCollDesignKey + "\(self.collState)" + "_"
            }
        }
        return prefix
    }
    
    func collSplitPrefix(_ section: Int) -> String {
        var prefix = ""
        if self.collStyle == .split {
            if self.sectionPaths.contains(section) {
                let idx = self.sectionPaths.index(of: section)
                prefix = kCollExaDesignKey + "\(idx)" + "_"
            }else {
                prefix = kCollDesignKey + "\(self.collState)" + "_"
            }
        }
        return prefix
    }

    /// The following are UICollectionView delegate methods
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        // remove cache data
        self.allReuseIdentifiers.removeAllObjects()
        self.allSectionInsets.removeAllObjects()
        // coll Style
        var sections = 1
        switch self.collStyle {
        case .coll:
            if let delegate = self.collDelegate {
                let prefix = ""
                let selector = #selector(delegate.numberOfSectionsInCollView)
                if delegate.responds(to: selector, withPre: prefix) {
                    sections = delegate.performWithUnretainedValue(selector, withPre: prefix) as! Int
                }
                // Prevents quantity from being less than 1
                sections = max(sections, 1)
            }
        case .split:
            if let delegate = self.collDelegate {
                let prefix = kCollDesignKey + "\(self.collState)" + "_"
                let selector = #selector(delegate.numberOfSectionsInCollView)
                if delegate.responds(to: selector, withPre: prefix) {
                    sections = delegate.performWithUnretainedValue(selector, withPre: prefix) as! Int
                }
                // Prevents quantity from being less than 1
                sections = max(sections, 1)
            }
        }
        return sections
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items = 0
        if let delegate = self.collDelegate {
            // Get the number of items
            let prefix = self.collSplitPrefix(section)
            let itemSelector: Selector = #selector(delegate.numberOfItemsInSection(_:))
            if delegate.responds(to: itemSelector, withPre: prefix) {
                items = delegate.performWithUnretainedValue(itemSelector, with: section, withPre: prefix) as! Int
            }

            // Get the edgeInsets of the section
            var edgeInsets: UIEdgeInsets = .zero
            let insetSelector = #selector(delegate.insetForSection(_:))
            if delegate.responds(to: insetSelector, withPre: prefix) {
                edgeInsets = delegate.performWithUnretainedValue(insetSelector, with: section, withPre: prefix) as! UIEdgeInsets
            }
            self.allSectionInsets.setObject(NSStringFromUIEdgeInsets(edgeInsets), forKey: "\(section)" as NSString)

            // Prevents quantity from being less than 0
            items = max(items, 0)
        }
        return items
    }
    
    /// layout == HCollViewFlowLayout
    internal func collectionView(_ collectionView: UICollectionView, numberOfColumnsInSection section: Int) -> Int {
        var items = 2
        if let delegate = self.collDelegate {
            // Get the number of items
            let prefix = self.collSplitPrefix(section)
            let itemSelector: Selector = #selector(delegate.numberOfColumnsInSection(_:))
            if delegate.responds(to: itemSelector, withPre: prefix) {
                items = delegate.performWithUnretainedValue(itemSelector, with: section, withPre: prefix) as! Int
            }

            // Prevents quantity from being less than 0
            items = max(items, 2)
        }
        return items
    }

    /// layout == HCollViewLayout
    internal func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, colorForSectionAt section: NSInteger) -> UIColor {
        if let delegate = self.collDelegate {
            let prefix = self.collSplitPrefix(section)
            let selector = #selector(delegate.colorForSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! UIColor
            }
        }
        return UIColor.clear
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let delegate = self.collDelegate {
            let prefix = self.collSplitPrefix(section)
            let selector = #selector(delegate.minimumLineSpacingForSectionAt(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
            }
        }
        return 0.0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let delegate = self.collDelegate {
            let prefix = self.collSplitPrefix(section)
            let selector = #selector(delegate.minimumInteritemSpacingForSectionAt(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
            }
        }
        return 0.0
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //Get the edgeInsets of the section
        var edgeInsets: UIEdgeInsets = .zero
        let edgeInsetsString = self.allSectionInsets.object(forKey: "\(section)" as NSString) as? String
        if let edgeInsetsString = edgeInsetsString, !edgeInsetsString.isEmpty {
           edgeInsets = UIEdgeInsetsFromString(edgeInsetsString)
        }
        return edgeInsets
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size = CGSize.zero
        if let delegate = self.collDelegate {
            let prefix = self.collSplitPrefix(section)
            let selector: Selector = #selector(delegate.minimumHeaderSpacingForSectionAt(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                let spacing: CGFloat = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
                if self.flowLayout?.scrollDirection == .vertical {
                    size = CGSize(width: self.width, height: spacing)
                }else {
                    size = CGSize(width: spacing, height: self.height)
                }
            } else {
                let selector = #selector(delegate.sizeForHeaderInSection(_:))
                if delegate.responds(to: selector, withPre: prefix) {
                    size = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGSize
                }
            }
            // Prevent negative size
            size.width = max(size.width, 0.0)
            size.height = max(size.height, 0.0)
        }
        return UISizeIntegral(size)
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        var size = CGSize.zero
        if let delegate = self.collDelegate {
            let prefix = self.collSplitPrefix(section)
            let selector: Selector = #selector(delegate.minimumFooterSpacingForSectionAt(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                let spacing: CGFloat = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
                if self.flowLayout?.scrollDirection == .vertical {
                    size = CGSize(width: self.width, height: spacing)
                }else {
                    size = CGSize(width: spacing, height: self.height)
                }
            } else {
                let selector = #selector(delegate.sizeForFooterInSection(_:))
                if delegate.responds(to: selector, withPre: prefix) {
                    size = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGSize
                }
            }
            // Prevent negative size
            size.width = max(size.width, 0.0)
            size.height = max(size.height, 0.0)
        }
        return UISizeIntegral(size)
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //item size cannot be zero, otherwise it will crash
        var size = CGSize(width: 1.0, height: 1.0)
        if let delegate = self.collDelegate {
            let prefix = self.collSplitPrefix(indexPath.section)
            let selector = #selector(delegate.sizeForItemAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                size = delegate.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! CGSize
            }
            // Prevent negative size
            if size.width <= 0 { size.width = 1.0 }
            if size.height <= 0 { size.height = 1.0 }
        }
        return UISizeIntegral(size)
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Call delegate method
        if let delegate = self.collDelegate {
            let prefix = self.collSplitPrefix(indexPath.section)
            let selector: Selector = #selector(delegate.collItem(_:atIndexPath:))
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: self, with: indexPath, withPre: prefix)
            }
        }
        // Call cell
        if let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HCollBaseCell {
            // Update layout
            if cell.responds(to: #selector(cell.relayoutSubviews)) {
                cell.relayoutSubviews()
            }
            // Update passed cells
            if self.allPassedCells.count > 20 {
                self.allPassedCells.removeAllObjects()
                SDImageCache.shared.clearMemory()
                SDImageCache.shared.clearDisk(onCompletion: {})
                KingfisherManager.shared.cache.clearMemoryCache()
            }
            self.allPassedCells.setObject(cell, forKey: indexPath.nsStringValue)
            return cell
        }
        self.register(HCollBaseCell.self, forCellWithReuseIdentifier: HCollBaseCell.className)
        return self.dequeueReusableCell(withReuseIdentifier: HCollBaseCell.className, for: indexPath)
    }

    internal func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            // Call delegate method
            if let delegate = self.collDelegate {
                let prefix = self.collSplitPrefix(indexPath.section)
                let selector: Selector = #selector(delegate.minimumHeaderSpacingForSectionAt(_:))
                if delegate.responds(to: selector, withPre: prefix) {
                    // Unique identifier
                    let identifier = indexPath.stringValue + "\(self.collState)"
                    // Register cell if not already registered
                    if !self.allReuseIdentifiers.contains(identifier) {
                        self.allReuseIdentifiers.add(identifier)
                        self.register(HCollBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
                    }
                    // Dequeue cell
                    return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath)
                } else {
                    let selector: Selector = #selector(delegate.collHeader(_:atIndexPath:))
                    if delegate.responds(to: selector, withPre: prefix) {
                        delegate.perform(selector, with: self, with: indexPath, withPre: prefix)
                    }
                }
            }
            // Call cell
            if let cell = self.allReuseHeaders.object(forKey: indexPath.nsStringValue) as? HCollBaseApex {
                // Update layout
                if cell.responds(to: #selector(cell.relayoutSubviews)) {
                    cell.relayoutSubviews()
                }
                return cell
            }
            self.register(HCollBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HCollBaseApex.className)
            return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HCollBaseApex.className, for: indexPath)
        }else {
            // Call delegate method
            if let delegate = self.collDelegate {
                let prefix = self.collSplitPrefix(indexPath.section)
                let selector: Selector = #selector(delegate.minimumFooterSpacingForSectionAt(_:))
                if delegate.responds(to: selector, withPre: prefix) {
                    // Unique identifier
                    let identifier = indexPath.stringValue + "\(self.collState)"
                    // Register cell if not already registered
                    if !self.allReuseIdentifiers.contains(identifier) {
                        self.allReuseIdentifiers.add(identifier)
                        self.register(HCollBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
                    }
                    // Dequeue cell
                    return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath)
                } else {
                    let selector: Selector = #selector(delegate.collFooter(_:atIndexPath:))
                    if delegate.responds(to: selector, withPre: prefix) {
                        delegate.perform(selector, with: self, with: indexPath, withPre: prefix)
                    }
                }
            }
            // Call cell
            if let cell = self.allReuseFooters.object(forKey: indexPath.nsStringValue) as? HCollBaseApex {
                // Update layout
                if cell.responds(to: #selector(cell.relayoutSubviews)) {
                    cell.relayoutSubviews()
                }
                return cell
            }
            self.register(HCollBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HCollBaseApex.className)
            return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HCollBaseApex.className, for: indexPath)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HCollBaseCell
        if let willDisplayBlock = cell?.willDisplayBlock {
            willDisplayBlock()
        }else if let delegate = self.collDelegate, let cell = cell {
            let prefix = self.collSplitPrefix(indexPath.section)
            let selector = #selector(delegate.willDisplayCell(_:atIndexPath:))
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: cell, with: indexPath, withPre: prefix)
            }
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HCollBaseCell
        if let selectBlock = cell?.selectBlock {
            selectBlock()
        }else if let delegate = self.collDelegate, let cell = cell {
            let prefix = self.collSplitPrefix(indexPath.section)
            let selector = #selector(delegate.didSelectCell(_:atIndexPath:))
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: cell, with: indexPath, withPre: prefix)
            }
        }
    }

    /// UICollectionViewDelegate
    internal func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        if let delegate = self.collDelegate {
            let prefix = self.collSplitPrefix(indexPath.section)
            let selector = #selector(delegate.shouldHighlightItemAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return true
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.collSplitPrefix(indexPath.section)
        let selector = #selector(delegate.didHighlightItemAtIndexPath(_:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: indexPath, withPre: prefix)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.collSplitPrefix(indexPath.section)
        let selector = #selector(delegate.didUnhighlightItemAtIndexPath(_:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: indexPath, withPre: prefix)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let delegate = self.collDelegate {
            let prefix = self.collSplitPrefix(indexPath.section)
            let selector = #selector(delegate.shouldSelectItemAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return true
    }
    
    internal func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if let delegate = self.collDelegate {
            let prefix = self.collSplitPrefix(indexPath.section)
            let selector = #selector(delegate.shouldDeselectItemAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return false
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.collSplitPrefix(indexPath.section)
        let selector = #selector(delegate.didDeselectItemAtIndexPath(_:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: indexPath, withPre: prefix)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.collSplitPrefix(indexPath.section)
        let selector = #selector(delegate.willDisplayElementKind(_:atIndexPath:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: elementKind, with: indexPath, withPre: prefix)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.collSplitPrefix(indexPath.section)
        let selector = #selector(delegate.didEndDisplayingCell(_:forItemAtIndexPath:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: cell, with: indexPath, withPre: prefix)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.collSplitPrefix(indexPath.section)
        let selector = #selector(delegate.didEndDisplayingElementOfKind(_:atIndexPath:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: elementKind, with: indexPath, withPre: prefix)
        }
    }

    /// UIScrollViewDelegate
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("collViewDidScroll:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }
    
    internal func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("collViewDidZoom:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("collViewWillBeginDragging:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

    internal func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        //let selector = NSSelectorFromString("collViewWillEndDragging:withVelocity:targetContentOffset:")
        let selector = NSSelectorFromString("collViewWillEndDragging:targetContentOffset:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: velocity, with: targetContentOffset, withPre: prefix)
        }
    }

    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("collViewDidEndDragging:willDecelerate:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, with: decelerate, withPre: prefix)
        }
        // Update passed cells
        if !decelerate, self.allPassedCells.count > 5 {
            self.allPassedCells.removeAllObjects()
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk(onCompletion: {})
            KingfisherManager.shared.cache.clearMemoryCache()
        }
    }

    internal func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("collViewWillBeginDecelerating:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("collViewDidEndDecelerating:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
        // Update passed cells
        if self.allPassedCells.count > 5 {
            self.allPassedCells.removeAllObjects()
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk(onCompletion: {})
            KingfisherManager.shared.cache.clearMemoryCache()
        }
    }

    internal func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("collViewDidEndScrollingAnimation:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if let delegate = self.collDelegate {
            let prefix = self.scrollSplitPrefix()
            let selector = NSSelectorFromString("collViewForZoomingInScrollView:")
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: scrollView, withPre: prefix) as? UIView
            }
        }
        return nil
    }
    
    internal func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("collViewWillBeginZooming:withView:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, with: view as Any, withPre: prefix)
        }
    }
    
    internal func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("collViewDidEndZooming:atScale:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: view as Any, with: scale, withPre: prefix)
        }
    }

    internal func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let delegate = self.collDelegate {
            let prefix = self.scrollSplitPrefix()
            let selector = NSSelectorFromString("collViewShouldScrollToTop:")
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: scrollView, withPre: prefix) as! Bool
            }
        }
        return true
    }
    
    internal func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("collViewDidScrollToTop:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

    internal func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        guard let delegate = self.collDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("collViewDidChangeAdjustedContentInset:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

}
