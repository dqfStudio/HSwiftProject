//
//  HFlowView.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/3.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import Kingfisher
import SDWebImage

private enum HFlowStyle: Int {
    case `default`  // Singleton design
    case split // Split design
}

enum HFlowAlign {
    case `default` // 垂直居上，水平居左
    case center // 垂直居中，水平居中
    case top(CGFloat) // 垂直距离顶部的距离，水平居中
    case ratio(CGFloat) // 垂直距离顶部的比例，水平居中
    case bottom(CGFloat) // 垂直距离底部的距离，水平居中
}

var kFlowDefaultTag = 1615141312

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

class HFlowReload: NSObject {
    var isRefresh = false //是否正在刷新
    var needRefresh = false //是否需要刷新
}

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

class HFlowObserver: NSObject {

    private static var hashObjects = NSHashTable<NSObject>.weakObjects()

    static func addObserver(_ anObserver: NSObject?) {
        if let anObserver = anObserver, !self.hashObjects.contains(anObserver) {
            self.hashObjects.add(anObserver)
        }
    }
    static func perform(key: String) {
        let selector = NSSelectorFromString(key)
        let objects = self.hashObjects.allObjects.reversed()
        objects.forEach {
            if $0.responds(to: selector) {
                $0.perform(selector)
            }
        }
    }
    static func perform(key: String, with object: String) {
        let selector = NSSelectorFromString(key)
        let objects = self.hashObjects.allObjects.reversed()
        objects.forEach {
            if $0.responds(to: selector) {
                $0.perform(selector, with: object)
            }
        }
    }
    static func perform(key: String, with object1: String, with object2: String) {
        let selector = NSSelectorFromString(key)
        let objects = self.hashObjects.allObjects.reversed()
        objects.forEach {
            if $0.responds(to: selector) {
                $0.perform(selector, with: object1, with: object2)
            }
        }
    }
}

@objc protocol HFlowViewDelegate: UITableViewDelegate {
    @objc
    optional func numberOfSectionsInFlowView() -> Any
    @objc
    optional func numberOfRowsInSection(_ section: Any) -> Any

    @objc
    optional func heightForHeaderInSection(_ section: Any) -> Any
    @objc
    optional func heightForFooterInSection(_ section: Any) -> Any
    @objc
    optional func heightForRowAtIndexPath(_ indexPath: IndexPath) -> Any

    @objc
    optional func edgeInsetsForHeaderInSection(_ section: Any) -> Any
    @objc
    optional func edgeInsetsForFooterInSection(_ section: Any) -> Any
    @objc
    optional func edgeInsetsForRowAtIndexPath(_ indexPath: IndexPath) -> Any
    
    @objc
    optional func minimumHeaderSpacingForSectionAt(_ section: Any) -> Any
    @objc
    optional func minimumFooterSpacingForSectionAt(_ section: Any) -> Any
    
    @objc
    optional func flowHeader(_ flow: HFlowView, inSection section: Any)
    @objc
    optional func flowFooter(_ flow: HFlowView, inSection section: Any)
    @objc
    optional func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath)

    @objc
    optional func willDisplayCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
    @objc
    optional func didSelectCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
    
    /// UIScrollViewDelegate
    @objc
    optional func flowViewDidScroll(_ scrollView: UIScrollView)
}

