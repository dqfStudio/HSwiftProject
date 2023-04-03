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
    case `default`  //单体式设计
    case split //分体式设计
}

private var KTupleDefaultTag  = 1213141516

private var KDefaultPageSize  = 20
private var KTupleDesignKey   = "tuple"
private var KTupleExaDesignKey = "tupleExa"

private var tupleStateKey = "tupleStateKey"
private var signalBlockKey = "signalBlockKey"
private var tupleStateSourceKey = "tupleStateSourceKey"

private var UICollectionElementKindSectionHeader = "UICollectionElementKindSectionHeader"
private var UICollectionElementKindSectionFooter = "UICollectionElementKindSectionFooter"

///refresh & loadMore block
typealias HTupleRefreshBlock = () -> Void
typealias HTupleLoadMoreBlock = () -> Void

///tuple header & footer & item block
typealias HTupleHeader = (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject
typealias HTupleFooter = (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject
typealias HTupleItem = (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject

///split design exclusive sections block
typealias HTupleSectionExclusiveBlock = () -> NSArray

///此类用于全工程刷新tupleView
class HTupleAppearance : NSObject {
    
    private static var hashTuples = NSHashTable<AnyObject>.weakObjects()
    
    static func addTuple(_ anTuple: AnyObject) {
        self.hashTuples.add(anTuple)
    }
    static func refreshTuples(_ completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            //倒序执行
            for item in self.hashTuples.allObjects.reversed() {
                let tuple = item as? HTupleView
                if tuple != nil {
                    tuple!.reloadData()
                }
            }
            completion()
        }
    }
    static func refreshTuples(key: String, _ completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            //倒序执行
            for item in self.hashTuples.allObjects.reversed() {
                let tuple = item as? HTupleView
                if tuple != nil, tuple!.reloadTupleKey == key {
                    tuple!.reloadData()
                }
            }
            completion()
        }
    }
    static func releaseTuples(key: String, _ completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            //倒序执行
            for item in self.hashTuples.allObjects.reversed() {
                let tuple = item as? HTupleView
                if tuple != nil, tuple!.releaseTupleKey == key {
                    tuple!.releaseTupleBlock()
                }
            }
            completion()
        }
    }
}

@objc protocol HTupleViewDelegate : UICollectionViewDelegate {
    @objc
    optional func numberOfSectionsInTupleView() -> Any
    @objc
    optional func numberOfItemsInSection(_ section: Any) -> Any
    ///layout == HCollectionViewFlowLayout
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
    
    /// UICollectionViewDataSource
    @objc
    optional func canMoveItemAtIndexPath(_ indexPath: IndexPath) -> Bool
    @objc
    optional func moveItemAtIndexPath(_ sourceIndexPath: IndexPath, toIndexPath destinationIndexPath: IndexPath)
    
    @objc
    optional func indexTitlesForCollectionView() -> [String]?
    @objc
    optional func indexPathForIndexTitle(_ title: String, atIndex index: NSInteger) -> IndexPath

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
    
    //@objc optional func willDisplaySupplementaryView(_ view: HTupleBaseApex, forElementKind elementKind: String, atIndexPath indexPath: IndexPath)
    @objc
    optional func didEndDisplayingCell(_ cell: HTupleBaseCell, forItemAtIndexPath indexPath: IndexPath)
    //@objc optional func didEndDisplayingSupplementaryView(_ view: HTupleBaseApex, forElementOfKind elementKind: String, atIndexPath indexPath: IndexPath)
    
    @objc
    optional func shouldShowMenuForItemAtIndexPath(_ indexPath: IndexPath) -> Bool
    //@objc optional func canPerformAction(_ action: Selector, forItemAtIndexPath indexPath: IndexPath, withSender sender: AnyObject?) -> Bool
    //@objc optional func performAction(_ action: Selector, forItemAtIndexPath indexPath: IndexPath, withSender sender: AnyObject?)
    
