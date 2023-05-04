//
//  HTupleView.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

enum HTupleDirection: Int {
    case vertical = 0
    case horizontal = 1
}

private enum HTupleStyle: Int {
    case `default`  //Singleton design
    case split //Split design
}

private var KTupleDefaultTag = 1213141516

private var KTuplePageNo = 1
private var KTuplePageSize = 20
private var KTupleTotalPageNo = 10000

private var KTupleDesignKey = "tuple"
private var KTupleExaDesignKey = "tupleExa"

private var KTupleStateKey = "tupleStateKey"
private var KTupleSignalKey = "tupleSignalKey"
private var KTupleStateSourceKey = "tupleStateSourceKey"

private var UICollectionElementKindSectionHeader = "UICollectionElementKindSectionHeader"
private var UICollectionElementKindSectionFooter = "UICollectionElementKindSectionFooter"

/// Refresh & LoadMore block
typealias HTupleRefreshBlock = () -> Void
typealias HTupleLoadMoreBlock = () -> Void

/// Tuple header & Footer & Item block
typealias HTupleHeader = (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject
typealias HTupleFooter = (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject
typealias HTupleItem = (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject

/// Split design exclusive sections block
typealias HTupleSectionExclusiveBlock = () -> NSArray

/// This class is used for refreshing tupleView throughout the project.
class HTupleAppearance : NSObject {
    
    private static var hashTuples = NSHashTable<AnyObject>.weakObjects()
    
    static func addTuple(_ anTuple: AnyObject) {
        self.hashTuples.add(anTuple)
    }
    static func refreshTuples(_ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Execute in reverse order
            let tuples = self.hashTuples.allObjects.reversed().compactMap { $0 as? HTupleView }
            tuples.forEach { $0.reloadTupleData() }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    static func refreshTuples(key: String, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Execute in reverse order
            let tuples = self.hashTuples.allObjects.reversed().compactMap { $0 as? HTupleView }
            tuples.filter { $0.reloadTupleKey == key }.forEach { $0.reloadTupleData() }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    static func releaseTuples(key: String, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Execute in reverse order
            let tuples = self.hashTuples.allObjects.reversed().compactMap { $0 as? HTupleView }
            tuples.filter { $0.releaseTupleKey == key }.forEach { $0.releaseTupleBlock() }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

@objc protocol HTupleViewDelegate : UICollectionViewDelegate {
    @objc
    optional func numberOfSectionsInTupleView() -> Any
    @objc
    optional func numberOfItemsInSection(_ section: Any) -> Any
    /// layout == HCollectionViewFlowLayout
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
    optional func insetForSection(_ section: Any) -> Any

    @objc
    optional func tupleHeader(_ headerBlock: Any, inSection section: Any)
    @objc
    optional func tupleFooter(_ footerBlock: Any, inSection section: Any)
    @objc
    optional func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath)

    @objc
    optional func willDisplayCell(_ cell: UICollectionViewCell, atIndexPath indexPath: IndexPath)
    @objc
    optional func didSelectItemAtIndexPath(_ indexPath: IndexPath)

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
    optional func didEndDisplayingCell(_ cell: HTupleBaseCell, forItemAtIndexPath indexPath: IndexPath)
    @objc
    optional func didEndDisplayingElementOfKind(_ elementKind: String, atIndexPath indexPath: IndexPath)

    /// UIScrollViewDelegate
    @objc
    optional func tupleViewDidScroll(_ scrollView: UIScrollView)
    @objc
    optional func tupleViewDidZoom(_ scrollView: UIScrollView)
    
    @objc
    optional func tupleViewWillBeginDragging(_ scrollView: UIScrollView)
    
    @objc
    optional func tupleViewWillEndDragging(_ velocity: CGPoint, targetContentOffset: CGPoint)
    
    @objc
    optional func tupleViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    
    @objc
    optional func tupleViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @objc
    optional func tupleViewDidEndDecelerating(_ scrollView: UIScrollView)
    
    @objc
    optional func tupleViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    
    @objc
    optional func tupleViewForZoomingInScrollView(_ scrollView: UIScrollView) -> UIView?
    @objc
    optional func tupleViewWillBeginZooming(_ scrollView: UIScrollView, withView view: UIView?)
    @objc
    optional func tupleViewDidEndZooming(_ view: UIView?, atScale scale: CGFloat)
    
    @objc
    optional func tupleViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool
    @objc
    optional func tupleViewDidScrollToTop(_ scrollView: UIScrollView)
    
    @objc
    optional func tupleViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)
}

class HTupleView : UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, HCollectionViewDelegateFlowLayout {

    private var flowLayout: UICollectionViewFlowLayout?

    private var tupleStyle: HTupleStyle = .default

    private var allReuseIdentifiers: NSMutableSet = NSMutableSet()
    private var allSectionInsets = NSMapTable<NSString, AnyObject>.strongToStrongObjects()
    private var allReuseCells   = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    private var allReuseHeaders = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    private var allReuseFooters = NSMapTable<NSString, AnyObject>.strongToWeakObjects()

    private var sectionPaths: NSArray?
    
    /// Default layout is HCollectionViewFlowLayout
    /// Default scrolling direction is vertical
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    convenience init(frame: CGRect) {
        self.init(frame: frame, scrollDirection: .vertical)
    }

    convenience init(frame: CGRect, scrollDirection direction: HTupleDirection) {
        self.init(frame: frame, collectionViewLayout: HCollectionViewFlowLayout(direction))
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        flowLayout = layout as? UICollectionViewFlowLayout
        self.setup()
    }
    
    /// Initialization method for split
    static func tupleFrame(_ frame: () -> CGRect, exclusiveSections sections: HTupleSectionExclusiveBlock) -> HTupleView {
        return HTupleView(frame(), exclusiveSections: sections())
    }
    
    private convenience init(_ frame: CGRect, exclusiveSections sectionPaths: NSArray) {
        self.init(frame: UIRectIntegral(frame), collectionViewLayout: HCollectionViewFlowLayout(.vertical))
        self.tupleStyle = .split
        self.sectionPaths = sectionPaths
        self.setup()
    }
    
    private weak var tupleDelegate: HTupleViewDelegate?
    weak override var delegate: UICollectionViewDelegate? {
        get { return super.delegate }
        set { tupleDelegate = newValue as? HTupleViewDelegate }
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
        // Save tupleView for global refresh
        HTupleAppearance.addTuple(self)
        
        // Set default tag
        self.tag = KTupleDefaultTag
        
        if self.flowLayout?.scrollDirection == .vertical {
            self.enableVerticalBounce()
        }else {
            self.enableHorizontalBounce()
        }
        self.backgroundColor = UIColor.clear
        self.keyboardDismissMode = .onDrag
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false

        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        super.delegate = self
        super.dataSource = self
    }

    /// Page number, Default 1
    var pageNo: Int = KTuplePageNo {
        didSet {
            if pageNo <= 0 {
                pageNo = KTuplePageNo
            }
        }
    }
    
    /// Page size, Default 20
    var pageSize: Int = KTuplePageSize {
        didSet {
            if pageSize <= 0 {
                pageSize = KTuplePageSize
            }
        }
    }
    
    /// Total number. Default 10000
    var totalNo: Int = KTupleTotalPageNo {
        didSet {
            if totalNo <= 0 {
                totalNo = KTupleTotalPageNo
            }
        }
    }
    
    /// Refresh header style
    var refreshHeaderStyle: HTupleRefreshHeaderStyle = .gray
    
    /// Load more footer style
    var refreshFooterStyle: HTupleRefreshFooterStyle = .style1
    
    /// Block to refresh data
    var refreshBlock: HTupleRefreshBlock? {
        didSet {
            if let refreshBlock = refreshBlock {
                self.mj_header = HTupleRefresh.refreshHeaderWithStyle(refreshHeaderStyle) {
                    self.pageNo = 1
                    refreshBlock()
                }
            } else {
                self.mj_header = nil
            }
        }
    }

    /// Block to load more data
    var loadMoreBlock: HTupleLoadMoreBlock? {
        didSet {
            if let loadMoreBlock = loadMoreBlock {
                self.pageNo = 1
                self.mj_footer = HTupleRefresh.refreshFooterWithStyle(refreshFooterStyle) { [weak self] in
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
    var releaseTupleKey: String?

    /// Set the key value for reload
    var reloadTupleKey: String?

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

    @objc
    func reloadTupleData() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }

    /// Release method
    @objc
    func releaseTupleBlock() {
        DispatchQueue.global().async {
            self.releaseAllSignal()
            self.clearTupleState()

            self.tupleDelegate = nil
            self.refreshBlock = nil
            self.loadMoreBlock = nil
        }
    }

    private var addressValue: String {
        return String(format: "%p", self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// Register class
    func dequeueReusableHeaderWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, idxPath: IndexPath) -> AnyObject {
        var cell: HTupleBaseApex
        // Unique identifier
        var identifier = (pre ?? "") + "HeaderCell" + NSStringFromClass(cls) + self.addressValue
        // Determine whether it contains an index
        identifier += idx ? idxPath.stringValue : ""
        // Determine if there is a tuple state value
        if self.tupleStyle == .split, let sectionPaths = self.sectionPaths, !sectionPaths.contains(idxPath.section) {
            identifier += "\(self.tupleState)"
        }
        // Determine whether it has been loaded
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
            cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseApex
            cell.tuple = self
            cell.indexPath = idxPath
            cell.isHeader = true
            //init method
            if let iblk = iblk as? HTupleCellInitBlock {
                iblk(cell)
            }
        }else {
            cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseApex
        }
        // Save cell
        self.allReuseHeaders.setObject(cell, forKey: idxPath.nsStringValue)
        // Call delegate method
        if let delegate = self.tupleDelegate {
            let prefix = self.prefixWithSection(idxPath.section)
            let selector: Selector = #selector(delegate.edgeInsetsForHeaderInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                let edgeInsets = delegate.performWithUnretainedValue(selector, with: idxPath.section, withPre: prefix) as! UIEdgeInsets
                // Set properties
                if edgeInsets != .zero, cell.responds(to: #selector(setter: cell.edgeInsets)) {
                    cell.edgeInsets = edgeInsets
                }
            }
        }
        return cell
    }
    
    func dequeueReusableFooterWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, idxPath: IndexPath) -> AnyObject {
        var cell: HTupleBaseApex
        // Unique identifier
        var identifier = (pre ?? "") + "FooterCell" + NSStringFromClass(cls) + self.addressValue
        // Determine whether it contains an index
        identifier += idx ? idxPath.stringValue : ""
        // Determine if there is a tuple state value
        if self.tupleStyle == .split, let sectionPaths = self.sectionPaths, !sectionPaths.contains(idxPath.section) {
            identifier += "\(self.tupleState)"
        }
        // Determine whether it has been loaded
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier)
            cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseApex
            cell.tuple = self
            cell.indexPath = idxPath
            cell.isHeader = true
            //init method
            if let iblk = iblk as? HTupleCellInitBlock {
                iblk(cell)
            }
        }else {
            cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseApex
        }
        // Save cell
        self.allReuseFooters.setObject(cell, forKey: idxPath.nsStringValue)
        // Call delegate method
        if let delegate = self.tupleDelegate {
            let prefix = self.prefixWithSection(idxPath.section)
            let selector = #selector(delegate.edgeInsetsForFooterInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                let edgeInsets = delegate.performWithUnretainedValue(selector, with: idxPath.section, withPre: prefix) as! UIEdgeInsets
                // Set properties
                if edgeInsets != .zero, cell.responds(to: #selector(setter: cell.edgeInsets)) {
                    cell.edgeInsets = edgeInsets
                }
            }
        }
        return cell
    }

    func dequeueReusableCellWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, idxPath: IndexPath) -> AnyObject {
        var cell: HTupleBaseCell
        // Unique identifier
        var identifier = (pre ?? "") + "ItemCell" + NSStringFromClass(cls) + self.addressValue
        // Determine whether it contains an index
        identifier += idx ? idxPath.stringValue : ""
        // Determine if there is a tuple state value
        if self.tupleStyle == .split, let sectionPaths = self.sectionPaths, !sectionPaths.contains(idxPath.section) {
            identifier += "\(self.tupleState)"
        }
        // Determine whether it has been loaded
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forCellWithReuseIdentifier: identifier)
            cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseCell
            cell.tuple = self
            cell.indexPath = idxPath
            //init method
            if let iblk = iblk as? HTupleCellInitBlock {
                iblk(cell)
            }
        }else {
            cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseCell
        }
        // Save cell
        self.allReuseCells.setObject(cell, forKey: idxPath.nsStringValue)
        // Call delegate method
        if let delegate = self.tupleDelegate {
            let prefix = self.prefixWithSection(idxPath.section)
            let selector = #selector(delegate.edgeInsetsForItemAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                let edgeInsets = delegate.performWithUnretainedValue(selector, with: idxPath, withPre: prefix) as! UIEdgeInsets
                // Set properties
                if edgeInsets != .zero, cell.responds(to: #selector(setter: cell.edgeInsets)) {
                    cell.edgeInsets = edgeInsets
                }
            }
        }
        return cell
    }
    
    /// UICollectionViewDatasource  & delegate
    private func tuplePrefix() -> String {
        var prefix = ""
        if self.tupleStyle == .split {
            prefix = KTupleDesignKey + "\(self.tupleState)" + "_"
        }
        return prefix
    }
    private func tupleScrollSplitPrefix() -> String {
        var prefix = ""
        if self.tupleStyle == .split {
            if let sectionPaths = self.sectionPaths, sectionPaths.contains(self.tupleState) {
                prefix = KTupleDesignKey + "\(self.tupleState)" + "_"
            }
        }
        return prefix
    }
    private func prefixWithSection(_ section: Int) -> String {
        var prefix = ""
        if self.tupleStyle == .split {
            if let sectionPaths = self.sectionPaths, sectionPaths.contains(section) {
                let idx: Int = sectionPaths.index(of: section)
                prefix = KTupleExaDesignKey + "\(idx)" + "_"
            }else {
                prefix = KTupleDesignKey + "\(self.tupleState)" + "_"
            }
        }
        return prefix
    }
    
    /// The following are UICollectionView delegate methods
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.allSectionInsets.count > 0 {
            self.allSectionInsets.removeAllObjects()
        }
        switch self.tupleStyle {
        case .default:
            var sections = 1
            if let delegate = self.tupleDelegate {
                let prefix = ""
                let selector = #selector(delegate.numberOfSectionsInTupleView)
                if delegate.responds(to: selector, withPre: prefix) {
                    sections = delegate.performWithUnretainedValue(selector, withPre: prefix) as! Int
                }
                // Prevents quantity from being less than 1
                sections = max(sections, 1)
            }
            return sections
        case .split:
            var sections = 1
            if let delegate = self.tupleDelegate {
                let prefix = KTupleDesignKey + "\(self.tupleState)" + "_"
                let selector = #selector(delegate.numberOfSectionsInTupleView)
                if delegate.responds(to: selector, withPre: prefix) {
                    sections = delegate.performWithUnretainedValue(selector, withPre: prefix) as! Int
                }
                // Prevents quantity from being less than 1
                sections = max(sections, 1)
            }
            return sections
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items = 0
        if let delegate = self.tupleDelegate {
            let prefix = self.prefixWithSection(section)
            let selector: Selector = #selector(delegate.numberOfItemsInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                items = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! Int
            }
            let edgeInsets = self.collectionView(self, layout: self.flowLayout!, insetForSectionAt: section)
            self.allSectionInsets.setObject(NSStringFromUIEdgeInsets(edgeInsets) as AnyObject, forKey: "\(section)" as NSString)
            // Prevents quantity from being less than 0
            items = max(items, 0)
        }
        return items
    }

    /// layout == HCollectionViewFlowLayout
    internal func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, colorForSectionAt section: NSInteger) -> UIColor {
        if let delegate = self.tupleDelegate {
            let prefix = self.prefixWithSection(section)
            let selector = #selector(delegate.colorForSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! UIColor
            }
        }
        return UIColor.clear
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let delegate = self.tupleDelegate {
            let prefix = self.prefixWithSection(section)
            let selector = #selector(delegate.insetForSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! UIEdgeInsets
            }
        }
        return UIEdgeInsets.zero
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size = CGSize.zero
        if let delegate = self.tupleDelegate {
            let prefix = self.prefixWithSection(section)
            let selector = #selector(delegate.sizeForHeaderInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                size = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGSize
            }
            // Prevent negative size
            size.width = max(size.width, 0.0)
            size.height = max(size.height, 0.0)
        }
        return UISizeIntegral(size)
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        var size = CGSize.zero
        if let delegate = self.tupleDelegate {
            let prefix = self.prefixWithSection(section)
            let selector = #selector(delegate.sizeForFooterInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                size = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGSize
            }
            // Prevent negative size
            size.width = max(size.width, 0.0)
            size.height = max(size.height, 0.0)
        }
        return UISizeIntegral(size)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: 1.0, height: 1.0) //item size cannot be zero, otherwise it will crash
        if let delegate = self.tupleDelegate {
            let prefix = self.prefixWithSection(indexPath.section)
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
        if let delegate = self.tupleDelegate {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector: Selector = #selector(delegate.tupleItem(_:atIndexPath:))
            let itemBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) in
                return self.dequeueReusableCellWithClass(cls, iblk: iblk, pre: pre, idx: idx, idxPath: indexPath)
            }
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: itemBlock, with: indexPath, withPre: prefix)
            }
        }
        // Call cell
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HTupleBaseCell
        // Update layout
        if let cell = cell, cell.responds(to: #selector(cell.relayoutSubviews)) {
            cell.relayoutSubviews()
        }
        // Prevent crashes
        return cell ?? UICollectionViewCell()
    }
    
    internal func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var cell: HTupleBaseApex?
        if kind == UICollectionElementKindSectionHeader {
            // Call delegate method
            if let delegate = self.tupleDelegate {
                let prefix = self.prefixWithSection(indexPath.section)
                let selector: Selector = #selector(delegate.tupleHeader(_:inSection:))
                let headerBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject in
                    return self.dequeueReusableHeaderWithClass(cls, iblk: iblk, pre: pre, idx: idx, idxPath: indexPath)
                }
                if delegate.responds(to: selector, withPre: prefix) {
                    delegate.perform(selector, with: headerBlock, with: indexPath.section, withPre: prefix)
                }
            }
            // Call cell
            cell = self.allReuseHeaders.object(forKey: indexPath.nsStringValue) as? HTupleBaseApex
        }else if (kind == UICollectionElementKindSectionFooter) {
            // Call delegate method
            if let delegate = self.tupleDelegate {
                let prefix = self.prefixWithSection(indexPath.section)
                let selector: Selector = #selector(delegate.tupleFooter(_:inSection:))
                let footerBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject in
                    return self.dequeueReusableFooterWithClass(cls, iblk: iblk, pre: pre, idx: idx, idxPath: indexPath)
                }
                if delegate.responds(to: selector, withPre: prefix) {
                    delegate.perform(selector, with: footerBlock, with: indexPath.section, withPre: prefix)
                }
            }
            // Call cell
            cell = self.allReuseFooters.object(forKey: indexPath.nsStringValue) as? HTupleBaseApex
        }
        // Update layout
        if let cell = cell, cell.responds(to: #selector(cell.relayoutSubviews)) {
            cell.relayoutSubviews()
        }
        // Prevent crashes
        return cell ?? UICollectionReusableView()
    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.prefixWithSection(indexPath.section)
        let selector = #selector(delegate.willDisplayCell(_:atIndexPath:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: cell, with: indexPath, withPre: prefix)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = self.tupleDelegate else { return }
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HTupleBaseCell
        if let cell = cell, cell.didSelectCell != nil {
            cell.didSelectCell!(cell, indexPath)
        }else {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(delegate.didSelectItemAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: indexPath, withPre: prefix)
            }
        }
    }

    /// UICollectionViewDelegate
    internal func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        if let delegate = self.tupleDelegate {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(delegate.shouldHighlightItemAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return true
    }
    internal func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.prefixWithSection(indexPath.section)
        let selector = #selector(delegate.didHighlightItemAtIndexPath(_:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: indexPath, withPre: prefix)
        }
    }
    internal func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.prefixWithSection(indexPath.section)
        let selector = #selector(delegate.didUnhighlightItemAtIndexPath(_:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: indexPath, withPre: prefix)
        }
    }
    internal func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let delegate = self.tupleDelegate {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(delegate.shouldSelectItemAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return true
    }
    internal func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if let delegate = self.tupleDelegate {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(delegate.shouldDeselectItemAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return false
    }
    internal func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.prefixWithSection(indexPath.section)
        let selector = #selector(delegate.didDeselectItemAtIndexPath(_:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: indexPath, withPre: prefix)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.prefixWithSection(indexPath.section)
        let selector = #selector(delegate.willDisplayElementKind(_:atIndexPath:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: elementKind, with: indexPath, withPre: prefix)
        }
    }
    internal func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.prefixWithSection(indexPath.section)
        let selector = #selector(delegate.didEndDisplayingCell(_:forItemAtIndexPath:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: cell, with: indexPath, withPre: prefix)
        }
    }
    internal func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.prefixWithSection(indexPath.section)
        let selector = #selector(delegate.didEndDisplayingElementOfKind(_:atIndexPath:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: elementKind, with: indexPath, withPre: prefix)
        }
    }

    /// UIScrollViewDelegate
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.tupleScrollSplitPrefix()
        let selector = NSSelectorFromString("tupleViewDidScroll:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }
    internal func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.tupleScrollSplitPrefix()
        let selector = NSSelectorFromString("tupleViewDidZoom:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.tupleScrollSplitPrefix()
        let selector = NSSelectorFromString("tupleViewWillBeginDragging:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

    internal func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.tupleScrollSplitPrefix()
        //let selector = NSSelectorFromString("tupleViewWillEndDragging:withVelocity:targetContentOffset:")
        let selector = NSSelectorFromString("tupleViewWillEndDragging:targetContentOffset:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: velocity, with: targetContentOffset, withPre: prefix)
        }
    }

    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.tupleScrollSplitPrefix()
        let selector = NSSelectorFromString("tupleViewDidEndDragging:willDecelerate:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, with: decelerate, withPre: prefix)
        }
    }

    internal func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.tupleScrollSplitPrefix()
        let selector = NSSelectorFromString("tupleViewWillBeginDecelerating:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.tupleScrollSplitPrefix()
        let selector = NSSelectorFromString("tupleViewDidEndDecelerating:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

    internal func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.tupleScrollSplitPrefix()
        let selector = NSSelectorFromString("tupleViewDidEndScrollingAnimation:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if let delegate = self.tupleDelegate {
            let prefix = self.tupleScrollSplitPrefix()
            let selector = NSSelectorFromString("tupleViewForZoomingInScrollView:")
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: scrollView, withPre: prefix) as? UIView
            }
        }
        return nil
    }
    internal func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.tupleScrollSplitPrefix()
        let selector = NSSelectorFromString("tupleViewWillBeginZooming:withView:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, with: view, withPre: prefix)
        }
    }
    internal func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.tupleScrollSplitPrefix()
        let selector = NSSelectorFromString("tupleViewDidEndZooming:atScale:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: view, with: scale, withPre: prefix)
        }
    }

    internal func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let delegate = self.tupleDelegate {
            let prefix = self.tupleScrollSplitPrefix()
            let selector = NSSelectorFromString("tupleViewShouldScrollToTop:")
            if delegate.responds(to: selector, withPre: prefix) {
                return delegate.performWithUnretainedValue(selector, with: scrollView, withPre: prefix) as! Bool
            }
        }
        return true
    }
    internal func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.tupleScrollSplitPrefix()
        let selector = NSSelectorFromString("tupleViewDidScrollToTop:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }

    internal func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        guard let delegate = self.tupleDelegate else { return }
        let prefix = self.tupleScrollSplitPrefix()
        let selector = NSSelectorFromString("tupleViewDidChangeAdjustedContentInset:")
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: scrollView, withPre: prefix)
        }
    }
    
}

