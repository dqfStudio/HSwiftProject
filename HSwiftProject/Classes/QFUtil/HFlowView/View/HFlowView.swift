//
//  HFlowView.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/10.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

enum HFlowDirection: Int {
    case vertical = 0 // Vertical design
    case horizontal = 1 // Horizontal design
}

private enum HFlowStyle: Int {
    case `default` // Singleton design
    case split // Split design
}

enum HFlowAlign {
    case `default` // 垂直居上，水平居左
    case center // 垂直居中，水平居中
    case top(CGFloat) // 垂直距离顶部的距离，水平居中
    case ratio(CGFloat) // 垂直距离顶部的比例，水平居中
    case bottom(CGFloat) // 垂直距离底部的距离，水平居中
}

var kFlowDefaultTag = 121314151617

private var kFlowPageNo = 1
private var kFlowPageSize = 20
private var kFlowTotalPageNo = 10000

private var kFlowDesignKey = "flow"
private var kFlowExaDesignKey = "flowExa"

private var kFlowStateKey: Void?
private var kFlowSignalKey: Void?
private var kFlowStateSourceKey: Void?

/// Refresh & LoadMore block
typealias HFlowRefreshBlock = () -> Void
typealias HFlowLoadMoreBlock = () -> Void
typealias HFlowOutsideCntBlock = () -> Void

/// This class is used for refreshing flowView throughout the project.
class HFlowAppearance: NSObject {

    private static var hashFlows = NSHashTable<HFlowView>.weakObjects()

    static func addFlow(_ anFlow: HFlowView) {
        self.hashFlows.add(anFlow)
    }
    static func refreshFlows(_ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            // Execute in reverse order
            let flows = self.hashFlows.allObjects.reversed()
            flows.forEach { $0.reloadFlowData() }
            DispatchQueue.main.async { completion() }
        }
    }
    static func refreshFlow(key: String, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            // Execute in reverse order
            let flows = self.hashFlows.allObjects.filter { $0.reloadFlowKey == key }.reversed()
            flows.forEach { $0.reloadFlowData() }
            DispatchQueue.main.async { completion() }
        }
    }
    static func releaseFlow(key: String, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            // Execute in reverse order
            let flows = self.hashFlows.allObjects.filter { $0.releaseFlowKey == key }.reversed()
            flows.forEach { $0.releaseFlowBlock() }
            DispatchQueue.main.async { completion() }
        }
    }
}

@objc protocol HFlowViewDelegate: UICollectionViewDelegate {
    @objc
    optional func numberOfSectionsInFlowView() -> Any
    @objc
    optional func insetForSection(_ section: Any) -> Any
    @objc
    optional func numberOfItemsInSection(_ section: Any) -> Any
    /// layout == HFlowViewLayout
    @objc
    optional func colorForSection(_ section: Any) -> UIColor
    
    @objc
    optional func sizeForHeaderInSection(_ section: Any) -> Any
    @objc
    optional func sizeForFooterInSection(_ section: Any) -> Any

    @objc
    optional func minimumHeaderSpacingForSectionAt(_ section: Any) -> Any
    @objc
    optional func minimumFooterSpacingForSectionAt(_ section: Any) -> Any
    @objc
    optional func minimumLineSpacingForSectionAt(_ section: Any) -> Any
    @objc
    optional func minimumInteritemSpacingForSectionAt(_ section: Any) -> Any
    
    @objc
    optional func flowHeader(_ flow: HFlowView, atIndexPath indexPath: IndexPath)
    @objc
    optional func flowFooter(_ flow: HFlowView, atIndexPath indexPath: IndexPath)
    @objc
    optional func flowItem(_ flow: HFlowView, atIndexPath indexPath: IndexPath)

    @objc
    optional func willDisplayCell(_ cell: HFlowBaseCell, atIndexPath indexPath: IndexPath)
    
    @objc
    optional func didSelectCell(_ cell: HFlowBaseCell, atIndexPath indexPath: IndexPath)

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
    optional func didEndDisplayingCell(_ cell: HFlowBaseCell, forItemAtIndexPath indexPath: IndexPath)
    @objc
    optional func didEndDisplayingElementOfKind(_ elementKind: String, atIndexPath indexPath: IndexPath)