    @objc
    optional func transitionLayoutForOldLayout(_ fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout?

     /// Focus
    @objc
    optional func canFocusItemAtIndexPath(_ indexPath: IndexPath) -> Bool
    @objc
    optional func shouldUpdateFocusInContext(_ context: UICollectionViewFocusUpdateContext) -> Bool
    @objc
    optional func didUpdateFocusInContext(_ context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator)
    @objc
    optional func indexPathForPreferredFocusedViewIn() -> IndexPath?
    
    @objc
    optional func targetIndexPathForMoveFromItemAtIndexPath(_ originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath?
    
    @objc
    optional func targetContentOffsetForProposedContentOffset(_ proposedContentOffset: CGPoint) -> CGPoint
    
    @objc
    optional func shouldSpringLoadItemAtIndexPath(_ indexPath: IndexPath, withContext context: UISpringLoadedInteractionContext) -> Bool
    
    @objc
    optional func shouldBeginMultipleSelectionInteractionAtIndexPath(_ indexPath: IndexPath) -> Bool
    
    @objc
    optional func didBeginMultipleSelectionInteractionAtIndexPath(_ indexPath: IndexPath)
    
    @objc
    optional func collectionViewDidEndMultipleSelectionInteraction()
    
    @available(iOS 13.0, *)
    @objc
    optional func contextMenuConfigurationForItemAtIndexPath(_ indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    
    @available(iOS 13.0, *)
    @objc
    optional func previewForHighlightingContextMenuWithConfiguration(_ configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    
    @available(iOS 13.0, *)
    @objc
    optional func previewForDismissingContextMenuWithConfiguration(_ configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    
    @available(iOS 13.0, *)
    @objc
    optional func willPerformPreviewActionForMenuWithConfiguration(_ configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating)

    /// UIScrollViewDelegate
    @objc
    optional func tupleScrollViewDidScroll(_ scrollView: UIScrollView)
    @objc
    optional func tupleScrollViewDidZoom(_ scrollView: UIScrollView)
    
    @objc
    optional func tupleScrollViewWillBeginDragging(_ scrollView: UIScrollView)
    
    //@objc optional func tupleScrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: CGPoint)
    @objc
    optional func tupleScrollViewWillEndDragging(_ velocity: CGPoint, targetContentOffset: CGPoint)
    
    @objc
    optional func tupleScrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    
    @objc
    optional func tupleScrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @objc
    optional func tupleScrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    
    @objc
    optional func tupleScrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    
    @objc
    optional func tupleViewForZoomingInScrollView(_ scrollView: UIScrollView) -> UIView?
    @objc
    optional func tupleScrollViewWillBeginZooming(_ scrollView: UIScrollView, withView view: UIView?)
    //@objc optional func tupleScrollViewDidEndZooming(_ scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat)
    @objc
    optional func tupleScrollViewDidEndZooming(_ view: UIView?, atScale scale: CGFloat)
    
    @objc
    optional func tupleScrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool
    @objc
    optional func tupleScrollViewDidScrollToTop(_ scrollView: UIScrollView)
    
    @objc
    optional func tupleScrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)
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
    
    ///默认layout为HCollectionViewFlowLayout
    ///默认为垂直滚动方向
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor.clear
    }
    
    convenience init(frame: CGRect) {
        let flowLayout = HCollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        self.init(frame: frame, collectionViewLayout: flowLayout)
    }
    
    convenience init(frame: CGRect, scrollDirection direction: HTupleDirection) {
        let flowLayout = HCollectionViewFlowLayout()
        if direction == .horizontal {
            flowLayout.scrollDirection = .horizontal
        }else {
            flowLayout.scrollDirection = .vertical
        }
        self.init(frame: frame, collectionViewLayout: flowLayout)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        flowLayout = layout as? UICollectionViewFlowLayout
        self.setup()
    }
    
    ///split设计初始化方法
    static func tupleFrame(_ frame: () -> CGRect, exclusiveSections sections: HTupleSectionExclusiveBlock) -> HTupleView {
        return HTupleView(frame(), exclusiveSections: sections())
    }
    
    private convenience init(_ frame: CGRect, exclusiveSections sectionPaths: NSArray) {
        let flowLayout = HCollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        self.init(frame: UIRectIntegral(frame), collectionViewLayout: flowLayout)
        self.flowLayout = flowLayout
        self.tupleStyle = .split
        self.sectionPaths = sectionPaths
        self.setup()
    }
    
    private weak var tupleDelegate: HTupleViewDelegate?
    override weak var delegate: UICollectionViewDelegate? {
        get { return super.delegate }
        set { tupleDelegate = newValue as? HTupleViewDelegate }
    }
    override weak var dataSource: UICollectionViewDataSource? {
        get { return super.dataSource }
        set { }
    }
    
    override var frame: CGRect {
        get { return super.frame }
        set {
            let frame = UIRectIntegral(newValue)
            if frame != super.frame {
                super.frame = frame
                self.reloadData()
            }
        }
    }
    
    private func setup() {
        //保存tupleView用于全局刷新
        HTupleAppearance.addTuple(self)
        
        //设置默认tag
        self.tag = KTupleDefaultTag
        
        if self.flowLayout!.scrollDirection == .vertical {
            self.verticalBounceEnabled()
        }else {
            self.horizontalBounceEnabled()
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

    private var _pageNo: Int = 1
    /// page number, default 1
    var pageNo: Int {
        get {
            if _pageNo <= 0 {
                return 1
            }
            return _pageNo
        }
        set {
            _pageNo = newValue
        }
    }
    
    private var _pageSize: Int = KDefaultPageSize
    /// page size, default 20
    var pageSize: Int {
        get {
            if _pageSize <= 0 {
                return KDefaultPageSize
            }
            return _pageSize
        }
        set {
            _pageSize = newValue
        }
    }
    
    private var _totalNo: Int = 10000
    /// total number.
    var totalNo: Int {
        get {
            if _totalNo <= 0 {
                return 10000
            }
            return _totalNo
        }
        set {
            _totalNo = newValue
        }
    }
    
    ///refresh header style
    var refreshHeaderStyle: HTupleRefreshHeaderStyle = .gray
    
    ///load more footer style
    var refreshFooterStyle: HTupleRefreshFooterStyle = .style1
    
    private var _refreshBlock: HTupleRefreshBlock?
    /// block to refresh data
    var refreshBlock: HTupleRefreshBlock? {
        get {
            return _refreshBlock
        }
        set {
            _refreshBlock = newValue
            if _refreshBlock != nil {
                //@www
                self.mj_header = HTupleRefresh.refreshHeaderWithStyle(refreshHeaderStyle) {
                    //@sss
                    self.pageNo = 1
                    self._refreshBlock!()
                }
            }else {
                self.mj_header = nil
            }
        }
    }
        
    private var _loadMoreBlock: HTupleLoadMoreBlock?
    /// block to load more data
    var loadMoreBlock: HTupleLoadMoreBlock? {
        get {
            return _loadMoreBlock
        }
        set {
            _loadMoreBlock = newValue
            if _loadMoreBlock != nil {
                self.pageNo = 1
                //@www
                self.mj_footer = HTupleRefresh.refreshFooterWithStyle(refreshFooterStyle) {
                    //@sss
                    self.pageNo += 1
                    if self.pageSize * self.pageNo < self.totalNo {
                        self._loadMoreBlock!()
                    }else {
                        self.mj_footer!.endRefreshing()
                    }
                }
            }else {
                self.mj_footer = nil
            }
        }
    }
    
    ///设置释放的key值
    var releaseTupleKey: String?

    ///设置reload的key值
    var reloadTupleKey: String?

    ///block refresh & loadMore
    func beginRefreshing(_ completion: @escaping () -> Void) {
        if self.refreshBlock != nil {
            self.pageNo = 1
            self.mj_header?.beginRefreshing(completionBlock:completion)
        }
    }

    ///stop refresh
    func endRefreshing(_ completion: @escaping () -> Void) {
        self.mj_header?.endRefreshing(completionBlock:completion)

    }
    
    func endLoadMore(_ completion: @escaping () -> Void) {
        self.mj_footer?.endRefreshing(completionBlock:completion)
    }
    
    // header & footer 是否悬停
    var sectionHeadersPinToVisibleBounds: Bool {
        get {
            return ((flowLayout?.sectionHeadersPinToVisibleBounds) != nil)
        }
        set {
            flowLayout?.sectionHeadersPinToVisibleBounds = newValue
        }
    }
    
    var sectionFootersPinToVisibleBounds: Bool {
        get {
            return ((flowLayout?.sectionFootersPinToVisibleBounds) != nil)
        }
        set {
            flowLayout?.sectionFootersPinToVisibleBounds = newValue
        }
    }
    
    ///bounce method
    func horizontalBounceEnabled() {
        self.bounces = true
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = false
    }

    func verticalBounceEnabled() {
        self.bounces = true
        self.alwaysBounceHorizontal = false
        self.alwaysBounceVertical = true
    }

    func bounceEnabled() {
        self.bounces = true
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = true
    }

    func bounceDisenable() {
        self.bounces = false
    }

    @objc
    private func reloadTupleData() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }

    /// release method
    @objc
    func releaseTupleBlock() {
        DispatchQueue.global().async {
            self.releaseAllSignal()
            self.clearTupleState()

            if self.tupleDelegate != nil { self.tupleDelegate = nil }
            if self.refreshBlock != nil { self.refreshBlock = nil }
            if self.loadMoreBlock != nil { self.loadMoreBlock = nil }
        }
    }

    private var addressValue: String {
        return String(format: "%p", self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// register class
    func dequeueReusableHeaderWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, idxPath: IndexPath) -> AnyObject {
        var cell: HTupleBaseApex
        var identifier = NSStringFromClass(cls)
        identifier = identifier + self.addressValue
        identifier = identifier + "HeaderCell"
        if self.tupleStyle == .split && self.sectionPaths?.contains(idxPath.section) == false {
            identifier = identifier + "\(self.tupleState)"
        }
        if (pre != nil) { identifier = identifier + pre! }
        if idx { identifier = identifier + (idxPath.stringValue as String) }
        if self.allReuseIdentifiers.contains(identifier) == false {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
            cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseApex
            cell.tuple = self
            cell.indexPath = idxPath
            cell.isHeader = true
            //init method
            if iblk != nil {
                let initHeaderBlock: HTupleCellInitBlock = iblk as! HTupleCellInitBlock
                initHeaderBlock(cell)
            }
        }else {
            cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseApex
        }
        //保存cell
        self.allReuseHeaders.setObject(cell, forKey: idxPath.stringValue as NSString)
        //调用代理方法
        var edgeInsets: UIEdgeInsets = UIEdgeInsetsZero
        let prefix = self.prefixWithSection(idxPath.section)
        let selector: Selector = #selector(self.tupleDelegate!.edgeInsetsForHeaderInSection(_:))
        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
            edgeInsets = self.tupleDelegate!.performWithUnretainedValue(selector, with: idxPath.section, withPre: prefix) as! UIEdgeInsets
        }
        //设置属性
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        return cell
    }
    
    func dequeueReusableFooterWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, idxPath: IndexPath) -> AnyObject {
        var cell: HTupleBaseApex
        var identifier = NSStringFromClass(cls)
        identifier = identifier + self.addressValue
        identifier = identifier + "FooterCell"
        if self.tupleStyle == .split && self.sectionPaths?.contains(idxPath.section) == false {
            identifier = identifier + "\(self.tupleState)"
        }
        if (pre != nil) { identifier = identifier + pre! }
        if idx { identifier = identifier + idxPath.stringValue }
        if self.allReuseIdentifiers.contains(identifier) == false {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier)
            cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseApex
            cell.tuple = self
            cell.indexPath = idxPath
            cell.isHeader = true
            //init method
            if iblk != nil {
                let initFooterBlock: HTupleCellInitBlock = iblk as! HTupleCellInitBlock
                initFooterBlock(cell)
            }
        }else {
            cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseApex
        }
        //保存cell
        self.allReuseFooters.setObject(cell, forKey: idxPath.stringValue as NSString)
        //调用代理方法
        var edgeInsets: UIEdgeInsets = UIEdgeInsetsZero
        let prefix = self.prefixWithSection(idxPath.section)
        let selector = #selector(self.tupleDelegate!.edgeInsetsForFooterInSection(_:))
        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
            edgeInsets = self.tupleDelegate!.performWithUnretainedValue(selector, with: idxPath.section, withPre: prefix) as! UIEdgeInsets
        }
        //设置属性
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        return cell
    }

    func dequeueReusableCellWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, idxPath: IndexPath) -> AnyObject {
        var cell: HTupleBaseCell
        var identifier = NSStringFromClass(cls)
        identifier = identifier + self.addressValue
        identifier = identifier + "ItemCell"
        if self.tupleStyle == .split && self.sectionPaths?.contains(idxPath.section) == false {
            identifier = identifier + "\(self.tupleState)"
        }
        if (pre != nil) { identifier = identifier + pre! }
        if idx { identifier = identifier + idxPath.stringValue }
        if self.allReuseIdentifiers.contains(identifier) == false {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forCellWithReuseIdentifier: identifier)
            cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseCell
            cell.tuple = self
            cell.indexPath = idxPath
            //init method
            if iblk != nil {
                let initCellBlock: HTupleCellInitBlock = iblk as! HTupleCellInitBlock
                initCellBlock(cell)
            }
        }else {
            cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseCell
        }
        //保存cell
        self.allReuseCells.setObject(cell, forKey: idxPath.stringValue as NSString)
        //调用代理方法
        var edgeInsets: UIEdgeInsets = UIEdgeInsetsZero
        let prefix = self.prefixWithSection(idxPath.section)
        let selector = #selector(self.tupleDelegate!.edgeInsetsForItemAtIndexPath(_:))
        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
            edgeInsets = self.tupleDelegate!.performWithUnretainedValue(selector, with: idxPath, withPre: prefix) as! UIEdgeInsets
        }
        //设置属性
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
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
            if self.sectionPaths?.contains(self.tupleState) ?? false {
                prefix = KTupleDesignKey + "\(self.tupleState)" + "_"
            }
        }
        return prefix
    }
    private func prefixWithSection(_ section: Int) -> String {
        var prefix = ""
        if self.tupleStyle == .split {
            if self.sectionPaths?.contains(section) ?? false {
                let idx: Int = self.sectionPaths!.index(of: section)
                prefix = KTupleExaDesignKey + "\(idx)" + "_"
            }else {
                prefix = KTupleDesignKey + "\(self.tupleState)" + "_"
            }
        }
        return prefix
    }
    
    /// 以下为UICollectionView的代理方法
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.allSectionInsets.count > 0 {
            self.allSectionInsets.removeAllObjects()
        }
        switch self.tupleStyle {
        case .default:
            var sections = 1
            if self.tupleDelegate != nil {
                let prefix = ""
                let selector = #selector(self.tupleDelegate!.numberOfSectionsInTupleView)
                if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                    sections = self.tupleDelegate!.performWithUnretainedValue(selector, withPre: prefix) as! Int
                }
            }
            return sections
        case .split:
            var sections = 1
            if self.tupleDelegate != nil {
                let prefix = KTupleDesignKey + "\(self.tupleState)" + "_"
                let selector = #selector(self.tupleDelegate!.numberOfSectionsInTupleView)
                if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                    sections = self.tupleDelegate!.performWithUnretainedValue(selector, withPre: prefix) as! Int
                }
            }
            return sections
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items = 0
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(section)
            let selector: Selector = #selector(self.tupleDelegate!.numberOfItemsInSection(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                items = self.tupleDelegate!.performWithUnretainedValue(selector, with: section, withPre: prefix) as! Int
            }
            let edgeInsets = self.collectionView(self, layout: self.flowLayout!, insetForSectionAt: section)
            self.allSectionInsets.setObject(NSStringFromUIEdgeInsets(edgeInsets) as AnyObject, forKey: "\(section)" as NSString)
        }
        return items
    }

    /// layout == HCollectionViewFlowLayout
    internal func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, colorForSectionAt section: NSInteger) -> UIColor {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(section)
            let selector = #selector(self.tupleDelegate!.colorForSection(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: section, withPre: prefix) as! UIColor
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
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(section)
            let selector = #selector(self.tupleDelegate!.insetForSection(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: section, withPre: prefix) as! UIEdgeInsets
            }
        }
        return UIEdgeInsetsZero
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size: CGSize = CGSize.zero
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(section)
            let selector = #selector(self.tupleDelegate!.sizeForHeaderInSection(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                size = self.tupleDelegate!.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGSize
            }
        }
        return UISizeIntegral(size)
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        var size: CGSize = CGSize.zero
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(section)
            let selector = #selector(self.tupleDelegate!.sizeForFooterInSection(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                size = self.tupleDelegate!.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGSize
            }
        }
        return UISizeIntegral(size)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize = CGSize.zero
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.sizeForItemAtIndexPath(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                size = self.tupleDelegate!.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! CGSize
            }
            //不能为CGSize.zero，否则会崩溃
            if CGSize.zero == size {
                size = CGSize(width: 1.0, height: 1.0)
            }
        }
        return UISizeIntegral(size)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //调用代理方法
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector: Selector = #selector(self.tupleDelegate!.tupleItem(_:atIndexPath:))
            let itemBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) in
                return self.dequeueReusableCellWithClass(cls, iblk: iblk, pre: pre, idx: idx, idxPath: indexPath)
            }
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: itemBlock, with: indexPath, withPre: prefix)
            }
        }
        //调用cell
        let cell = self.allReuseCells.object(forKey: indexPath.stringValue as NSString) as! HTupleBaseCell
        //更新布局
        if cell.responds(to: #selector(cell.relayoutSubviews)) {
            cell.relayoutSubviews()
        }
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var cell: HTupleBaseApex?
        if kind == UICollectionElementKindSectionHeader {
            //调用代理方法
            if self.tupleDelegate != nil {
                let prefix = self.prefixWithSection(indexPath.section)
                let selector: Selector = #selector(self.tupleDelegate!.tupleHeader(_:inSection:))
                let headerBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject in
                    return self.dequeueReusableHeaderWithClass(cls, iblk: iblk, pre: pre, idx: idx, idxPath: indexPath)
                }
                if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                    self.tupleDelegate!.perform(selector, with: headerBlock, with: indexPath.section, withPre: prefix)
                }
            }
            //调用cell
            cell = self.allReuseHeaders.object(forKey: indexPath.stringValue as NSString) as? HTupleBaseApex
        }else if (kind == UICollectionElementKindSectionFooter) {
            //调用代理方法
            if self.tupleDelegate != nil {
                let prefix = self.prefixWithSection(indexPath.section)
                let selector: Selector = #selector(self.tupleDelegate!.tupleFooter(_:inSection:))
                let footerBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject in
                    return self.dequeueReusableFooterWithClass(cls, iblk: iblk, pre: pre, idx: idx, idxPath: indexPath)
                }
                if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                    self.tupleDelegate!.perform(selector, with: footerBlock, with: indexPath.section, withPre: prefix)
                }
            }
            //调用cell
            cell = self.allReuseFooters.object(forKey: indexPath.stringValue as NSString) as? HTupleBaseApex
        }
        //更新布局
        if cell!.responds(to: #selector(cell!.relayoutSubviews)) {
            cell!.relayoutSubviews()
        }
        return cell!
    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.willDisplayCell(_:atIndexPath:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: cell, with: indexPath, withPre: prefix)
            }
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.tupleDelegate != nil {
            let cell = self.allReuseCells.object(forKey: indexPath.stringValue as NSString) as! HTupleBaseCell
            if cell.didSelectCell != nil {
                cell.didSelectCell!(cell, indexPath)
            }else {
                let prefix = self.prefixWithSection(indexPath.section)
                let selector = #selector(self.tupleDelegate!.didSelectItemAtIndexPath(_:))
                if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                    self.tupleDelegate!.perform(selector, with: indexPath, withPre: prefix)
                }
            }
        }
    }
    
    /// UICollectionViewDataSource
    internal func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.canMoveItemAtIndexPath(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return false
    }
    internal func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if self.tupleDelegate != nil {
            let prefix = self.tuplePrefix()
            let selector = #selector(self.tupleDelegate!.moveItemAtIndexPath(_:toIndexPath:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: sourceIndexPath, with: destinationIndexPath, withPre: prefix)
            }
        }
    }
    
    internal func indexTitles(for collectionView: UICollectionView) -> [String]? {
        if self.tupleDelegate != nil {
            let prefix = self.tuplePrefix()
            let selector = #selector(self.tupleDelegate!.indexTitlesForCollectionView)
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, withPre: prefix) as? [String]
            }
        }
        return nil
    }

    internal func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        if self.tupleDelegate != nil {
            let prefix = self.tuplePrefix()
            let selector = #selector(self.tupleDelegate!.indexPathForIndexTitle(_:atIndex:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: title, with: index, withPre: prefix) as! IndexPath
            }
        }
        return IndexPath()
    }

    /// UICollectionViewDelegate
    internal func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.shouldHighlightItemAtIndexPath(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return true
    }
    internal func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.didHighlightItemAtIndexPath(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: indexPath, withPre: prefix)
            }
        }
    }
    internal func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.didUnhighlightItemAtIndexPath(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: indexPath, withPre: prefix)
            }
        }
    }
    internal func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.shouldSelectItemAtIndexPath(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return true
    }
    internal func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.shouldDeselectItemAtIndexPath(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return false
    }
    internal func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.didDeselectItemAtIndexPath(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: indexPath, withPre: prefix)
            }
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//        let prefix = self.prefixWithSection(indexPath.section)
//        let selector = #selector(self.tupleDelegate!.willDisplaySupplementaryView(_:forElementKind:atIndexPath:))
//        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
//
//        }
    }
    internal func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.didEndDisplayingCell(_:forItemAtIndexPath:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: cell, with: indexPath, withPre: prefix)
            }
        }
    }
    internal func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
