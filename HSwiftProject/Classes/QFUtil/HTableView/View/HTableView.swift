//
//  HTableView.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/3.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private enum HTableStyle: Int {
    case `default`  //Singleton design
    case split //Split design
}

var KTableDefaultTag = 1615141312

private var KTablePageNo = 1
private var KTablePageSize = 20
private var KTableTotalPageNo = 10000

private var KTableDesignKey = "table"
private var KTableExaDesignKey = "tableExa"

private var KTableStateKey = "tableStateKey"
private var KTableSignalKey = "tableSignalKey"
private var KTableStateSourceKey = "tableStateSourceKey"

/// Refresh & LoadMore block
typealias HTableRefreshBlock = () -> Void
typealias HTableLoadMoreBlock = () -> Void

/// Table header & Footer & Item block
typealias HTableHeader = (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject
typealias HTableFooter = (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject
typealias HTableRow = (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject

/// Split design exclusive sections block
typealias HTableSectionExclusiveBlock = () -> NSArray

/// This class is used for refreshing tableView throughout the project.
class HTableAppearance : NSObject {
    
    private static var hashTables = NSHashTable<AnyObject>.weakObjects()
    
    static func addTable(_ anTable: AnyObject) {
        self.hashTables.add(anTable)
    }
    static func refreshTables(_ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Execute in reverse order
            let tables = self.hashTables.allObjects.reversed().compactMap { $0 as? HTableView }
            tables.forEach { $0.reloadTableData() }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

@objc protocol HTableViewDelegate : UITableViewDelegate {
    @objc
    optional func numberOfSectionsInTableView() -> Any
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
    optional func tableHeader(_ headerBlock: Any, inSection section: Any)
    @objc
    optional func tableFooter(_ footerBlock: Any, inSection section: Any)
    @objc
    optional func tableRow(_ itemBlock: Any, atIndexPath indexPath: IndexPath)

    @objc
    optional func willDisplayCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
    @objc
    optional func didSelectRowAtIndexPath(_ indexPath: IndexPath)
}

class HTableView : UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private var tableStyle: HTableStyle = .default

     private var allReuseIdentifiers: NSMutableSet = NSMutableSet()
     private var allReuseCells   = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
     private var allReuseHeaders = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
     private var allReuseFooters = NSMapTable<NSString, AnyObject>.strongToWeakObjects()

     private var sectionPaths: NSArray?
    
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
    static func tableFrame(_ frame: () -> CGRect, exclusiveSections sections: HTableSectionExclusiveBlock) -> HTableView {
        return HTableView(frame(), exclusiveSections: sections())
    }
    
    private convenience init(_ frame: CGRect, exclusiveSections sectionPaths: NSArray) {
        self.init(frame: UIRectIntegral(frame), style: UITableView.Style.plain)
        self.tableStyle = .split
        self.sectionPaths = sectionPaths
        self.setup()
    }
    
    private weak var tableDelegate: HTableViewDelegate?
    override weak var delegate: UITableViewDelegate? {
        get { return super.delegate }
        set { tableDelegate = newValue as? HTableViewDelegate }
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
    
    private func setup() {
        // Save tableView for global refresh
        HTableAppearance.addTable(self)
        
        // Set default tag
        self.tag = KTableDefaultTag
        
        self.alwaysBounceVertical = true
        self.backgroundColor = UIColor.clear
        self.keyboardDismissMode = .onDrag
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false

        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        
        self.estimatedRowHeight = 0
        self.estimatedSectionHeaderHeight = 0
        self.estimatedSectionFooterHeight = 0
        
        self.tableFooterView = UIView()
        super.delegate = self
        super.dataSource = self
    }
    
    /// Page number, Default 1
    var pageNo: Int = KTablePageNo {
        didSet {
            if pageNo <= 0 {
                pageNo = KTablePageNo
            }
        }
    }
    
    /// Page size, Default 20
    var pageSize: Int = KTablePageSize {
        didSet {
            if pageSize <= 0 {
                pageSize = KTablePageSize
            }
        }
    }
    
    /// Total number. Default 10000
    var totalNo: Int = KTableTotalPageNo {
        didSet {
            if totalNo <= 0 {
                totalNo = KTableTotalPageNo
            }
        }
    }
    
    /// Refresh header style
    var refreshHeaderStyle: HTableRefreshHeaderStyle = .gray
    
    /// Load more footer style
    var refreshFooterStyle: HTableRefreshFooterStyle = .style1

    /// Block to refresh data
    var refreshBlock: HTableRefreshBlock? {
        didSet {
            if let refreshBlock = refreshBlock {
                self.mj_header = HTableRefresh.refreshHeaderWithStyle(refreshHeaderStyle) {
                    self.pageNo = 1
                    refreshBlock()
                }
            } else {
                self.mj_header = nil
            }
        }
    }

    /// Block to load more data
    var loadMoreBlock: HTableLoadMoreBlock? {
        didSet {
            if let loadMoreBlock = loadMoreBlock {
                self.pageNo = 1
                self.mj_footer = HTableRefresh.refreshFooterWithStyle(refreshFooterStyle) { [weak self] in
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
    var releaseTableKey: String?

    /// Set the key value for reload
    var reloadTableKey: String?

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
    
    @objc
    func reloadTableData() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }

    /// Release method
    @objc
    func releaseTableBlock() {
        DispatchQueue.global().async {
            self.releaseAllSignal()
            self.clearTableState()

            self.tableDelegate = nil
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
    func dequeueReusableHeaderWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, section: Int) -> AnyObject {
        var cell: HTableBaseApex
        // Unique identifier
        var identifier = (pre ?? "") + "HeaderCell" + NSStringFromClass(cls) + self.addressValue
        // Determine whether it contains an index
        identifier += idx ? "\(section)" : ""
        // Determine if there is a table state value
        if self.tableStyle == .split, let sectionPaths = self.sectionPaths, !sectionPaths.contains(section) {
            identifier += "\(self.tableState)"
        }
        // Determine whether it has been loaded
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forHeaderFooterViewReuseIdentifier: identifier)
            cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HTableBaseApex
            cell.table = self
            cell.section = section
            cell.isHeader = true
            //init method
            if let iblk = iblk as? HTableCellInitBlock {
                iblk(cell)
            }
        }else {
            cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HTableBaseApex
        }
        // Save cell
        self.allReuseHeaders.setObject(cell, forKey: "\(section)" as NSString)
        // Call delegate method
        var edgeInsets: UIEdgeInsets = .zero
        if let delegate = self.tableDelegate {
            let prefix = self.tableSplitPrefix(withSection: section)
            let selector: Selector = #selector(delegate.edgeInsetsForHeaderInSection(_:))
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
    
    func dequeueReusableFooterWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, section: Int) -> AnyObject {
        var cell: HTableBaseApex
        // Unique identifier
        var identifier = (pre ?? "") + "FooterCell" + NSStringFromClass(cls) + self.addressValue
        // Determine whether it contains an index
        identifier += idx ? "\(section)" : ""
        // Determine if there is a table state value
        if self.tableStyle == .split, let sectionPaths = self.sectionPaths, !sectionPaths.contains(section) {
            identifier += "\(self.tableState)"
        }
        // Determine whether it has been loaded
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forHeaderFooterViewReuseIdentifier: identifier)
            cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HTableBaseApex
            cell.table = self
            cell.section = section
            cell.isHeader = true
            //init method
            if let iblk = iblk as? HTableCellInitBlock {
                iblk(cell)
            }
        }else {
            cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HTableBaseApex
        }
        // Save cell
        self.allReuseFooters.setObject(cell, forKey: "\(section)" as NSString)
        // Call delegate method
        var edgeInsets: UIEdgeInsets = .zero
        if let delegate = self.tableDelegate {
            let prefix = self.tableSplitPrefix(withSection: section)
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

    func dequeueReusableCellWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, idxPath: IndexPath) -> AnyObject {
        var cell: HTableBaseCell
        // Unique identifier
        var identifier = (pre ?? "") + "ItemCell" + NSStringFromClass(cls) + self.addressValue
        // Determine whether it contains an index
        identifier += idx ? idxPath.stringValue : ""
        // Determine if there is a table state value
        if self.tableStyle == .split, let sectionPaths = self.sectionPaths, !sectionPaths.contains(idxPath.section) {
            identifier += "\(self.tableState)"
        }
        // Determine whether it has been loaded
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forCellReuseIdentifier: identifier)
            cell = self.dequeueReusableCell(withIdentifier: identifier, for: idxPath) as! HTableBaseCell
            cell.table = self
            cell.indexPath = idxPath
            //init method
            if let iblk = iblk as? HTableCellInitBlock {
                iblk(cell)
            }
        }else {
            cell = self.dequeueReusableCell(withIdentifier: identifier, for: idxPath) as! HTableBaseCell
        }
        // Save cell
        self.allReuseCells.setObject(cell, forKey: idxPath.nsStringValue)
        // Call delegate method
        var edgeInsets: UIEdgeInsets = .zero
        if let delegate = self.tableDelegate {
            let prefix = self.tableSplitPrefix(withSection: idxPath.section)
            let selector = #selector(delegate.edgeInsetsForRowAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                edgeInsets = delegate.performWithUnretainedValue(selector, with: idxPath, withPre: prefix) as! UIEdgeInsets
            }
        }
        // Set properties
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        return cell
    }
    
    /// UITableViewDatasource  & delegate
    private func tableSplitPrefix(withSection section: Int) -> String {
        var prefix = ""
        if self.tableStyle == .split {
            if let sectionPaths = self.sectionPaths, sectionPaths.contains(section) {
                let idx: Int = sectionPaths.index(of: section)
                prefix = KTableExaDesignKey + "\(idx)" + "_"
            }else {
                prefix = KTableDesignKey + "\(self.tableState)" + "_"
            }
        }
        return prefix
    }
    
    /// The following are the delegate methods for UITableView.
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.tableStyle {
        case .default:
            var sections = 1
            if let delegate = self.tableDelegate {
                let prefix = ""
                let selector = #selector(delegate.numberOfSectionsInTableView)
                if delegate.responds(to: selector, withPre: prefix) {
                    sections = delegate.performWithUnretainedValue(selector, withPre: prefix) as! Int
                }
                // Prevents quantity from being less than 1
                sections = max(sections, 1)
            }
            return sections
        case .split:
            var sections = 1
            if let delegate = self.tableDelegate {
                let prefix = KTableDesignKey + "\(self.tableState)" + "_"
                let selector = #selector(delegate.numberOfSectionsInTableView)
                if delegate.responds(to: selector, withPre: prefix) {
                    sections = delegate.performWithUnretainedValue(selector, withPre: prefix) as! Int
                }
                // Prevents quantity from being less than 1
                sections = max(sections, 1)
            }
            return sections
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var items = 0
        if let delegate = self.tableDelegate {
            let prefix = self.tableSplitPrefix(withSection: section)
            let selector: Selector = #selector(delegate.numberOfRowsInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                items = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! Int
            }
            // Prevent negative size
            items = max(items, 0)
        }
        return items
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        if let delegate = self.tableDelegate {
            let prefix = self.tableSplitPrefix(withSection: section)
            let selector = #selector(delegate.heightForHeaderInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                height = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
            }
            // Prevent negative size
            height = max(height, 0.0)
        }
        return height
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        if let delegate = self.tableDelegate {
            let prefix = self.tableSplitPrefix(withSection: section)
            let selector = #selector(delegate.heightForFooterInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                height = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
            }
            // Prevent negative size
            height = max(height, 0.0)
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 1.0 // The row height cannot be 0, otherwise it will crash.
        if let delegate = self.tableDelegate {
            let prefix = self.tableSplitPrefix(withSection: indexPath.section)
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
        if let delegate = self.tableDelegate {
            let prefix = self.tableSplitPrefix(withSection: indexPath.section)
            let selector: Selector = #selector(delegate.tableRow(_:atIndexPath:))
            let itemBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) in
                return self.dequeueReusableCellWithClass(cls, iblk: iblk, pre: pre, idx: idx, idxPath: indexPath)
            }
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: itemBlock, with: indexPath, withPre: prefix)
            }
        }
        // Call cell
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HTableBaseCell
        // Update layout
        if let cell = cell, cell.responds(to: #selector(cell.relayoutSubviews)) {
            cell.relayoutSubviews()
        }
        // Prevent crashes
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Call delegate method
        if let delegate = self.tableDelegate {
            let prefix = self.tableSplitPrefix(withSection: section)
            let selector: Selector = #selector(delegate.tableHeader(_:inSection:))
            let headerBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject in
                return self.dequeueReusableHeaderWithClass(cls, iblk: iblk, pre: pre, idx: idx, section: section)
            }
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: headerBlock, with: section, withPre: prefix)
            }
        }
        // Update layout
        let cell = self.allReuseHeaders.object(forKey: "\(section)" as NSString) as? HTableBaseApex
        if let cell = cell, cell.responds(to: #selector(cell.relayoutSubviews)) {
            cell.relayoutSubviews()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Call delegate method
        if let delegate = self.tableDelegate {
            let prefix = self.tableSplitPrefix(withSection: section)
            let selector: Selector = #selector(delegate.tableFooter(_:inSection:))
            let footerBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject in
                return self.dequeueReusableFooterWithClass(cls, iblk: iblk, pre: pre, idx: idx, section: section)
            }
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: footerBlock, with: section, withPre: prefix)
            }
        }
        // Update layout
        let cell = self.allReuseFooters.object(forKey: "\(section)" as NSString) as? HTableBaseApex
        if let cell = cell, cell.responds(to: #selector(cell.relayoutSubviews)) {
            cell.relayoutSubviews()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let delegate = self.tableDelegate else { return }
        let prefix = self.tableSplitPrefix(withSection: indexPath.section)
        let selector = #selector(delegate.willDisplayCell(_:atIndexPath:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: cell, with: indexPath, withPre: prefix)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = self.tableDelegate else { return }
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HTableBaseCell
        if let cell = cell, cell.selectBlock != nil {
            cell.selectBlock!(cell, indexPath)
        }else {
            let prefix = self.tableSplitPrefix(withSection: indexPath.section)
            let selector = #selector(delegate.didSelectRowAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: indexPath, withPre: prefix)
            }
        }
    }
    
}