    /// UIScrollViewDelegate
    @objc
    optional func flowViewDidScroll(_ scrollView: UIScrollView)
    @objc
    optional func flowViewDidZoom(_ scrollView: UIScrollView)

    @objc
    optional func flowViewWillBeginDragging(_ scrollView: UIScrollView)

    @objc
    optional func flowViewWillEndDragging(_ velocity: CGPoint, targetContentOffset: CGPoint)

    @objc
    optional func flowViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)

    @objc
    optional func flowViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @objc
    optional func flowViewDidEndDecelerating(_ scrollView: UIScrollView)

    @objc
    optional func flowViewDidEndScrollingAnimation(_ scrollView: UIScrollView)

    @objc
    optional func flowViewForZoomingInScrollView(_ scrollView: UIScrollView) -> UIView?
    @objc
    optional func flowViewWillBeginZooming(_ scrollView: UIScrollView, withView view: UIView?)
    @objc
    optional func flowViewDidEndZooming(_ view: UIView?, atScale scale: CGFloat)

    @objc
    optional func flowViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool
    @objc
    optional func flowViewDidScrollToTop(_ scrollView: UIScrollView)

    @objc
    optional func flowViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)
}

class HFlowView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, HFlowViewLayoutDelegate {

    private var flowLayout: UICollectionViewFlowLayout?

    // Flow style
    private var flowStyle: HFlowStyle = .default
    
    // 实际内容之外的区域被点击
    var outsideCntBlock: HFlowOutsideCntBlock?
    
    // flow align
    var flowAlign: HFlowAlign = .default

    private var sectionPaths = NSArray()
    private var allReuseIdentifiers = NSMutableSet()
    private var allSectionInsets = NSMapTable<NSString, NSString>.strongToStrongObjects()
    private var allReuseCells   = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    private var allReuseHeaders = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    private var allReuseFooters = NSMapTable<NSString, AnyObject>.strongToWeakObjects()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /// Default scrolling direction is vertical
    convenience init(frame: CGRect) {
        self.init(frame: frame, scrollDirection: .vertical)
    }

    /// Default layout is HFlowViewLayout
    convenience init(frame: CGRect, scrollDirection direction: HFlowDirection) {
        self.init(frame: frame, collectionViewLayout: HFlowViewLayout(direction))
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        flowLayout = layout as? UICollectionViewFlowLayout
        self.setup()
    }

    /// Initialization method for split
    static func flowFrame(_ frame: () -> CGRect, exclusiveSections sections: () -> NSArray) -> HFlowView {
        return HFlowView(frame(), exclusiveSections: sections(), scrollDirection: .vertical)
    }
    
    static func flowFrame(_ frame: () -> CGRect, scrollDirection direction: () -> HFlowDirection, exclusiveSections sections: () -> NSArray) -> HFlowView {
        return HFlowView(frame(), exclusiveSections: sections(), scrollDirection: direction())
    }

    private convenience init(_ frame: CGRect, exclusiveSections sectionPaths: NSArray, scrollDirection direction: HFlowDirection) {
        self.init(frame: UIRectIntegral(frame), collectionViewLayout: HFlowViewLayout(direction))
        self.sectionPaths = sectionPaths
        self.flowStyle = .split
        self.setup()
    }