//        let prefix = self.prefixWithSection(indexPath.section)
//        let selector = #selector(self.tupleDelegate!.didEndDisplayingSupplementaryView(_:forElementOfKind:atIndexPath:))
//        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
//
//        }
    }

    internal func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.shouldShowMenuForItemAtIndexPath(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return false
    }
    internal func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//        let prefix = self.prefixWithSection(indexPath.section)
//        let selector = #selector(self.tupleDelegate!.canPerformAction(_:forItemAtIndexPath:withSender:))
//        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
//
//        }
        return false
    }
    internal func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//        let prefix = self.prefixWithSection(indexPath.section)
//        let selector = #selector(self.tupleDelegate!.performAction(_:forItemAtIndexPath:withSender:))
//        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
//
//        }
    }

    internal func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        if self.tupleDelegate != nil {
            let prefix = self.tuplePrefix()
            let selector = #selector(self.tupleDelegate!.transitionLayoutForOldLayout(_:newLayout:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: fromLayout, with: toLayout, withPre: prefix) as! UICollectionViewTransitionLayout
            }
        }
        return UICollectionViewTransitionLayout(coder: NSCoder())!
    }

    /// Focus
    internal func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.canFocusItemAtIndexPath(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return false
    }
    internal func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        if self.tupleDelegate != nil {
            let prefix = self.tuplePrefix()
            let selector = #selector(self.tupleDelegate!.shouldUpdateFocusInContext(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: context, withPre: prefix) as! Bool
            }
        }
        return false
    }
    internal func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.tupleDelegate != nil {
            let prefix = self.tuplePrefix()
            let selector = #selector(self.tupleDelegate!.didUpdateFocusInContext(_:withAnimationCoordinator:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: context, with: coordinator, withPre: prefix)
            }
        }
    }
    internal func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        if self.tupleDelegate != nil {
            let prefix = self.tuplePrefix()
            let selector = #selector(self.tupleDelegate!.indexPathForPreferredFocusedViewIn)
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, withPre: prefix) as? IndexPath
            }
        }
        return nil
    }

    internal func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if self.tupleDelegate != nil {
            let prefix = self.tuplePrefix()
            let selector = #selector(self.tupleDelegate!.targetIndexPathForMoveFromItemAtIndexPath(_:toProposedIndexPath:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: originalIndexPath, with: proposedIndexPath, withPre: prefix) as! IndexPath
            }
        }
        return originalIndexPath
    }

    internal func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if self.tupleDelegate != nil {
            let prefix = self.tuplePrefix()
            let selector = #selector(self.tupleDelegate!.targetContentOffsetForProposedContentOffset(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: proposedContentOffset, withPre: prefix) as! CGPoint
            }
        }
        return CGPoint.zero
    }

    internal func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.shouldSpringLoadItemAtIndexPath(_:withContext:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: indexPath, with: context, withPre: prefix) as! Bool
            }
        }
        return false
    }

    internal func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.shouldBeginMultipleSelectionInteractionAtIndexPath(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! Bool
            }
        }
        return false
    }

    internal func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.didBeginMultipleSelectionInteractionAtIndexPath(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: indexPath, withPre: prefix)
            }
        }
    }

    internal func collectionViewDidEndMultipleSelectionInteraction(_ collectionView: UICollectionView) {
        if self.tupleDelegate != nil {
            let prefix = self.tuplePrefix()
            let selector = #selector(self.tupleDelegate!.collectionViewDidEndMultipleSelectionInteraction)
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, withPre: prefix)
            }
        }
    }

    @available(iOS 13.0, *)
    internal func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if self.tupleDelegate != nil {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(self.tupleDelegate!.contextMenuConfigurationForItemAtIndexPath(_:point:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: indexPath, with: point, withPre: prefix) as? UIContextMenuConfiguration
            }
        }
        return nil
    }

    @available(iOS 13.0, *)
    internal func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        if self.tupleDelegate != nil {
            let prefix = self.tuplePrefix()
            let selector = #selector(self.tupleDelegate!.previewForHighlightingContextMenuWithConfiguration(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: configuration, withPre: prefix) as? UITargetedPreview
            }
        }
        return nil
    }

    @available(iOS 13.0, *)
    internal func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        if self.tupleDelegate != nil {
            let prefix = self.tuplePrefix()
            let selector = #selector(self.tupleDelegate!.previewForDismissingContextMenuWithConfiguration(_:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: configuration, withPre: prefix) as? UITargetedPreview
            }
        }
        return nil
    }

    @available(iOS 13.0, *)
    internal func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        if self.tupleDelegate != nil {
            let prefix = self.tuplePrefix()
            let selector = #selector(self.tupleDelegate!.willPerformPreviewActionForMenuWithConfiguration(_:animator:))
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: configuration, with: animator, withPre: prefix)
            }
        }
    }

    /// UIScrollViewDelegate
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tupleDelegate != nil {
            let prefix = self.tupleScrollSplitPrefix()
            let selector = NSSelectorFromString("tupleScrollViewDidScroll:")
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: scrollView, withPre: prefix)
            }
        }
    }
    internal func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if self.tupleDelegate != nil {
            let prefix = self.tupleScrollSplitPrefix()
            let selector = NSSelectorFromString("tupleScrollViewDidZoom:")
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: scrollView, withPre: prefix)
            }
        }
    }

    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.tupleDelegate != nil {
            let prefix = self.tupleScrollSplitPrefix()
            let selector = NSSelectorFromString("tupleScrollViewWillBeginDragging:")
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: scrollView, withPre: prefix)
            }
        }
    }

    internal func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if self.tupleDelegate != nil {
            let prefix = self.tupleScrollSplitPrefix()
            //let selector = NSSelectorFromString("tupleScrollViewWillEndDragging:withVelocity:targetContentOffset:")
            let selector = NSSelectorFromString("tupleScrollViewWillEndDragging:targetContentOffset:")
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: velocity, with: targetContentOffset, withPre: prefix)
            }
        }
    }

    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.tupleDelegate != nil {
            let prefix = self.tupleScrollSplitPrefix()
            let selector = NSSelectorFromString("tupleScrollViewDidEndDragging:willDecelerate:")
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: scrollView, with: decelerate, withPre: prefix)
            }
        }
    }

    internal func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if self.tupleDelegate != nil {
            let prefix = self.tupleScrollSplitPrefix()
            let selector = NSSelectorFromString("tupleScrollViewWillBeginDecelerating:")
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: scrollView, withPre: prefix)
            }
        }
    }
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.tupleDelegate != nil {
            let prefix = self.tupleScrollSplitPrefix()
            let selector = NSSelectorFromString("tupleScrollViewDidEndDecelerating:")
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: scrollView, withPre: prefix)
            }
        }
    }

    internal func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if self.tupleDelegate != nil {
            let prefix = self.tupleScrollSplitPrefix()
            let selector = NSSelectorFromString("tupleScrollViewDidEndScrollingAnimation:")
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: scrollView, withPre: prefix)
            }
        }
    }

    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if self.tupleDelegate != nil {
            let prefix = self.tupleScrollSplitPrefix()
            let selector = NSSelectorFromString("tupleViewForZoomingInScrollView:")
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: scrollView, withPre: prefix) as? UIView
            }
        }
        return nil
    }
    internal func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        if self.tupleDelegate != nil {
            let prefix = self.tupleScrollSplitPrefix()
            let selector = NSSelectorFromString("tupleScrollViewWillBeginZooming:withView:")
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: scrollView, with: view, withPre: prefix)
            }
        }
    }
    internal func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if self.tupleDelegate != nil {
            let prefix = self.tupleScrollSplitPrefix()
            let selector = NSSelectorFromString("tupleScrollViewDidEndZooming:atScale:")
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: view, with: scale, withPre: prefix)
            }
        }
    }

    internal func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if self.tupleDelegate != nil {
            let prefix = self.tupleScrollSplitPrefix()
            let selector = NSSelectorFromString("tupleScrollViewShouldScrollToTop:")
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                return self.tupleDelegate!.performWithUnretainedValue(selector, with: scrollView, withPre: prefix) as! Bool
            }
        }
        return true
    }
    internal func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if self.tupleDelegate != nil {
            let prefix = self.tupleScrollSplitPrefix()
            let selector = NSSelectorFromString("tupleScrollViewDidScrollToTop:")
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: scrollView, withPre: prefix)
            }
        }
    }

    internal func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        if self.tupleDelegate != nil {
            let prefix = self.tupleScrollSplitPrefix()
            let selector = NSSelectorFromString("tupleScrollViewDidChangeAdjustedContentInset:")
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.perform(selector, with: scrollView, withPre: prefix)
            }
        }
    }
    
}