class HFlowView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // flow style
    private var flowStyle: HFlowStyle = .default
    
    // delay reload
    private var flowReload = HFlowReload()
    
    // flow align
    var flowAlign: HFlowAlign = .default

    private var sectionPaths = NSArray()
    private var allReuseIdentifiers = NSMutableSet()
    private var allReuseCells   = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    private var allPassedCells  = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    private var allReuseHeaders = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    private var allReuseFooters = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.setup()
    }
    
    /// Initialization method for split
    static func flowFrame(_ frame: () -> CGRect, exclusiveSections sections: () -> NSArray) -> HFlowView {
        return HFlowView(frame(), exclusiveSections: sections())
    }
    
    private convenience init(_ frame: CGRect, exclusiveSections sectionPaths: NSArray) {
        self.init(frame: UIRectIntegral(frame), style: UITableView.Style.plain)
        self.sectionPaths = sectionPaths
        self.flowStyle = .split
        self.setup()
    }
    
    private weak var flowDelegate: HFlowViewDelegate?
    override weak var delegate: UITableViewDelegate? {
        get { return super.delegate }
        set { flowDelegate = newValue as? HFlowViewDelegate }
    }
    override weak var dataSource: UITableViewDataSource? {
        get { return super.dataSource }
        set { _ = newValue }
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
        
        self.backgroundColor = .clear
        self.alwaysBounceVertical = true
        self.keyboardDismissMode = .onDrag
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false

        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0.0
        }
        
        self.estimatedRowHeight = 0.0
        self.estimatedSectionHeaderHeight = 0.0
        self.estimatedSectionFooterHeight = 0.0
        
        self.tableFooterView = UIView()
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
                self.mj_header = HFlowRefresh.refreshHeaderWithStyle(refreshHeaderStyle) {
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
    
    // Hide the system UITableViewCell's separator style
    override var separatorStyle: UITableViewCell.SeparatorStyle {
        get { return super.separatorStyle }
        set { super.separatorStyle = newValue }
    }
    
    // 多少秒内只刷新一次
    func reloadIfNeeded(_ delay: TimeInterval = 2.0) {
        if self.flowReload.isRefresh {
            self.flowReload.needRefresh = true
        }else {
            self.reloadAsync(delay)
        }
    }
    
    private func reloadAsync(_ delay: TimeInterval) {
        self.flowReload.isRefresh = true
        self.flowReload.needRefresh = false
        self.reloadFlowData()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            if self.flowReload.needRefresh {
                self.reloadAsync(delay)
            }else {
                self.flowReload.isRefresh = false
            }
        }
    }
    
    @objc
    func reloadFlowData() {
        DispatchQueue.mainAsync { [weak self] in
            self?.reloadData()
        }
    }

    /// Release method
    @objc
    func releaseFlowBlock() {
        DispatchQueue.global().async { [weak self] in
            self?.releaseAllSignal()
            self?.clearFlowState()

            DispatchQueue.main.async { [weak self] in
                self?.flowDelegate = nil
                self?.loadMoreBlock = nil
                self?.refreshBlock = nil
                self?.dataSource = nil
                self?.delegate = nil
            }
        }
    }

    private var addressValue: String {
        return String(format: "%p", self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        self.removeFromSuperview()
        self.flowDelegate = nil
        self.dataSource = nil
        self.delegate = nil
    }
    
    /// Register class
    func header(_ cls: AnyClass, _ pre: String?, _ idx: Bool, _ section: Any) -> AnyObject {
        // Unique identifier
        var identifier = (pre ?? "") + "HeaderCell" + NSStringFromClass(cls) + self.addressValue
        // Determine whether it contains an index
        identifier += idx ? "\(section)" : ""
        // Determine if there is a flow state value
        if self.flowStyle == .split, !self.sectionPaths.contains(section) {
            identifier += "\(self.flowState)"
        }
        // Register cell if not already registered
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forHeaderFooterViewReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HFlowBaseApex
        cell.section = section
        cell.isHeader = true
        cell.flow = self
        // Save cell
        self.allReuseHeaders.setObject(cell, forKey: "\(section)" as NSString)
        // Call delegate method
        var edgeInsets: UIEdgeInsets = .zero
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(section)
            let selector = #selector(delegate.edgeInsetsForHeaderInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                edgeInsets = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! UIEdgeInsets
            }
        }
        // Set properties
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        return cell
    }
    
    func footer(_ cls: AnyClass, _ pre: String?, _ idx: Bool, _ section: Any) -> AnyObject {
        // Unique identifier
        var identifier = (pre ?? "") + "FooterCell" + NSStringFromClass(cls) + self.addressValue
        // Determine whether it contains an index
        identifier += idx ? "\(section)" : ""
        // Determine if there is a flow state value
        if self.flowStyle == .split, !self.sectionPaths.contains(section) {
            identifier += "\(self.flowState)"
        }
        // Register cell if not already registered
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forHeaderFooterViewReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HFlowBaseApex
        cell.section = section
        cell.isHeader = false
        cell.flow = self
        // Save cell
        self.allReuseFooters.setObject(cell, forKey: "\(section)" as NSString)
        // Call delegate method
        var edgeInsets: UIEdgeInsets = .zero
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(section)
            let selector = #selector(delegate.edgeInsetsForFooterInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                edgeInsets = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! UIEdgeInsets
            }
        }
        // Set properties
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
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
            self.register(cls, forCellReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HFlowBaseCell
        cell.indexPath = indexPath
        cell.flow = self
        // Save cell
        self.allReuseCells.setObject(cell, forKey: indexPath.nsStringValue)
        // Call delegate method
        var edgeInsets: UIEdgeInsets = .zero
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(indexPath.section)
            let selector = #selector(delegate.edgeInsetsForRowAtIndexPath(_:))
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
    
    /// UITableViewDatasource  & delegate
    private func flowSplitPrefix(_ section: Any) -> String {
        var prefix = ""
        if self.flowStyle == .split {
            if self.sectionPaths.contains(section) {
                let idx: Int = self.sectionPaths.index(of: section)
                prefix = kFlowExaDesignKey + "\(idx)" + "_"
            }else {
                prefix = kFlowDesignKey + "\(self.flowState)" + "_"
            }
        }
        return prefix
    }
    
    /// The following are the delegate methods for UITableView.
    func numberOfSections(in tableView: UITableView) -> Int {
        // remove cache data
        self.allReuseIdentifiers.removeAllObjects()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var items = 0
        if let delegate = self.flowDelegate {
            // Get the number of items
            let prefix = self.flowSplitPrefix(section)
            let selector = #selector(delegate.numberOfRowsInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                items = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! Int
            }
            
            // Prevents quantity from being less than 0
            items = max(items, 0)
        }
        return items
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(section)
            let selector = #selector(delegate.minimumHeaderSpacingForSectionAt(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                height = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
            } else {
                let selector = #selector(delegate.heightForHeaderInSection(_:))
                if delegate.responds(to: selector, withPre: prefix) {
                    height = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
                }
            }
            // Prevent negative size
            height = max(height, 0.0)
        }
        return height
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(section)
            let selector: Selector = #selector(delegate.minimumFooterSpacingForSectionAt(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                height = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
            } else {
                let selector = #selector(delegate.heightForFooterInSection(_:))
                if delegate.responds(to: selector, withPre: prefix) {
                    height = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
                }
            }
            // Prevent negative size
            height = max(height, 0.0)
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // The row height cannot be 0, otherwise it will crash.
        var height: CGFloat = 1.0
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(indexPath.section)
            let selector = #selector(delegate.heightForRowAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                height = delegate.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! CGFloat
            }
            // Prevent negative size
            if height <= 0 { height = 1.0 }
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Call delegate method
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(indexPath.section)
            let selector = #selector(delegate.flowRow(_:atIndexPath:))
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: self, with: indexPath, withPre: prefix)
            }
        }
        // Call cell
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HFlowBaseCell
        // Update layout
        if let cell = cell, cell.responds(to: #selector(cell.relayoutSubviews)) {
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
        // Prevent crashes
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Call delegate method
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(section)
            let selector = #selector(delegate.minimumHeaderSpacingForSectionAt(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                // Unique identifier
                let identifier = "HeaderSpaceCell" + self.addressValue + "\(section)" + "\(self.flowState)"
                // Register cell if not already registered
                if !self.allReuseIdentifiers.contains(identifier) {
                    self.allReuseIdentifiers.add(identifier)
                    self.register(HFlowBaseApex.self, forHeaderFooterViewReuseIdentifier: identifier)
                }
                // Dequeue cell
                return self.dequeueReusableHeaderFooterView(withIdentifier: identifier)
            } else {
                let selector = #selector(delegate.flowHeader(_:inSection:))
                if delegate.responds(to: selector, withPre: prefix) {
                    delegate.perform(selector, with: self, with: section, withPre: prefix)
                }
            }
        }
        // Update layout
        let cell = self.allReuseHeaders.object(forKey: "\(section)" as NSString) as? HFlowBaseApex
        if let cell = cell, cell.responds(to: #selector(cell.relayoutSubviews)) {
            cell.relayoutSubviews()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Call delegate method
        if let delegate = self.flowDelegate {
            let prefix = self.flowSplitPrefix(section)
            let selector = #selector(delegate.minimumFooterSpacingForSectionAt(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                // Unique identifier
                let identifier = "FooterSpaceCell" + self.addressValue + "\(section)" + "\(self.flowState)"
                // Register cell if not already registered
                if !self.allReuseIdentifiers.contains(identifier) {
                    self.allReuseIdentifiers.add(identifier)
                    self.register(HFlowBaseApex.self, forHeaderFooterViewReuseIdentifier: identifier)
                }
                // Dequeue cell
                return self.dequeueReusableHeaderFooterView(withIdentifier: identifier)
            } else {
                let selector = #selector(delegate.flowFooter(_:inSection:))
                if delegate.responds(to: selector, withPre: prefix) {
                    delegate.perform(selector, with: self, with: section, withPre: prefix)
                }
            }
        }
        // Update layout
        let cell = self.allReuseFooters.object(forKey: "\(section)" as NSString) as? HFlowBaseApex
        if let cell = cell, cell.responds(to: #selector(cell.relayoutSubviews)) {
            cell.relayoutSubviews()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    /// UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let delegate = self.flowDelegate else { return }
        let selector = NSSelectorFromString("flowViewDidScroll:")
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: scrollView)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // Update passed cells
        if !decelerate, self.allPassedCells.count > 5 {
            self.allPassedCells.removeAllObjects()
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk(onCompletion: {})
            KingfisherManager.shared.cache.clearMemoryCache()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Update passed cells
        if self.allPassedCells.count > 5 {
            self.allPassedCells.removeAllObjects()
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk(onCompletion: {})
            KingfisherManager.shared.cache.clearMemoryCache()
        }
    }
}

