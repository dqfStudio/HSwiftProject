//
//  HTableView.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/3.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private enum HTableStyle: Int {
    case `default`  //单体式设计
    case split //分体式设计
}

private var KTableDefaultTag = 1615141312

private var KDefaultPageNo = 1
private var KDefaultPageSize = 20
private var KDefaultTotalPageNo = 10000

private var KTableDesignKey = "table"
private var KTableExaDesignKey = "tableExa"

private var tableStateKey = "tableStateKey"
private var signalBlockKey = "signalBlockKey"
private var tableStateSourceKey = "tableStateSourceKey"

///refresh & loadMore block
typealias HTableRefreshBlock = () -> Void
typealias HTableLoadMoreBlock = () -> Void

///table header & footer & item block
typealias HTableHeader = (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject
typealias HTableFooter = (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject
typealias HTableRow = (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject

///split design exclusive sections block
typealias HTableSectionExclusiveBlock = () -> NSArray

///此类用于全工程刷新tableView
class HTableAppearance : NSObject {
    
    private static var hashTables = NSHashTable<AnyObject>.weakObjects()
    
    static func addTable(_ anTable: AnyObject) {
        self.hashTables.add(anTable)
    }
    static func refreshTables(_ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            //倒序执行
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
        self.init(frame: frame, style: UITableView.Style.plain)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.setup()
    }
    
    ///split设计初始化方法
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
        set { NSLog(newValue) }
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
        //保存tableView用于全局刷新
        HTableAppearance.addTable(self)
        
        //设置默认tag
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
    
    /// page number, default 1
    var pageNo: Int = KDefaultPageNo {
        didSet {
            if pageNo <= 0 {
                pageNo = KDefaultPageNo
            }
        }
    }
    
    /// page size, default 20
    var pageSize: Int = KDefaultPageSize {
        didSet {
            if pageSize <= 0 {
                pageSize = KDefaultPageSize
            }
        }
    }
    
    /// total number. default 10000
    var totalNo: Int = KDefaultTotalPageNo {
        didSet {
            if totalNo <= 0 {
                totalNo = KDefaultTotalPageNo
            }
        }
    }
    
    ///refresh header style
    var refreshHeaderStyle: HTableRefreshHeaderStyle = .gray
    
    ///load more footer style
    var refreshFooterStyle: HTableRefreshFooterStyle = .style1

    /// block to refresh data
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

    /// block to load more data
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
    
    ///设置释放的key值
    var releaseTableKey: String?

    ///设置reload的key值
    var reloadTableKey: String?

    ///block refresh & loadMore
    func beginRefreshing(_ completion: @escaping () -> Void) {
        guard self.refreshBlock != nil else { return }
        self.pageNo = 1
        self.mj_header?.beginRefreshing(completionBlock: completion)
    }

    ///stop refresh
    func endRefreshing(_ completion: @escaping () -> Void) {
        self.mj_header?.endRefreshing(completionBlock:completion)
    }
    
    func endLoadMore(_ completion: @escaping () -> Void) {
        self.mj_footer?.endRefreshing(completionBlock:completion)
    }
    
    ///bounce method
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
    
    //屏蔽系统UITableViewCell的间隔线style
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

    /// release method
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
    
    /// register class
    func dequeueReusableHeaderWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, section: Int) -> AnyObject {
        var cell: HTableBaseApex
        // 唯一标识符
        var identifier = (pre ?? "") + "HeaderCell" + NSStringFromClass(cls) + self.addressValue
        // 判断是否包含index
        identifier += idx ? "\(section)" : ""
        // 判断是否有tuple状态值
        if self.tableStyle == .split, let sectionPaths = self.sectionPaths, !sectionPaths.contains(section) {
            identifier += "\(self.tableState)"
        }
        // 判断是否已经加载过
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
        //保存cell
        self.allReuseHeaders.setObject(cell, forKey: "\(section)" as NSString)
        //调用代理方法
        if let delegate = self.tableDelegate {
            let prefix = self.prefixWithSection(section)
            let selector: Selector = #selector(delegate.edgeInsetsForHeaderInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                let edgeInsets = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! UIEdgeInsets
                //设置属性
                if edgeInsets != .zero, cell.responds(to: #selector(setter: cell.edgeInsets)) {
                    cell.edgeInsets = edgeInsets
                }
            }
        }
        return cell
    }
    
    func dequeueReusableFooterWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, section: Int) -> AnyObject {
        var cell: HTableBaseApex
        // 唯一标识符
        var identifier = (pre ?? "") + "FooterCell" + NSStringFromClass(cls) + self.addressValue
        // 判断是否包含index
        identifier += idx ? "\(section)" : ""
        // 判断是否有tuple状态值
        if self.tableStyle == .split, let sectionPaths = self.sectionPaths, !sectionPaths.contains(section) {
            identifier += "\(self.tableState)"
        }
        // 判断是否已经加载过
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
        //保存cell
        self.allReuseFooters.setObject(cell, forKey: "\(section)" as NSString)
        //调用代理方法
        if let delegate = self.tableDelegate {
            let prefix = self.prefixWithSection(section)
            let selector = #selector(delegate.edgeInsetsForFooterInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                let edgeInsets = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! UIEdgeInsets
                //设置属性
                if edgeInsets != .zero, cell.responds(to: #selector(setter: cell.edgeInsets)) {
                    cell.edgeInsets = edgeInsets
                }
            }
        }
        return cell
    }

    func dequeueReusableCellWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, idxPath: IndexPath) -> AnyObject {
        var cell: HTableBaseCell
        // 唯一标识符
        var identifier = (pre ?? "") + "ItemCell" + NSStringFromClass(cls) + self.addressValue
        // 判断是否包含index
        identifier += idx ? idxPath.stringValue : ""
        // 判断是否有tuple状态值
        if self.tableStyle == .split, let sectionPaths = self.sectionPaths, !sectionPaths.contains(idxPath.section) {
            identifier += "\(self.tableState)"
        }
        // 判断是否已经加载过
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
        //保存cell
        self.allReuseCells.setObject(cell, forKey: idxPath.nsStringValue)
        //调用代理方法
        if let delegate = self.tableDelegate {
            let prefix = self.prefixWithSection(idxPath.section)
            let selector = #selector(delegate.edgeInsetsForRowAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                let edgeInsets = delegate.performWithUnretainedValue(selector, with: idxPath, withPre: prefix) as! UIEdgeInsets
                //设置属性
                if edgeInsets != .zero, cell.responds(to: #selector(setter: cell.edgeInsets)) {
                    cell.edgeInsets = edgeInsets
                }
            }
        }
        return cell
    }
    
    /// UITableViewDatasource  & delegate
    private func prefixWithSection(_ section: Int) -> String {
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
    
    ///以下为UITableView的代理方法
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.tableStyle {
        case .default:
            var sections = 0
            if let delegate = self.tableDelegate {
                let prefix = ""
                let selector = #selector(delegate.numberOfSectionsInTableView)
                if delegate.responds(to: selector, withPre: prefix) {
                    sections = delegate.performWithUnretainedValue(selector, withPre: prefix) as! Int
                }
                // 防止大小为负数
                sections = max(sections, 0)
            }
            return sections
        case .split:
            var sections = 0
            if let delegate = self.tableDelegate {
                let prefix = KTableDesignKey + "\(self.tableState)" + "_"
                let selector = #selector(delegate.numberOfSectionsInTableView)
                if delegate.responds(to: selector, withPre: prefix) {
                    sections = delegate.performWithUnretainedValue(selector, withPre: prefix) as! Int
                }
                // 防止大小为负数
                sections = max(sections, 0)
            }
            return sections
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var items = 0
        if let delegate = self.tableDelegate {
            let prefix = self.prefixWithSection(section)
            let selector: Selector = #selector(delegate.numberOfRowsInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                items = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! Int
            }
            // 防止大小为负数
            items = max(items, 0)
        }
        return items
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        if let delegate = self.tableDelegate {
            let prefix = self.prefixWithSection(section)
            let selector = #selector(delegate.heightForHeaderInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                height = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
            }
            // 防止大小为负数
            height = max(height, 0.0)
        }
        return height
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        if let delegate = self.tableDelegate {
            let prefix = self.prefixWithSection(section)
            let selector = #selector(delegate.heightForFooterInSection(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                height = delegate.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
            }
            // 防止大小为负数
            height = max(height, 0.0)
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 1.0 //row高度不能为0，否则会崩溃
        if let delegate = self.tableDelegate {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(delegate.heightForRowAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                height = delegate.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! CGFloat
            }
            // 防止大小为负数
            if height <= 0 { height = 1.0 }
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //调用代理方法
        if let delegate = self.tableDelegate {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector: Selector = #selector(delegate.tableRow(_:atIndexPath:))
            let itemBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) in
                return self.dequeueReusableCellWithClass(cls, iblk: iblk, pre: pre, idx: idx, idxPath: indexPath)
            }
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: itemBlock, with: indexPath, withPre: prefix)
            }
        }
        //调用cell
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HTableBaseCell
        //更新布局
        if let cell = cell, cell.responds(to: #selector(cell.relayoutSubviews)) {
            cell.relayoutSubviews()
        }
        //防止崩溃
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //调用代理方法
        if let delegate = self.tableDelegate {
            let prefix = self.prefixWithSection(section)
            let selector: Selector = #selector(delegate.tableHeader(_:inSection:))
            let headerBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject in
                return self.dequeueReusableHeaderWithClass(cls, iblk: iblk, pre: pre, idx: idx, section: section)
            }
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: headerBlock, with: section, withPre: prefix)
            }
        }
        //更新布局
        let cell = self.allReuseHeaders.object(forKey: "\(section)" as NSString) as? HTableBaseApex
        if let cell = cell, cell.responds(to: #selector(cell.relayoutSubviews)) {
            cell.relayoutSubviews()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //调用代理方法
        if let delegate = self.tableDelegate {
            let prefix = self.prefixWithSection(section)
            let selector: Selector = #selector(delegate.tableFooter(_:inSection:))
            let footerBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject in
                return self.dequeueReusableFooterWithClass(cls, iblk: iblk, pre: pre, idx: idx, section: section)
            }
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: footerBlock, with: section, withPre: prefix)
            }
        }
        //更新布局
        let cell = self.allReuseFooters.object(forKey: "\(section)" as NSString) as? HTableBaseApex
        if let cell = cell, cell.responds(to: #selector(cell.relayoutSubviews)) {
            cell.relayoutSubviews()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let delegate = self.tableDelegate else { return }
        let prefix = self.prefixWithSection(indexPath.section)
        let selector = #selector(delegate.willDisplayCell(_:atIndexPath:))
        if delegate.responds(to: selector, withPre: prefix) {
            delegate.perform(selector, with: cell, with: indexPath, withPre: prefix)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = self.tableDelegate else { return }
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? HTableBaseCell
        if let cell = cell, cell.didSelectCell != nil {
            cell.didSelectCell!(cell, indexPath)
        }else {
            let prefix = self.prefixWithSection(indexPath.section)
            let selector = #selector(delegate.didSelectRowAtIndexPath(_:))
            if delegate.responds(to: selector, withPre: prefix) {
                delegate.perform(selector, with: indexPath, withPre: prefix)
            }
        }
    }
    
}