/// 信号机制分类
extension HTupleView {

    ///tupleView持有的信号block
    var signalBlock: HTupleCellSignalBlock? {
        get {
            return self.getAssociatedValueForKey(&signalBlockKey) as? HTupleCellSignalBlock
        }
        set {
            self.setAssociateCopyValue(newValue, key: &signalBlockKey)
        }
    }
    
    ///给tupleView发送信号
    func signalToTupleView(_ signal: HTupleSignal?, _ completion: @escaping () -> Void) {
        if self.signalBlock != nil {
            DispatchQueue.main.async { [weak self] in
                self!.signalBlock!(self!, signal)
                completion()
            }
        }
    }

    ///给所有item、某个section下的item或单独某个item发送信号
    func signalToAllItems(_ signal: HTupleSignal?, _ completion: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            for object in self!.allReuseCells.objectEnumerator()!.allObjects {
                let cell = object as? HTupleBaseCell
                if cell != nil, cell!.signalBlock != nil {
                    cell!.signalBlock!(cell!, signal)
                }
            }
            completion()
        }
    }

    func signal(_ signal: HTupleSignal?, itemSection section: Int, _ completion: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            let items = self!.numberOfItems(inSection: section)
            for i in 0..<items {
                let cell = self!.allReuseCells.object(forKey: IndexPath.stringValue(i, section) as NSString) as? HTupleBaseCell
                if cell != nil, cell!.signalBlock != nil {
                    cell!.signalBlock!(cell!, signal)
                }
            }
            completion()
        }
    }

    func signal(_ signal: HTupleSignal?, toRow row: Int, inSection section: Int, _ completion: @escaping () -> Void) {
        let cell = self.allReuseCells.object(forKey: indexPath(row, section).stringValue as NSString) as? HTupleBaseCell
        if cell != nil, cell!.signalBlock != nil {
            DispatchQueue.main.async { [weak cell] in
                cell!.signalBlock!(cell!, signal)
                completion()
            }
        }
    }

    ///给所有header或单独某个header发送信号
    func signalToAllHeader(_ signal: HTupleSignal?, _ completion: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            let sections = self!.numberOfSections
            for i in 0..<sections {
                let header = self!.allReuseHeaders.object(forKey: IndexPath.stringValue(0, i) as NSString) as? HTupleBaseApex
                if header != nil, header!.signalBlock != nil {
                    header!.signalBlock!(header!, signal)
                }
            }
            completion()
        }
    }

    func signal(_ signal: HTupleSignal?, headerSection section: Int, _ completion: @escaping () -> Void) {
        let header = self.allReuseHeaders.object(forKey: IndexPath.stringValue(0, section) as NSString) as? HTupleBaseApex
        if header != nil, header!.signalBlock != nil {
            DispatchQueue.main.async { [weak header] in
                header!.signalBlock!(header!, signal)
                completion()
            }
        }
    }

    ///给所有footer或单独某个footer发送信号
    func signalToAllFooter(_ signal: HTupleSignal?, _ completion: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            let sections = self!.numberOfSections
            for i in 0..<sections {
                let footer = self!.allReuseFooters.object(forKey: IndexPath.stringValue(0, i) as NSString) as? HTupleBaseApex
                if footer != nil, footer!.signalBlock != nil {
                    footer!.signalBlock!(footer!, signal)
                }
            }
            completion()
        }
    }

    func signal(_ signal: HTupleSignal?, footerSection section: Int, _ completion: @escaping () -> Void) {
        let footer = self.allReuseFooters.object(forKey: IndexPath.stringValue(0, section) as NSString) as? HTupleBaseApex
        if footer != nil, footer!.signalBlock != nil {
            DispatchQueue.main.async { [weak footer] in
                footer!.signalBlock!(footer!, signal)
                completion()
            }
        }
    }

    ///释放所有信号block
    func releaseAllSignal() {
        DispatchQueue.global().async {
            if self.signalBlock != nil {
                self.signalBlock = nil
            }
            //release all cell
            for object in self.allReuseCells.objectEnumerator()!.allObjects {
                let cell = object as? HTupleBaseCell
                if cell?.signalBlock != nil {
                    cell?.signalBlock = nil
                }
            }
            //release all header
            for object in self.allReuseHeaders.objectEnumerator()!.allObjects {
                let header = object as? HTupleBaseApex
                if header?.signalBlock != nil {
                    header?.signalBlock = nil
                }
            }
            //release all footer
            for object in self.allReuseFooters.objectEnumerator()!.allObjects {
                let footer = object as? HTupleBaseApex
                if footer?.signalBlock != nil {
                    footer?.signalBlock = nil
                }
            }
        }
    }
    
    // 开始闪烁动画
    func startOpacityForeverAnimation() {
        self.layer.add(self.opacityForeverAnimationWithDuration(duration: 2.0), forKey: String(describing: type(of: self)))
    }

    // 停止闪烁动画
    func stopOpacityForeverAnimation() {
        self.layer.removeAnimation(forKey: String(describing: type(of: self)))
    }
    
    // 闪烁动画
    func opacityForeverAnimationWithDuration(duration: TimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity") // 必须写opacity才行。
        animation.fromValue = NSNumber(value: 1.0)
        animation.toValue = NSNumber(value: 0.6)
        animation.autoreverses = true
        animation.duration = duration
        animation.repeatCount = .greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn) // 没有的话是均匀的动画。
        return animation
    }

    ///根据传入的row和section获取cell或indexPath
    func cell(_ row: Int, _ section: Int) -> AnyObject? {
        return self.allReuseCells.object(forKey: IndexPath.stringValue(row, section) as NSString)
    }
    func indexPath(_ row: Int, _ section: Int) -> IndexPath {
        return IndexPath(row: row, section: section)
    }

    ///获取某个section的宽高和大小
    func widthForSection(_ section: Int) -> CGFloat {
        var width: CGFloat = self.width
        let edgeInsetsString = self.allSectionInsets.object(forKey: "\(section)" as NSString) as? String
        if edgeInsetsString != nil, edgeInsetsString!.length > 0 {
            let edgeInsets = UIEdgeInsetsFromString(edgeInsetsString!)
            width -= edgeInsets.left + edgeInsets.right
        }
        return width
    }

    func heighForSection(_ section: Int) -> CGFloat {
        var height: CGFloat = self.height
        let edgeInsetsString = self.allSectionInsets.object(forKey: "\(section)" as NSString) as? String
        if edgeInsetsString != nil, edgeInsetsString!.length > 0 {
            let edgeInsets = UIEdgeInsetsFromString(edgeInsetsString!)
            height -= edgeInsets.top + edgeInsets.bottom
        }
        return height
    }
    
    func sizeForSection(_ section: Int) -> CGSize {
        var size: CGSize = self.size
        let edgeInsetsString = self.allSectionInsets.object(forKey: "\(section)" as NSString) as? String
        if edgeInsetsString != nil, edgeInsetsString!.length > 0 {
            let edgeInsets = UIEdgeInsetsFromString(edgeInsetsString!)
            size.width -= edgeInsets.left + edgeInsets.right
            size.height -= edgeInsets.top + edgeInsets.bottom
        }
        return size
    }

    ///根据传入的个数和序号计算该item的宽度
    func fixSlitWith(_ width: CGFloat, colCount: Int, index: Int) -> CGFloat {
        let itemWidth: CGFloat = width / CGFloat(colCount)
        var realItemWidth: CGFloat = CGFloat(floorf(Float(itemWidth)))
        let idxCount: Int = colCount - 1
        if index == idxCount {
            realItemWidth = width - CGFloat(Int(realItemWidth) * idxCount)
        }
        return realItemWidth
    }

}