/// Signal mechanism classification
extension HTableView {

    /// Signal block held by tableView
    var signalBlock: HTableCellSignalBlock? {
        get { return self.getAssociatedValueForKey(&KTableSignalKey) as? HTableCellSignalBlock }
        set { self.setAssociateCopyValue(newValue, key: &KTableSignalKey) }
    }
    
    /// Send a signal to the tableView
    func signalToTableView(_ signal: HTableSignal?, _ completion: @escaping () -> Void) {
        guard let signalBlock = self.signalBlock else { return }
        signalBlock(self, signal)
        completion()
    }

    /// Send signals to all items, items under a certain section, or a single item individually
    func signalToAllItems(_ signal: HTableSignal?, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let tables = self.allReuseCells.objectEnumerator()?.allObjects.compactMap { $0 as? HTableBaseCell }
            tables?.forEach { cell in
                DispatchQueue.main.async {
                    cell.signalBlock?(cell, signal)
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func signal(_ signal: HTableSignal?, itemSection section: Int, _ completion: @escaping () -> Void) {
        let items = self.numberOfRows(inSection: section)
        DispatchQueue.global(qos: .userInteractive).async {
            let group = DispatchGroup()
            DispatchQueue.concurrentPerform(iterations: items) { i in
                let cell = self.allReuseCells.object(forKey: IndexPath.nsStringValue(i, section)) as? HTableBaseCell
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

    func signal(_ signal: HTableSignal?, toRow row: Int, inSection section: Int, _ completion: @escaping () -> Void) {
        let cell = self.allReuseCells.object(forKey: IndexPath.nsStringValue(row, section)) as? HTableBaseCell
        if let cell = cell, let signalBlock = cell.signalBlock {
            signalBlock(cell, signal)
        }
        completion()
    }

    /// Send signals to all headers or a single header individually
    func signalToAllHeader(_ signal: HTableSignal?, _ completion: @escaping () -> Void) {
        let sections = self.numberOfSections
        DispatchQueue.global(qos: .userInteractive).async {
            let group = DispatchGroup()
            DispatchQueue.concurrentPerform(iterations: sections) { i in
                let header = self.allReuseHeaders.object(forKey: IndexPath.nsStringValue(0, i)) as? HTableBaseApex
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

    func signal(_ signal: HTableSignal?, headerSection section: Int, _ completion: @escaping () -> Void) {
        let header = self.allReuseHeaders.object(forKey: IndexPath.nsStringValue(0, section)) as? HTableBaseApex
        if let header = header, let signalBlock = header.signalBlock {
            signalBlock(header, signal)
        }
        completion()
    }

    /// Send signals to all footers or a single footer separately
    func signalToAllFooter(_ signal: HTableSignal?, _ completion: @escaping () -> Void) {
        let sections = self.numberOfSections
        DispatchQueue.global(qos: .userInteractive).async {
            let group = DispatchGroup()
            DispatchQueue.concurrentPerform(iterations: sections) { i in
                let footer = self.allReuseFooters.object(forKey: IndexPath.nsStringValue(0, i)) as? HTableBaseApex
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

    func signal(_ signal: HTableSignal?, footerSection section: Int, _ completion: @escaping () -> Void) {
        let footer = self.allReuseFooters.object(forKey: IndexPath.nsStringValue(0, section)) as? HTableBaseApex
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
            self.allReuseCells.objectEnumerator()?.allObjects.forEach { ($0 as? HTableBaseCell)?.signalBlock = nil }
            //release all header
            self.allReuseHeaders.objectEnumerator()?.allObjects.forEach { ($0 as? HTableBaseApex)?.signalBlock = nil }
            //release all footer
            self.allReuseFooters.objectEnumerator()?.allObjects.forEach { ($0 as? HTableBaseApex)?.signalBlock = nil }
        }
    }

    /// Get cell or indexPath based on the given row and section
    func cell(_ row: Int, _ section: Int) -> AnyObject? {
        return self.allReuseCells.object(forKey: IndexPath.nsStringValue(row, section))
    }
    func indexPath(_ row: Int, _ section: Int) -> IndexPath {
        return IndexPath(row: row, section: section)
    }

}

private var Table_State_Key = "_table_"

/// Design data storage category for split
extension HTableView {

    private var tableStateSource: NSMutableDictionary {
        get {
            if let dict = self.getAssociatedValueForKey(&KTableStateSourceKey) as? NSMutableDictionary {
                return dict
            } else {
                let dict = NSMutableDictionary()
                self.setAssociateValue(dict, key: &KTableStateSourceKey)
                return dict
            }
        }
    }
    
    /// The state represented by tableView split design
    var tableState: Int {
        get {
            let value = self.getAssociatedValueForKey(&KTableStateKey) as? NSNumber ?? NSNumber(value: 0)
            return value.intValue
        }
        set {
            if newValue != self.tableState {
                self.setAssociateValue(NSNumber(value: newValue), key: &KTableStateKey)
                self.reloadData()
            }
        }
    }

    /// Add a value to a certain state
    func setObject(_ anObject: Any, forKey aKey: String, state: Int) {
        let key = aKey + Table_State_Key + "\(state)"
        self.tableStateSource.setObject(anObject, forKey: key as NSCopying)
    }

    /// Get a value of a certain state
    func object(forKey aKey: String, state: Int) -> Any? {
        let key = aKey + Table_State_Key + "\(state)"
        return self.tableStateSource.object(forKey: key)
    }

    /// Remove a value in a certain state
    func removeObject(forKey aKey: String, state: Int) {
        let key = aKey + Table_State_Key + "\(state)"
        self.tableStateSource.removeObject(forKey: key)
    }

    /// Remove the value of a certain state
    func removeObject(forState state: Int) {
        let key = Table_State_Key + "\(state)"
        for (aKey, _) in self.tableStateSource.reversed() {
            let aKey = aKey as! String
            if key == aKey {
                self.tableStateSource.removeObject(forKey: aKey)
            }
        }
        
    }

    /// Remove all values ​​of the state
    func clearTableState() {
        self.tableStateSource.removeAllObjects()
    }

}
