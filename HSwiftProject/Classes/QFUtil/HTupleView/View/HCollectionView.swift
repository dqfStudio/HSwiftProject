//
//  HCollectionView.swift
//  HSwiftProject
//
//  Created by owner on 2025/6/29.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit
import Combine
import Kingfisher
import SDWebImage

@objc protocol HCollectionViewDelegate: UICollectionViewDelegate {
    @objc
    optional func numberOfSectionsInCollView() -> Any
    @objc
    optional func numberOfItemsInSection(_ section: Any) -> Any
    /// layout == HCollectionViewFlowLayout
    @objc
    optional func numberOfColumnsInSection(_ section: Any) -> Any

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
    optional func collHeader(_ coll: HCollectionView, atIndexPath indexPath: IndexPath)
    @objc
    optional func collFooter(_ coll: HCollectionView, atIndexPath indexPath: IndexPath)
    @objc
    optional func collItem(_ coll: HCollectionView, atIndexPath indexPath: IndexPath)

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

class HCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    private var flowLayout: UICollectionViewFlowLayout?

    private var allReuseIdentifiers = NSMutableSet()
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
        self.init(frame: frame, collectionViewLayout: HCollectionViewLayout(.vertical))
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        flowLayout = layout as? UICollectionViewFlowLayout
        self.setup()
    }
    
    static func collFrame(_ frame: () -> CGRect, layout: () -> UICollectionViewFlowLayout) -> HCollectionView {
        return HCollectionView(frame(), layout: layout())
    }

    private convenience init(_ frame: CGRect, layout: UICollectionViewFlowLayout) {
        self.init(frame: UIRectIntegral(frame), collectionViewLayout: layout)
    }

    private weak var collDelegate: HCollectionViewDelegate?
    weak override var delegate: UICollectionViewDelegate? {
        get { return super.delegate }
        set { collDelegate = newValue as? HCollectionViewDelegate }
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

    private func setup() {
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
    
    @objc
    func reloadCollData() {
        DispatchQueue.mainAsync { [weak self] in
            self?.reloadData()
        }
    }

    /// Release method
    @objc
    func releaseCollBlock() {
        DispatchQueue.main.async { [weak self] in
            self?.collDelegate = nil
            self?.loadMoreBlock = nil
            self?.refreshBlock = nil
            self?.dataSource = nil
            self?.delegate = nil
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        self.removeFromSuperview()
        self.collDelegate = nil
        self.dataSource = nil
        self.delegate = nil
    }

    /// Register class
    @discardableResult
    func reuseHeader(_ cls: AnyClass, _ idx: Bool, _ indexPath: IndexPath) -> AnyObject {
        // Unique identifier
        var identifier = NSStringFromClass(cls)
        // Determine whether it contains an index
        identifier += idx ? indexPath.stringValue : ""
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
        // Return cell
        return cell
    }

    @discardableResult
    func reuseFooter(_ cls: AnyClass, _ idx: Bool, _ indexPath: IndexPath) -> AnyObject {
        // Unique identifier
        var identifier = NSStringFromClass(cls)
        // Determine whether it contains an index
        identifier += idx ? indexPath.stringValue : ""
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
        // Return cell
        return cell
    }
    
    @discardableResult
    func reuseCell(_ cls: AnyClass, _ idx: Bool, _ indexPath: IndexPath) -> AnyObject {
        // Unique identifier
        var identifier = NSStringFromClass(cls)
        // Determine whether it contains an index
        identifier += idx ? indexPath.stringValue : ""
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
        // Return cell
        return cell
    }

    /// The following are UICollectionView delegate methods
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        // remove cache data
        self.allReuseIdentifiers.removeAllObjects()
        // coll Style
        var sections = 1
        if let delegate = self.collDelegate {
            let selector = #selector(delegate.numberOfSectionsInCollView)
            if delegate.responds(to: selector) {
                sections = delegate.performWithUnretainedValue(selector) as! Int
            }
            // Prevents quantity from being less than 1
            sections = max(sections, 1)
        }
        return sections
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items = 0
        if let delegate = self.collDelegate {
            // Get the number of items
            let itemSelector: Selector = #selector(delegate.numberOfItemsInSection(_:))
            if delegate.responds(to: itemSelector) {
                items = delegate.performWithUnretainedValue(itemSelector, with: section) as! Int
            }
            // Prevents quantity from being less than 0
            items = max(items, 0)
        }
        return items
    }
    
    /// layout == HCollectionViewFlowLayout
    internal func collectionView(_ collectionView: UICollectionView, numberOfColumnsInSection section: Int) -> Int {
        var items = 2
        if let delegate = self.collDelegate {
            // Get the number of items
            let itemSelector: Selector = #selector(delegate.numberOfColumnsInSection(_:))
            if delegate.responds(to: itemSelector) {
                items = delegate.performWithUnretainedValue(itemSelector, with: section) as! Int
            }
            // Prevents quantity from being less than 0
            items = max(items, 2)
        }
        return items
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let delegate = self.collDelegate {
            let selector = #selector(delegate.minimumLineSpacingForSectionAt(_:))
            if delegate.responds(to: selector) {
                return delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
            }
        }
        return 0.0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let delegate = self.collDelegate {
            let selector = #selector(delegate.minimumInteritemSpacingForSectionAt(_:))
            if delegate.responds(to: selector) {
                return delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
            }
        }
        return 0.0
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Get the edgeInsets of the section
        var edgeInsets: UIEdgeInsets = .zero
        if let delegate = self.collDelegate {
            let insetSelector = #selector(delegate.insetForSection(_:))
            if delegate.responds(to: insetSelector) {
                edgeInsets = delegate.performWithUnretainedValue(insetSelector, with: section) as! UIEdgeInsets
            }
        }
        return edgeInsets
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size = CGSize.zero
        if let delegate = self.collDelegate {
            let selector: Selector = #selector(delegate.minimumHeaderSpacingForSectionAt(_:))
            if delegate.responds(to: selector) {
                let spacing: CGFloat = delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
                if self.flowLayout?.scrollDirection == .vertical {
                    size = CGSize(width: self.width, height: spacing)
                }else {
                    size = CGSize(width: spacing, height: self.height)
                }
            } else {
                let selector = #selector(delegate.sizeForHeaderInSection(_:))
                if delegate.responds(to: selector) {
                    size = delegate.performWithUnretainedValue(selector, with: section) as! CGSize
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
            let selector: Selector = #selector(delegate.minimumFooterSpacingForSectionAt(_:))
            if delegate.responds(to: selector) {
                let spacing: CGFloat = delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
                if self.flowLayout?.scrollDirection == .vertical {
                    size = CGSize(width: self.width, height: spacing)
                }else {
                    size = CGSize(width: spacing, height: self.height)
                }
            } else {
                let selector = #selector(delegate.sizeForFooterInSection(_:))
                if delegate.responds(to: selector) {
                    size = delegate.performWithUnretainedValue(selector, with: section) as! CGSize
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
            let selector = #selector(delegate.sizeForItemAtIndexPath(_:))
            if delegate.responds(to: selector) {
                size = delegate.performWithUnretainedValue(selector, with: indexPath) as! CGSize
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
            let selector: Selector = #selector(delegate.collItem(_:atIndexPath:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: self, with: indexPath)
            }
        }
        // Call cell
        if let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HCollBaseCell {
            // Update passed cells
            if self.allPassedCells.count > 20 {
                self.allPassedCells.removeAllObjects()
                SDImageCache.shared.clearMemory()
                SDImageCache.shared.clearDisk(onCompletion: {})
                KingfisherManager.shared.cache.clearMemoryCache()
            }
            return cell
        }
        self.register(HCollBaseCell.self, forCellWithReuseIdentifier: HCollBaseCell.className)
        return self.dequeueReusableCell(withReuseIdentifier: HCollBaseCell.className, for: indexPath)
    }

    internal func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            // Call delegate method
            if let delegate = self.collDelegate {
                let selector: Selector = #selector(delegate.minimumHeaderSpacingForSectionAt(_:))
                if delegate.responds(to: selector) {
                    // Unique identifier
                    let identifier = "HeaderSpaceCell" + indexPath.stringValue
                    // Register cell if not already registered
                    if !self.allReuseIdentifiers.contains(identifier) {
                        self.allReuseIdentifiers.add(identifier)
                        self.register(HCollBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
                    }
                    // Dequeue cell
                    return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath)
                } else {
                    let selector: Selector = #selector(delegate.collHeader(_:atIndexPath:))
                    if delegate.responds(to: selector) {
                        delegate.perform(selector, with: self, with: indexPath)
                    }
                }
            }
            // Call cell
            if let cell = self.allReuseHeaders.object(forKey: indexPath.nsStringValue) as? HCollBaseApex {
                return cell
            }
            self.register(HCollBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HCollBaseApex.className)
            return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HCollBaseApex.className, for: indexPath)
        }else {
            // Call delegate method
            if let delegate = self.collDelegate {
                let selector: Selector = #selector(delegate.minimumFooterSpacingForSectionAt(_:))
                if delegate.responds(to: selector) {
                    // Unique identifier
                    let identifier = "FooterSpaceCell" + indexPath.stringValue
                    // Register cell if not already registered
                    if !self.allReuseIdentifiers.contains(identifier) {
                        self.allReuseIdentifiers.add(identifier)
                        self.register(HCollBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
                    }
                    // Dequeue cell
                    return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath)
                } else {
                    let selector: Selector = #selector(delegate.collFooter(_:atIndexPath:))
                    if delegate.responds(to: selector) {
                        delegate.perform(selector, with: self, with: indexPath)
                    }
                }
            }
            // Call cell
            if let cell = self.allReuseFooters.object(forKey: indexPath.nsStringValue) as? HCollBaseApex {
                return cell
            }
            self.register(HCollBaseApex.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HCollBaseApex.className)
            return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HCollBaseApex.className, for: indexPath)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HCollBaseCell
        if let delegate = self.collDelegate, let cell = cell {
            let selector = #selector(delegate.willDisplayCell(_:atIndexPath:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: cell, with: indexPath)
            }
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HCollBaseCell
        if let delegate = self.collDelegate, let cell = cell {
            let selector = #selector(delegate.didSelectCell(_:atIndexPath:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: cell, with: indexPath)
            }
        }
    }

    /// UICollectionViewDelegate
    internal func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        if let delegate = self.collDelegate {
            let selector = #selector(delegate.shouldHighlightItemAtIndexPath(_:))
            if delegate.responds(to: selector) {
                return delegate.performWithUnretainedValue(selector, with: indexPath) as! Bool
            }
        }
        return true
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let delegate = self.collDelegate else { return }
        let selector = #selector(delegate.didHighlightItemAtIndexPath(_:))
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: indexPath)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let delegate = self.collDelegate else { return }
        let selector = #selector(delegate.didUnhighlightItemAtIndexPath(_:))
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: indexPath)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let delegate = self.collDelegate {
            let selector = #selector(delegate.shouldSelectItemAtIndexPath(_:))
            if delegate.responds(to: selector) {
                return delegate.performWithUnretainedValue(selector, with: indexPath) as! Bool
            }
        }
        return true
    }
    
    internal func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if let delegate = self.collDelegate {
            let selector = #selector(delegate.shouldDeselectItemAtIndexPath(_:))
            if delegate.responds(to: selector) {
                return delegate.performWithUnretainedValue(selector, with: indexPath) as! Bool
            }
        }
        return false
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let delegate = self.collDelegate else { return }
        let selector = #selector(delegate.didDeselectItemAtIndexPath(_:))
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: indexPath)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let delegate = self.collDelegate else { return }
        let selector = #selector(delegate.willDisplayElementKind(_:atIndexPath:))
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: elementKind, with: indexPath)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let delegate = self.collDelegate else { return }
        let selector = #selector(delegate.didEndDisplayingCell(_:forItemAtIndexPath:))
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: cell, with: indexPath)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        guard let delegate = self.collDelegate else { return }
        let selector = #selector(delegate.didEndDisplayingElementOfKind(_:atIndexPath:))
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: elementKind, with: indexPath)
        }
    }

    /// UIScrollViewDelegate
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let delegate = self.collDelegate else { return }
        let selector = NSSelectorFromString("collViewDidScroll:")
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: scrollView)
        }
    }
    
    internal func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let delegate = self.collDelegate else { return }
        let selector = NSSelectorFromString("collViewDidZoom:")
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: scrollView)
        }
    }

    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let delegate = self.collDelegate else { return }
        let selector = NSSelectorFromString("collViewWillBeginDragging:")
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: scrollView)
        }
    }

    internal func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let delegate = self.collDelegate else { return }
        let selector = NSSelectorFromString("collViewWillEndDragging:targetContentOffset:")
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: velocity, with: targetContentOffset)
        }
    }

    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let delegate = self.collDelegate else { return }
        let selector = NSSelectorFromString("collViewDidEndDragging:willDecelerate:")
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: scrollView, with: decelerate)
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
        let selector = NSSelectorFromString("collViewWillBeginDecelerating:")
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: scrollView)
        }
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let delegate = self.collDelegate else { return }
        let selector = NSSelectorFromString("collViewDidEndDecelerating:")
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: scrollView)
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
        let selector = NSSelectorFromString("collViewDidEndScrollingAnimation:")
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: scrollView)
        }
    }

    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if let delegate = self.collDelegate {
            let selector = NSSelectorFromString("collViewForZoomingInScrollView:")
            if delegate.responds(to: selector) {
                return delegate.performWithUnretainedValue(selector, with: scrollView) as? UIView
            }
        }
        return nil
    }
    
    internal func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        guard let delegate = self.collDelegate else { return }
        let selector = NSSelectorFromString("collViewWillBeginZooming:withView:")
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: scrollView, with: view as Any)
        }
    }
    
    internal func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        guard let delegate = self.collDelegate else { return }
        let selector = NSSelectorFromString("collViewDidEndZooming:atScale:")
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: view as Any, with: scale)
        }
    }

    internal func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let delegate = self.collDelegate {
            let selector = NSSelectorFromString("collViewShouldScrollToTop:")
            if delegate.responds(to: selector) {
                return delegate.performWithUnretainedValue(selector, with: scrollView) as! Bool
            }
        }
        return true
    }
    
    internal func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        guard let delegate = self.collDelegate else { return }
        let selector = NSSelectorFromString("collViewDidScrollToTop:")
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: scrollView)
        }
    }

    internal func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        guard let delegate = self.collDelegate else { return }
        let selector = NSSelectorFromString("collViewDidChangeAdjustedContentInset:")
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: scrollView)
        }
    }

}