    private weak var flowDelegate: HFlowViewDelegate?
    weak override var delegate: UICollectionViewDelegate? {
        get { return super.delegate }
        set { flowDelegate = newValue as? HFlowViewDelegate }
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
        switch flowAlign {
        case .default:
            self.contentInset = UIEdgeInsets.zero
        case .center:
            let originX = (self.width - cntSize.width) / 2
            let originY = (self.height - cntSize.height) / 2
            self.contentInset = UIEdgeInsets(top: max(originY, 0),
                                             left: max(originX, 0),
                                             bottom: cntInset.bottom,
                                             right: cntInset.right)
        case .top(let top):
            let originX = (self.width - cntSize.width) / 2
            self.contentInset = UIEdgeInsets(top: top,
                                             left: max(originX, 0),
                                             bottom: cntInset.bottom,
                                             right: cntInset.right)
        case .ratio(let ratio):
            let originX = (self.width - cntSize.width) / 2
            let originY = (self.height - cntSize.height) * ratio
            self.contentInset = UIEdgeInsets(top: max(originY, 0),
                                             left: max(originX, 0),
                                             bottom: cntInset.bottom,
                                             right: cntInset.right)
        case .bottom(let bottom):
            let originX = (self.width - cntSize.width) / 2
            let originY = self.height - cntSize.height - bottom
            self.contentInset = UIEdgeInsets(top: max(originY, 0),
                                             left: max(originX, 0),
                                             bottom: cntInset.bottom,
                                             right: cntInset.right)
        }
    }

    private func setup() {
        // Save flowView for global refresh
        HFlowAppearance.addFlow(self)

        // Set default tag
        self.tag = kFlowDefaultTag

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
    }

    /// Page number, Default 1
    var pageNo: Int = kFlowPageNo {
        didSet {
            if pageNo <= 0 {
                pageNo = kFlowPageNo
            }
        }
    }

    /// Page size, Default 20
    var pageSize: Int = kFlowPageSize {
        didSet {
            if pageSize <= 0 {
                pageSize = kFlowPageSize
            }
        }
    }

    /// Total number. Default 10000
    var totalNo: Int = kFlowTotalPageNo {
        didSet {
            if totalNo <= 0 {
                totalNo = kFlowTotalPageNo
            }
        }
    }

    /// Refresh header style
    var refreshHeaderStyle: HFlowRefreshHeaderStyle = .gray

    /// Load more footer style
    var refreshFooterStyle: HFlowRefreshFooterStyle = .style1