private var KTupleStateKey = "_tuple_"

/// split设计数据存储分类
extension HTupleView {

    private var tupleStateSource: NSMutableDictionary {
        get {
            var dict: NSMutableDictionary? = self.getAssociatedValueForKey(&tupleStateSourceKey) as? NSMutableDictionary
            if dict == nil {
                dict = NSMutableDictionary()
                self.setAssociateValue(dict, key: &tupleStateSourceKey)
            }
            return dict!
        }
    }
    
    ///tupleView分体式设计所表示的状态
    var tupleState: Int {
        get {
            let value = self.getAssociatedValueForKey(&tupleStateKey) as? NSNumber ?? NSNumber(value: 0)
            return value.intValue
        }
        set {
            if newValue != self.tupleState {
                self.setAssociateValue(NSNumber(value: newValue), key: &tupleStateKey)
                self.reloadData()
            }
        }
    }

    ///向某个状态或当前状态添加一个值
    func setObject(_ anObject: Any, forKey aKey: String) {
        self.setObject(anObject, forKey: aKey, state: self.tupleState)
    }
    
    func setObject(_ anObject: Any, forKey aKey: String, state tupleState: Int) {
        let key: NSString = aKey + KTupleStateKey + "\(tupleState)" as NSString
        self.tupleStateSource.setObject(anObject, forKey: key)
    }