/// Signal mechanism classification
extension HTupleView {

    /// The signal block held by tupleView
    var signalBlock: HTupleCellSignalBlock? {
        get {
            return self.getAssociatedValueForKey(&KTupleSignalKey) as? HTupleCellSignalBlock
        }
        set {
            self.setAssociateCopyValue(newValue, key: &KTupleSignalKey)
        }
    }
    
    /// Send signal to tupleView
    func signalToTupleView(_ signal: HTupleSignal?, _ completion: @escaping () -> Void) {
        guard let signalBlock = self.signalBlock else { return }
        signalBlock(self, signal)
        completion()
    }

    /// Send signals to all items, items under a certain section, or a single item individually
    func signalToAllItems(_ signal: HTupleSignal?, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let tuples = self.allReuseCells.objectEnumerator()?.allObjects.compactMap { $0 as? HTupleBaseCell }
            tuples?.forEach { cell in
                DispatchQueue.main.async {
                    cell.signalBlock?(cell, signal)
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func signal(_ signal: HTupleSignal?, itemSection section: Int, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let items = self.numberOfItems(inSection: section)
            let group = DispatchGroup()
            DispatchQueue.concurrentPerform(iterations: items) { i in
                let cell = self.allReuseCells.object(forKey: IndexPath.nsStringValue(i, section)) as? HTupleBaseCell
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

    func signal(_ signal: HTupleSignal?, toRow row: Int, inSection section: Int, _ completion: @escaping () -> Void) {
        let cell = self.allReuseCells.object(forKey: IndexPath.nsStringValue(row, section)) as? HTupleBaseCell
        if let cell = cell, let signalBlock = cell.signalBlock {
            signalBlock(cell, signal)
        }
        completion()
    }

    /// Send signals to all headers or a single header individually
    func signalToAllHeader(_ signal: HTupleSignal?, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let sections = self.numberOfSections
            let group = DispatchGroup()
            DispatchQueue.concurrentPerform(iterations: sections) { i in
                let header = self.allReuseHeaders.object(forKey: IndexPath.nsStringValue(0, i)) as? HTupleBaseApex
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


    func signal(_ signal: HTupleSignal?, headerSection section: Int, _ completion: @escaping () -> Void) {
        let header = self.allReuseHeaders.object(forKey: IndexPath.nsStringValue(0, section)) as? HTupleBaseApex
        if let header = header, let signalBlock = header.signalBlock {
            signalBlock(header, signal)
        }
        completion()
    }

    /// Send signals to all footers or a single footer individually
    func signalToAllFooter(_ signal: HTupleSignal?, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let sections = self.numberOfSections
            let group = DispatchGroup()
            DispatchQueue.concurrentPerform(iterations: sections) { i in
                let footer = self.allReuseFooters.object(forKey: IndexPath.nsStringValue(0, i)) as? HTupleBaseApex
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

    func signal(_ signal: HTupleSignal?, footerSection section: Int, _ completion: @escaping () -> Void) {
        let footer = self.allReuseFooters.object(forKey: IndexPath.nsStringValue(0, section)) as? HTupleBaseApex
        if let footer = footer, let signalBlock = footer.signalBlock {
            signalBlock(footer, signal)
        }
        completion()
    }

    /// Release all signal blocks
    func releaseAllSignal() {
        DispatchQueue.global().async {
            self.signalBlock = nil
            //release all cell
            self.allReuseCells.objectEnumerator()?.allObjects.forEach { ($0 as? HTupleBaseCell)?.signalBlock = nil }
            //release all header
            self.allReuseHeaders.objectEnumerator()?.allObjects.forEach { ($0 as? HTupleBaseApex)?.signalBlock = nil }
            //release all footer
            self.allReuseFooters.objectEnumerator()?.allObjects.forEach { ($0 as? HTupleBaseApex)?.signalBlock = nil }
        }
    }

    /// Get cell or indexPath based on the given row and section
    func cell(_ row: Int, _ section: Int) -> AnyObject? {
        return self.allReuseCells.object(forKey: IndexPath.nsStringValue(row, section))
    }
    func indexPath(_ row: Int, _ section: Int) -> IndexPath {
        return IndexPath(row: row, section: section)
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

private var Tuple_State_Key = "_tuple_"

/// Design data storage category for split
extension HTupleView {

    private var tupleStateSource: NSMutableDictionary {
        get {
            if let dict = self.getAssociatedValueForKey(&KTupleStateSourceKey) as? NSMutableDictionary {
                return dict
            } else {
                let dict = NSMutableDictionary()
                self.setAssociateValue(dict, key: &KTupleStateSourceKey)
                return dict
            }
        }
    }
    
    /// The state represented by the tupleView split design
    var tupleState: Int {
        get {
            let value = self.getAssociatedValueForKey(&KTupleStateKey) as? NSNumber ?? NSNumber(value: 0)
            return value.intValue
        }
        set {
            if newValue != self.tupleState {
                self.setAssociateValue(NSNumber(value: newValue), key: &KTupleStateKey)
                self.reloadData()
            }
        }
    }

    /// Add a value to a certain state
    func setObject(_ anObject: Any, forKey aKey: String, state: Int) {
        let key = aKey + Tuple_State_Key + "\(state)"
        self.tupleStateSource.setObject(anObject, forKey: key as NSCopying)
    }

    /// Get a value of a certain state
    func object(forKey aKey: String, state: Int) -> Any? {
        let key = aKey + Tuple_State_Key + "\(state)"
        return self.tupleStateSource.object(forKey: key)
    }

    /// Remove a value in a certain state
    func removeObject(forKey aKey: String, state: Int) {
        let key = aKey + Tuple_State_Key + "\(state)"
        self.tupleStateSource.removeObject(forKey: key)
    }

    /// Delete the value of a certain state
    func removeObject(forState state: Int) {
        let key = Tuple_State_Key + "\(state)"
        for (aKey, _) in self.tupleStateSource.reversed() {
            let aKey = aKey as! String
            if key == aKey {
                self.tupleStateSource.removeObject(forKey: aKey)
            }
        }
        
    }

    /// Remove all values ​​of the state
    func clearTupleState() {
        self.tupleStateSource.removeAllObjects()
    }

}