    /// Block to refresh data
    var refreshBlock: HFlowRefreshBlock? {
        didSet {
            if let refreshBlock = refreshBlock {
                self.mj_header = HFlowRefresh.refreshHeaderWithStyle(refreshHeaderStyle) { [weak self] in
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
    var loadMoreBlock: HFlowLoadMoreBlock? {
        didSet {
            if let loadMoreBlock = loadMoreBlock {
                self.pageNo = 1
                self.mj_footer = HFlowRefresh.refreshFooterWithStyle(refreshFooterStyle) { [weak self] in
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

    /// Set the key value for release
    var releaseFlowKey: String?

    /// Set the key value for reload
    var reloadFlowKey: String?

    /// Block refresh & loadMore
    func beginRefreshing(_ completion: @escaping () -> Void) {
        guard self.refreshBlock != nil else { return }
        self.pageNo = 1
        self.mj_header?.beginRefreshing(completionBlock: completion)
    }

    /// Stop refresh
    func endRefreshing(_ completion: @escaping () -> Void) {
        self.mj_header?.endRefreshing(completionBlock:completion)
    }

    func endLoadMore(_ completion: @escaping () -> Void) {
        self.mj_footer?.endRefreshing(completionBlock:completion)
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
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        self.scrollRectToVisible(rect, animated: animated)
    }

    /// Scroll to bottom
    func scrollsToBottom(_ animated: Bool) {
        let sections = self.numberOfSections
        let items = self.numberOfItems(inSection: sections - 1)
        let indexPath = IndexPath(row: items - 1, section: sections - 1)
        self.scrollToItem(at: indexPath, at: .bottom, animated: animated)
    }
    
    @objc
    func reloadFlowData() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }

    /// Release method
    @objc
    func releaseFlowBlock() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.releaseAllSignal()
            self?.clearFlowState()

            DispatchQueue.main.async { [weak self] in
                self?.flowDelegate = nil
                self?.refreshBlock = nil
                self?.loadMoreBlock = nil
            }
        }
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let outsideCntBlock = self.outsideCntBlock else { return true }
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
    
    private var addressValue: String {
        return String(format: "%p", self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// Register class
    func header(_ cls: AnyClass, _ pre: String?, _ idx: Bool, _ indexPath: IndexPath) -> AnyObject {
        // Unique identifier
        var identifier = (pre ?? "") + "HeaderCell" + NSStringFromClass(cls) + self.addressValue
        // Determine whether it contains an index
        identifier += idx ? indexPath.stringValue : ""
        // Determine if there is a flow state value
        if self.flowStyle == .split, !self.sectionPaths.contains(indexPath.section) {
            identifier += "\(self.flowState)"
        }
        // Register cell if not already registered
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as! HFlowBaseApex
        cell.indexPath = indexPath
        cell.isHeader = true
        cell.flow = self
        // Save cell
        self.allReuseHeaders.setObject(cell, forKey: IndexPath.nsStringValue(0, indexPath.section))
        return cell
    }

    func footer(_ cls: AnyClass, _ pre: String?, _ idx: Bool, _ indexPath: IndexPath) -> AnyObject {
        // Unique identifier
        var identifier = (pre ?? "") + "FooterCell" + NSStringFromClass(cls) + self.addressValue
        // Determine whether it contains an index
        identifier += idx ? indexPath.stringValue : ""
        // Determine if there is a flow state value
        if self.flowStyle == .split, !self.sectionPaths.contains(indexPath.section) {
            identifier += "\(self.flowState)"
        }
        // Register cell if not already registered
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath) as! HFlowBaseApex
        cell.indexPath = indexPath
        cell.isHeader = false
        cell.flow = self
        // Save cell
        self.allReuseFooters.setObject(cell, forKey: IndexPath.nsStringValue(0, indexPath.section))
        // Return cell
        return cell
    }
    
    func cell(_ cls: AnyClass, _ pre: String?, _ idx: Bool, _ indexPath: IndexPath) -> AnyObject {
        // Unique identifier
        var identifier = (pre ?? "") + "ItemCell" + NSStringFromClass(cls) + self.addressValue
        // Determine whether it contains an index
        identifier += idx ? indexPath.stringValue : ""
        // Determine if there is a flow state value
        if self.flowStyle == .split, !self.sectionPaths.contains(indexPath.section) {
            identifier += "\(self.flowState)"
        }
        // Register cell if not already registered
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forCellWithReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! HFlowBaseCell
        cell.indexPath = indexPath
        cell.flow = self
        // Save cell
        self.allReuseCells.setObject(cell, forKey: indexPath.nsStringValue)
        // Return cell
        return cell
    }

    /// UICollectionViewDatasource  & delegate
    private func scrollSplitPrefix() -> String {
        var prefix = ""
        if self.flowStyle == .split {
            if self.sectionPaths.contains(self.flowState) {
                prefix = kFlowDesignKey + "\(self.flowState)" + "_"
            }
        }
        return prefix
    }
    private func flowSplitPrefix(_ section: Int) -> String {
        var prefix = ""
        if self.flowStyle == .split {
            if self.sectionPaths.contains(section) {
                let idx = self.sectionPaths.index(of: section)
                prefix = kFlowExaDesignKey + "\(idx)" + "_"
            }else {
                prefix = kFlowDesignKey + "\(self.flowState)" + "_"
            }
        }
        return prefix
    }

    /// The following are UICollectionView delegate methods
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        // remove cache data
        self.allReuseIdentifiers.removeAllObjects()
        self.allSectionInsets.removeAllObjects()
        // flow Style
        var sections = 1
        switch self.flowStyle {
        case .default:
            if let delegate = self.flowDelegate {
                let prefix = ""
                let selector = #selector(delegate.numberOfSectionsInFlowView)
                if delegate.responds(to: selector, withPre: prefix) {
                    sections = delegate.performWithUnretainedValue(selector, withPre: prefix) as! Int
                }
                // Prevents quantity from being less than 1
                sections = max(sections, 1)
            }
        case .split:
            if let delegate = self.flowDelegate {
                let prefix = kFlowDesignKey + "\(self.flowState)" + "_"
                let selector = #selector(delegate.numberOfSectionsInFlowView)
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
        if let delegate = self.flowDelegate {
            // Get the number of items
            let prefix = self.flowSplitPrefix(section)
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

    /// layout == HFlowViewLayout
    internal func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, colorForSectionAt section: NSInteger) -> UIColor {
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(section)
            let selector = #selector(delegate.colorForSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! UIColor
            }
        }
        return UIColor.clear
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(section)
            let selector = #selector(delegate.minimumLineSpacingForSectionAt(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
            }
        }
        return 0.0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(section)
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
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(section)
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
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(section)
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

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Call delegate method
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(indexPath.section)
            let selector: Selector = #selector(delegate.flowItem(_:atIndexPath:))
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.performWithUnretainedValue(selector, with: self, with: indexPath, withPre: prefix)
            }
        }
        // Call cell
        return self.allReuseCells.object(forKey: indexPath.nsStringValue) as! HFlowBaseCell
    }

    internal func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var cell: HFlowBaseApex?
        if kind == UICollectionView.elementKindSectionHeader {
            // Call delegate method
            if let delegate = self.flowDelegate {
                let prefix = self.flowSplitPrefix(indexPath.section)
                let selector: Selector = #selector(delegate.minimumHeaderSpacingForSectionAt(_:))
                if delegate.responds(to: selector, withPre: prefix) {
                    // Unique identifier
                    let identifier = "HeaderSpaceCell" + self.addressValue + indexPath.stringValue + "\(self.flowState)"
                    // Register cell if not already registered
                    if !self.allReuseIdentifiers.contains(identifier) {
                        self.allReuseIdentifiers.add(identifier)
                        self.register(HFlowBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
                    }
                    // Dequeue cell
                    return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath)
                } else {
                    let selector: Selector = #selector(delegate.flowHeader(_:atIndexPath:))
                    if delegate.responds(to: selector, withPre: prefix) {
                        delegate.perform(selector, with: self, with: indexPath, withPre: prefix)
                    }
                }
            }
            // Call cell
            cell = self.allReuseHeaders.object(forKey: indexPath.nsStringValue) as? HFlowBaseApex
        }else if (kind == UICollectionView.elementKindSectionFooter) {
            // Call delegate method
            if let delegate = self.flowDelegate {
                let prefix = self.flowSplitPrefix(indexPath.section)
                let selector: Selector = #selector(delegate.minimumFooterSpacingForSectionAt(_:))
                if delegate.responds(to: selector, withPre: prefix) {
                    // Unique identifier
                    let identifier = "FooterSpaceCell" + self.addressValue + indexPath.stringValue + "\(self.flowState)"
                    // Register cell if not already registered
                    if !self.allReuseIdentifiers.contains(identifier) {
                        self.allReuseIdentifiers.add(identifier)
                        self.register(HFlowBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
                    }
                    // Dequeue cell
                    return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath)
                } else {
                    let selector: Selector = #selector(delegate.flowFooter(_:atIndexPath:))
                    if delegate.responds(to: selector, withPre: prefix) {
                        delegate.perform(selector, with: self, with: indexPath, withPre: prefix)
                    }
                }
            }
            // Call cell
            cell = self.allReuseFooters.object(forKey: indexPath.nsStringValue) as? HFlowBaseApex
        }
        return cell!
    }

    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HFlowBaseCell
        if let willDisplayBlock = cell?.willDisplayBlock {
            willDisplayBlock()
        }else if let delegate = self.flowDelegate, let cell = cell {
            let prefix = self.flowSplitPrefix(indexPath.section)
            let selector = #selector(delegate.willDisplayCell(_:atIndexPath:))
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: cell, with: indexPath, withPre: prefix)
            }
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HFlowBaseCell
        if let selectBlock = cell?.selectBlock {
            selectBlock()
        }else if let delegate = self.flowDelegate, let cell = cell {
            let prefix = self.flowSplitPrefix(indexPath.section)
            let selector = #selector(delegate.didSelectCell(_:atIndexPath:))
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: cell, with: indexPath, withPre: prefix)
            }
        }
    }

    /// UICollectionViewDelegate
    internal func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(indexPath.section)
            let selector = #selector(delegate.shouldHighlightItemAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return true
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.flowSplitPrefix(indexPath.section)
        let selector = #selector(delegate.didHighlightItemAtIndexPath(_:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: indexPath, withPre: prefix)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.flowSplitPrefix(indexPath.section)
        let selector = #selector(delegate.didUnhighlightItemAtIndexPath(_:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: indexPath, withPre: prefix)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(indexPath.section)
            let selector = #selector(delegate.shouldSelectItemAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return true
    }
    
    internal func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(indexPath.section)
            let selector = #selector(delegate.shouldDeselectItemAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return false
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.flowSplitPrefix(indexPath.section)
        let selector = #selector(delegate.didDeselectItemAtIndexPath(_:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: indexPath, withPre: prefix)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.flowSplitPrefix(indexPath.section)
        let selector = #selector(delegate.willDisplayElementKind(_:atIndexPath:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: elementKind, with: indexPath, withPre: prefix)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.flowSplitPrefix(indexPath.section)
        let selector = #selector(delegate.didEndDisplayingCell(_:forItemAtIndexPath:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: cell, with: indexPath, withPre: prefix)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.flowSplitPrefix(indexPath.section)
        let selector = #selector(delegate.didEndDisplayingElementOfKind(_:atIndexPath:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: elementKind, with: indexPath, withPre: prefix)
        }
    }

    /// UIScrollViewDelegate
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("flowViewDidScroll:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }
    
    internal func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("flowViewDidZoom:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("flowViewWillBeginDragging:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

    internal func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        //let selector = NSSelectorFromString("flowViewWillEndDragging:withVelocity:targetContentOffset:")
        let selector = NSSelectorFromString("flowViewWillEndDragging:targetContentOffset:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: velocity, with: targetContentOffset, withPre: prefix)
        }
    }

    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("flowViewDidEndDragging:willDecelerate:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, with: decelerate, withPre: prefix)
        }
    }

    internal func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("flowViewWillBeginDecelerating:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("flowViewDidEndDecelerating:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

    internal func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("flowViewDidEndScrollingAnimation:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if let delegate = self.flowDelegate {
            let prefix = self.scrollSplitPrefix()
            let selector = NSSelectorFromString("flowViewForZoomingInScrollView:")
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: scrollView, withPre: prefix) as? UIView
            }
        }
        return nil
    }
    
    internal func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("flowViewWillBeginZooming:withView:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, with: view as Any, withPre: prefix)
        }
    }
    
    internal func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("flowViewDidEndZooming:atScale:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: view as Any, with: scale, withPre: prefix)
        }
    }

    internal func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let delegate = self.flowDelegate {
            let prefix = self.scrollSplitPrefix()
            let selector = NSSelectorFromString("flowViewShouldScrollToTop:")
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: scrollView, withPre: prefix) as! Bool
            }
        }
        return true
    }
    
    internal func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("flowViewDidScrollToTop:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

    internal func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        guard let delegate = self.flowDelegate else { return }
        let prefix = self.scrollSplitPrefix()
        let selector = NSSelectorFromString("flowViewDidChangeAdjustedContentInset:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

}

/// Signal mechanism classification
extension HFlowView {

    /// The signal block held by flowView
    var signalBlock: HFlowCellSignalBlock? {
        get { return self.getAssociatedValueForKey(&kFlowSignalKey) as? HFlowCellSignalBlock }
        set { self.setAssociateCopyValue(newValue, key: &kFlowSignalKey) }
    }

    /// Send signal to flowView
    func signalToFlowView(_ signal: HFlowSignal?, _ completion: @escaping () -> Void) {
        guard let signalBlock = self.signalBlock else { return }
        signalBlock(self, signal)
        completion()
    }

    /// Send signals to all items, items under a certain section, or a single item individually
    func signalToAllItems(_ signal: HFlowSignal?, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let flows = self?.allReuseCells.objectEnumerator()?.allObjects.compactMap { $0 as? HFlowBaseCell }
            flows?.forEach { cell in
                DispatchQueue.main.async {
                    cell.signalBlock?(cell, signal)
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func signal(_ signal: HFlowSignal?, itemSection section: Int, _ completion: @escaping () -> Void) {
        let items = self.numberOfItems(inSection: section)
        DispatchQueue.global(qos: .userInteractive).async {
            let group = DispatchGroup()
            DispatchQueue.concurrentPerform(iterations: items) { [weak self] i in
                let cell = self?.allReuseCells.object(forKey: IndexPath.nsStringValue(i, section)) as? HFlowBaseCell
                if let cell = cell, let signalBlock = cell.signalBlock {
                    DispatchQueue.main.async(group: group) {
                        signalBlock(cell, signal)
                    }
                }
            }
            group.wait()
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func signal(_ signal: HFlowSignal?, toRow row: Int, inSection section: Int, _ completion: @escaping () -> Void) {
        let cell = self.allReuseCells.object(forKey: IndexPath.nsStringValue(row, section)) as? HFlowBaseCell
        if let cell = cell, let signalBlock = cell.signalBlock {
            signalBlock(cell, signal)
        }
        completion()
    }

    /// Send signals to all headers or a single header individually
    func signalToAllHeader(_ signal: HFlowSignal?, _ completion: @escaping () -> Void) {
        let sections = self.numberOfSections
        DispatchQueue.global(qos: .userInteractive).async {
            let group = DispatchGroup()
            DispatchQueue.concurrentPerform(iterations: sections) { [weak self] i in
                let header = self?.allReuseHeaders.object(forKey: IndexPath.nsStringValue(0, i)) as? HFlowBaseApex
                if let header = header, let signalBlock = header.signalBlock {
                    DispatchQueue.main.async(group: group) {
                        signalBlock(header, signal)
                    }
                }
            }
            group.wait()
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func signal(_ signal: HFlowSignal?, headerSection section: Int, _ completion: @escaping () -> Void) {
        let header = self.allReuseHeaders.object(forKey: IndexPath.nsStringValue(0, section)) as? HFlowBaseApex
        if let header = header, let signalBlock = header.signalBlock {
            signalBlock(header, signal)
        }
        completion()
    }

    /// Send signals to all footers or a single footer individually
    func signalToAllFooter(_ signal: HFlowSignal?, _ completion: @escaping () -> Void) {
        let sections = self.numberOfSections
        DispatchQueue.global(qos: .userInteractive).async {
            let group = DispatchGroup()
            DispatchQueue.concurrentPerform(iterations: sections) { [weak self] i in
                let footer = self?.allReuseFooters.object(forKey: IndexPath.nsStringValue(0, i)) as? HFlowBaseApex
                if let footer = footer, let signalBlock = footer.signalBlock {
                    DispatchQueue.main.async(group: group) {
                        signalBlock(footer, signal)
                    }
                }
            }
            group.wait()
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func signal(_ signal: HFlowSignal?, footerSection section: Int, _ completion: @escaping () -> Void) {
        let footer = self.allReuseFooters.object(forKey: IndexPath.nsStringValue(0, section)) as? HFlowBaseApex
        if let footer = footer, let signalBlock = footer.signalBlock {
            signalBlock(footer, signal)
        }
        completion()
    }

    /// Release all signal blocks
    func releaseAllSignal() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            self.signalBlock = nil
            //release all cell
            self.allReuseCells.objectEnumerator()?.allObjects.forEach {
                ($0 as? HFlowBaseCell)?.signalBlock = nil
                ($0 as? HFlowBaseCell)?.selectBlock = nil
                ($0 as? HFlowBaseCell)?.willDisplayBlock = nil
            }
            //release all header
            self.allReuseHeaders.objectEnumerator()?.allObjects.forEach {
                ($0 as? HFlowBaseApex)?.signalBlock = nil
            }
            //release all footer
            self.allReuseFooters.objectEnumerator()?.allObjects.forEach {
                ($0 as? HFlowBaseApex)?.signalBlock = nil
            }
        }
    }

    /// Get cell based on the given row and section
    func cell(_ row: Int, _ section: Int) -> AnyObject? {
        return self.allReuseCells.object(forKey: IndexPath.nsStringValue(row, section))
    }

    /// Get the width, height, and size of a certain section
    func width(forSection section: Int) -> CGFloat {
        var width: CGFloat = self.width
        let edgeInsetsString = self.allSectionInsets.object(forKey: "\(section)" as NSString) as? String
        if let edgeInsetsString = edgeInsetsString, !edgeInsetsString.isEmpty {
            let edgeInsets = UIEdgeInsetsFromString(edgeInsetsString)
            width -= edgeInsets.left + edgeInsets.right
            width = max(width, 0) // Ensure width is not less than 0
        }
        return width
    }

    func heigh(forSection section: Int) -> CGFloat {
        var height: CGFloat = self.height
        let edgeInsetsString = self.allSectionInsets.object(forKey: "\(section)" as NSString) as? String
        if let edgeInsetsString = edgeInsetsString, !edgeInsetsString.isEmpty {
            let edgeInsets = UIEdgeInsetsFromString(edgeInsetsString)
            height -= edgeInsets.top + edgeInsets.bottom
            height = max(height, 0) // Ensure width is not less than 0
        }
        return height
    }

    func size(forSection section: Int) -> CGSize {
        var size: CGSize = self.size
        let edgeInsetsString = self.allSectionInsets.object(forKey: "\(section)" as NSString) as? String
        if let edgeInsetsString = edgeInsetsString, !edgeInsetsString.isEmpty {
            let edgeInsets = UIEdgeInsetsFromString(edgeInsetsString)
            size.width -= edgeInsets.left + edgeInsets.right
            size.height -= edgeInsets.top + edgeInsets.bottom
            size.width = max(size.width, 0) // Ensure that the width is not less than 0
            size.height = max(size.height, 0) // Ensure that the height is not less than 0
        }
        return size
    }

    /// Calculate the width of the item based on the number and index passed in
    func fixSlit(withWidth width: CGFloat, colCount: Int, index: Int) -> CGFloat {
        let itemWidth: CGFloat = width / CGFloat(colCount)
        let realItemWidth: CGFloat = itemWidth.rounded(.down)
        if index == colCount - 1 {
            return width - realItemWidth * CGFloat(index)
        }
        return realItemWidth
    }

}

private var Flow_State_Key = "_flow_"

/// Design data storage category for split
extension HFlowView {

    private var flowStateSource: NSMutableDictionary {
        get {
            if let dict = self.getAssociatedValueForKey(&kFlowStateSourceKey) as? NSMutableDictionary {
                return dict
            } else {
                let dict = NSMutableDictionary()
                self.setAssociateValue(dict, key: &kFlowStateSourceKey)
                return dict
            }
        }
    }

    /// The state represented by the flowView split design
    var flowState: Int {
        get {
            let value = self.getAssociatedValueForKey(&kFlowStateKey) as? NSNumber ?? NSNumber(value: 0)
            return value.intValue
        }
        set {
            if newValue != self.flowState {
                self.setAssociateValue(NSNumber(value: newValue), key: &kFlowStateKey)
                self.reloadData()
            }
        }
    }

    /// Add a value to a certain state
    func setObject(_ anObject: Any, forKey aKey: String, state: Int) {
        let key = aKey + Flow_State_Key + "\(state)"
        self.flowStateSource.setObject(anObject, forKey: key as NSCopying)
    }

    /// Get a value of a certain state
    func object(forKey aKey: String, state: Int) -> Any? {
        let key = aKey + Flow_State_Key + "\(state)"
        return self.flowStateSource.object(forKey: key)
    }

    /// Remove a value in a certain state
    func removeObject(forKey aKey: String, state: Int) {
        let key = aKey + Flow_State_Key + "\(state)"
        self.flowStateSource.removeObject(forKey: key)
    }

    /// Delete the value of a certain state
    func removeObject(forState state: Int) {
        let key = Flow_State_Key + "\(state)"
        for (aKey, _) in self.flowStateSource.reversed() {
            let aKey = aKey as! String
            if key == aKey {
                self.flowStateSource.removeObject(forKey: aKey)
            }
        }
    }

    /// Remove all values ​​of the state
    func clearFlowState() {
        self.flowStateSource.removeAllObjects()
    }

}