    ///获取某个状态或当前状态的一个值
    func objectForKey(_ aKey: String) -> Any? {
        return self.objectForKey(aKey, state: self.tupleState)
    }
    
    func objectForKey(_ aKey: String, state tupleState: Int) -> Any? {
        let key: NSString = aKey + KTupleStateKey + "\(tupleState)" as NSString
        return self.tupleStateSource.object(forKey: key)
    }

    ///删除某个状态或当前状态下的一个值
    func removeObjectForKey(_ aKey: String) {
        self.removeObjectForKey(aKey, state: self.tupleState)
    }
    
    func removeObjectForKey(_ aKey: String, state tupleState: Int) {
        let key: NSString = aKey + KTupleStateKey + "\(tupleState)" as NSString
        self.tupleStateSource.removeObject(forKey: key)
    }

    ///删除某个状态或当前状态的值
    func removeStateObject() {
        self.removeObjectForState(self.tupleState)
    }
    
    func removeObjectForState(_ tupleState: Int) {
        let key = KTupleStateKey + "\(tupleState)"
        for (aKey, _) in self.tupleStateSource.reversed() {
            let aKey = aKey as! String
            if key == aKey {
                self.tupleStateSource.removeObject(forKey: aKey)
            }
        }
        
    }

    ///删除所有状态的值
    func clearTupleState() {
        if self.tupleStateSource.count > 0 {
            self.tupleStateSource.removeAllObjects()
        }
    }

}