/// Signal mechanism classification
extension HFlowView {

    /// Signal block held by flowView
    var signalBlock: HFlowCellSignalBlock? {
        get { return self.getAssociatedValueForKey(&kFlowSignalKey) as? HFlowCellSignalBlock }
        set { self.setAssociateCopyValue(newValue, key: &kFlowSignalKey) }
    }
    
    /// Send a signal to the flowView
    func signalToFlowView(_ signal: HFlowSignal?, _ completion: @escaping () -> Void) {
        guard let signalBlock = self.signalBlock else { return }
        signalBlock(self, signal)
        completion()
    }

    /// Send signals to all items, items under a certain section, or a single item individually
    func signalToAllItems(_ signal: HFlowSignal?, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let flows = self.allReuseCells.objectEnumerator()?.allObjects.compactMap { $0 as? HFlowBaseCell }
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
        let items = self.numberOfRows(inSection: section)
        DispatchQueue.global(qos: .userInteractive).async {
            let group = DispatchGroup()
            DispatchQueue.concurrentPerform(iterations: items) { i in
                let cell = self.allReuseCells.object(forKey: IndexPath.nsStringValue(i, section)) as? HFlowBaseCell
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
            DispatchQueue.concurrentPerform(iterations: sections) { i in
                let header = self.allReuseHeaders.object(forKey: IndexPath.nsStringValue(0, i)) as? HFlowBaseApex
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

    /// Send signals to all footers or a single footer separately
    func signalToAllFooter(_ signal: HFlowSignal?, _ completion: @escaping () -> Void) {
        let sections = self.numberOfSections
        DispatchQueue.global(qos: .userInteractive).async {
            let group = DispatchGroup()
            DispatchQueue.concurrentPerform(iterations: sections) { i in
                let footer = self.allReuseFooters.object(forKey: IndexPath.nsStringValue(0, i)) as? HFlowBaseApex
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
        DispatchQueue.global().async {
            self.signalBlock = nil
            //release all cell
            self.allReuseCells.objectEnumerator()?.allObjects.forEach {
                ($0 as? HFlowBaseCell)?.signalBlock = nil
                ($0 as? HFlowBaseCell)?.selectBlock = nil
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
    
    /// The state represented by flowView split design
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

    /// Remove the value of a certain state
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