/// 信号机制分类
extension HTableView {

    ///tableView持有的信号block
    var signalBlock: HTableCellSignalBlock? {
        get {
            return self.getAssociatedValueForKey(&signalBlockKey) as? HTableCellSignalBlock
        }
        set {
            self.setAssociateCopyValue(newValue, key: &signalBlockKey)
        }
    }
    
    ///给tableView发送信号
    func signalToTableView(_ signal: HTableSignal?, _ completion: @escaping () -> Void) {
        guard let signalBlock = self.signalBlock else { return }
        signalBlock(self, signal)
        completion()
    }

    ///给所有item、某个section下的item或单独某个item发送信号
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
        DispatchQueue.global(qos: .userInteractive).async {
            let items = self.numberOfRows(inSection: section)
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

    ///给所有header或单独某个header发送信号
    func signalToAllHeader(_ signal: HTableSignal?, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let sections = self.numberOfSections
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

    ///给所有footer或单独某个footer发送信号
    func signalToAllFooter(_ signal: HTableSignal?, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let sections = self.numberOfSections
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

    ///释放所有信号block
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

    ///根据传入的row和section获取cell或indexPath
    func cell(_ row: Int, _ section: Int) -> AnyObject? {
        return self.allReuseCells.object(forKey: IndexPath.nsStringValue(row, section))
    }
    func indexPath(_ row: Int, _ section: Int) -> IndexPath {
        return IndexPath(row: row, section: section)
    }

}

private var KTableStateKey = "_table_"

/// split设计数据存储分类
extension HTableView {

    private var tableStateSource: NSMutableDictionary {
        get {
            if let dict = self.getAssociatedValueForKey(&tableStateSourceKey) as? NSMutableDictionary {
                return dict
            } else {
                let dict = NSMutableDictionary()
                self.setAssociateValue(dict, key: &tableStateSourceKey)
                return dict
            }
        }
    }
    
    ///tableView分体式设计所表示的状态
    var tableState: Int {
        get {
            let value = self.getAssociatedValueForKey(&tableStateKey) as? NSNumber ?? NSNumber(value: 0)
            return value.intValue
        }
        set {
            if newValue != self.tableState {
                self.setAssociateValue(NSNumber(value: newValue), key: &tableStateKey)
                self.reloadData()
            }
        }
    }

    ///向某个状态或当前状态添加一个值
    func setObject(_ anObject: Any, forKey aKey: String) {
        self.setObject(anObject, forKey: aKey, state: self.tableState)
    }
    
    func setObject(_ anObject: Any, forKey aKey: String, state tableState: Int) {
        let key: NSString = aKey + KTableStateKey + "\(tableState)" as NSString
        self.tableStateSource.setObject(anObject, forKey: key)
    }

    ///获取某个状态或当前状态的一个值
    func objectForKey(_ aKey: String) -> Any? {
        return self.objectForKey(aKey, state: self.tableState)
    }
    
    func objectForKey(_ aKey: String, state tableState: Int) -> Any? {
        let key: NSString = aKey + KTableStateKey + "\(tableState)" as NSString
        return self.tableStateSource.object(forKey: key)
    }

    ///删除某个状态或当前状态下的一个值
    func removeObjectForKey(_ aKey: String) {
        self.removeObjectForKey(aKey, state: self.tableState)
    }
    
    func removeObjectForKey(_ aKey: String, state tableState: Int) {
        let key: NSString = aKey + KTableStateKey + "\(tableState)" as NSString
        self.tableStateSource.removeObject(forKey: key)
    }

    ///删除某个状态或当前状态的值
    func removeStateObject() {
        self.removeObjectForState(self.tableState)
    }
    
    func removeObjectForState(_ tableState: Int) {
        let key = KTableStateKey + "\(tableState)"
        for (aKey, _) in self.tableStateSource.reversed() {
            let aKey = aKey as! String
            if key == aKey {
                self.tableStateSource.removeObject(forKey: aKey)
            }
        }
        
    }

    ///删除所有状态的值
    func clearTableState() {
        if self.tableStateSource.count > 0 {
            self.tableStateSource.removeAllObjects()
        }
    }

}
