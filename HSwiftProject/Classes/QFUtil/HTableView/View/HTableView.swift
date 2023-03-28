//
//  HTableView.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/3.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private enum HTableStyle: Int {
    case `default`  //单体式设计
    case split //分体式设计
}

///自定义类型
typealias HTableState = Int

private var KTableDefaultTag  = 1615141312

private var KDefaultPageSize  = 20
private var KTableDesignKey   = "table"
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
    static func enumerateTables(_ completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            //倒序执行
            for item in self.hashTables.allObjects.reversed() {
                let table = item as! HTableView
                table.reloadData()
            }
            completion()
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor.clear
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
    var refreshHeaderStyle: HTableRefreshHeaderStyle = .gray
    
    ///load more footer style
    var refreshFooterStyle: HTableRefreshFooterStyle = .style1

    private var _refreshBlock: HTableRefreshBlock?
    /// block to refresh data
    var refreshBlock: HTableRefreshBlock? {
        get {
            return _refreshBlock
        }
        set {
            _refreshBlock = newValue
            if _refreshBlock != nil {
                //@www
                self.mj_header = HTableRefresh.refreshHeaderWithStyle(refreshHeaderStyle) {
                    //@sss
                    self.pageNo = 1
                    self._refreshBlock!()
                }
            }else {
                self.mj_header = nil
            }
        }
    }
            
    private var _loadMoreBlock: HTableLoadMoreBlock?
    /// block to load more data
    var loadMoreBlock: HTableLoadMoreBlock? {
        get {
            return _loadMoreBlock
        }
        set {
            _loadMoreBlock = newValue
            if _loadMoreBlock != nil {
                self.pageNo = 1
                //@www
                self.mj_footer = HTableRefresh.refreshFooterWithStyle(refreshFooterStyle) {
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
    
    private var _releaseTableKey: String?
    ///设置释放的key值
    var releaseTableKey: String? {
        get {
            return _releaseTableKey
        }
        set {
            if _releaseTableKey != newValue {
                if _releaseTableKey != nil && newValue != nil {
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(_releaseTableKey!), object: nil)
                }
                _releaseTableKey = newValue
                if _releaseTableKey != nil {
                    NotificationCenter.default.addObserver(self, selector: #selector(releaseTableBlock), name: NSNotification.Name(_releaseTableKey!), object: nil)
                }
            }
        }
    }

    private var _reloadTableKey: String?
    ///设置reload的key值
    var reloadTableKey: String? {
        get {
            return _reloadTableKey
        }
        set {
            if _reloadTableKey != newValue {
                if _reloadTableKey != nil && reloadTableKey != nil {
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(_reloadTableKey!), object: nil)
                }
                _reloadTableKey = newValue
                if _reloadTableKey != nil {
                    NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: NSNotification.Name(_reloadTableKey!), object: nil)
                }
            }
        }
    }

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
    
    //屏蔽系统UITableViewCell的间隔线style
    override var separatorStyle: UITableViewCell.SeparatorStyle {
        get {
            return super.separatorStyle
        }
        set {
            super.separatorStyle = newValue
        }
    }
    
    @objc
    private func reloadTableData() {
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

            if self.tableDelegate != nil { self.tableDelegate = nil }
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
    func dequeueReusableHeaderWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, section: Int) -> AnyObject {
        var cell: HTableBaseApex
        var identifier = NSStringFromClass(cls)
        identifier = identifier + self.addressValue
        identifier = identifier + "HeaderCell"
        if self.tableStyle == .split && self.sectionPaths?.contains(section) == false {
            identifier = identifier + "\(self.tableState)"
        }
        if (pre != nil) { identifier = identifier + pre! }
        if idx { identifier = identifier + "\(section)" }
        if self.allReuseIdentifiers.contains(identifier) == false {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forHeaderFooterViewReuseIdentifier: identifier)
            cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HTableBaseApex
            cell.table = self
            cell.section = section
            cell.isHeader = true
            //init method
            if iblk != nil {
                let initHeaderBlock: HTableCellInitBlock = iblk as! HTableCellInitBlock
                initHeaderBlock(cell)
            }
        }else {
            cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HTableBaseApex
        }
        //保存cell
        self.allReuseHeaders.setObject(cell, forKey: "\(section)" as NSString)
        //调用代理方法
        var edgeInsets: UIEdgeInsets = UIEdgeInsetsZero
        let prefix = self.prefixWithSection(section)
        let selector: Selector = #selector(self.tableDelegate!.edgeInsetsForHeaderInSection(_:))
        if self.tableDelegate!.responds(to: selector, withPre: prefix) {
            edgeInsets = self.tableDelegate!.performWithUnretainedValue(selector, with: section, withPre: prefix) as! UIEdgeInsets
        }
        //设置属性
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        return cell
    }
    
    func dequeueReusableFooterWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, section: Int) -> AnyObject {
        var cell: HTableBaseApex
        var identifier = NSStringFromClass(cls)
        identifier = identifier + self.addressValue
        identifier = identifier + "FooterCell"
        if self.tableStyle == .split && self.sectionPaths?.contains(section) == false {
            identifier = identifier + "\(self.tableState)"
        }
        if (pre != nil) { identifier = identifier + pre! }
        if idx { identifier = identifier + "\(section)" }
        if self.allReuseIdentifiers.contains(identifier) == false {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forHeaderFooterViewReuseIdentifier: identifier)
            cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HTableBaseApex
            cell.table = self
            cell.section = section
            cell.isHeader = true
            //init method
            if iblk != nil {
                let initFooterBlock: HTableCellInitBlock = iblk as! HTableCellInitBlock
                initFooterBlock(cell)
            }
        }else {
            cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HTableBaseApex
        }
        //保存cell
        self.allReuseFooters.setObject(cell, forKey: "\(section)" as NSString)
        //调用代理方法
        var edgeInsets: UIEdgeInsets = UIEdgeInsetsZero
        let prefix = self.prefixWithSection(section)
        let selector = #selector(self.tableDelegate!.edgeInsetsForFooterInSection(_:))
        if self.tableDelegate!.responds(to: selector, withPre: prefix) {
            edgeInsets = self.tableDelegate!.performWithUnretainedValue(selector, with: section, withPre: prefix) as! UIEdgeInsets
        }
        //设置属性
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        return cell
    }

    func dequeueReusableCellWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, idxPath: IndexPath) -> AnyObject {
        var cell: HTableBaseCell
        var identifier = NSStringFromClass(cls)
        identifier = identifier + self.addressValue
        identifier = identifier + "ItemCell"
        if self.tableStyle == .split && self.sectionPaths?.contains(idxPath.section) == false {
            identifier = identifier + "\(self.tableState)"
        }
        if (pre != nil) { identifier = identifier + pre! }
        if idx { identifier = identifier + idxPath.stringValue }
        if self.allReuseIdentifiers.contains(identifier) == false {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forCellReuseIdentifier: identifier)
            cell = self.dequeueReusableCell(withIdentifier: identifier, for: idxPath) as! HTableBaseCell
            cell.table = self
            cell.indexPath = idxPath
            //init method
            if iblk != nil {
                let initCellBlock: HTableCellInitBlock = iblk as! HTableCellInitBlock
                initCellBlock(cell)
            }
        }else {
            cell = self.dequeueReusableCell(withIdentifier: identifier, for: idxPath) as! HTableBaseCell
        }
        //保存cell
        self.allReuseCells.setObject(cell, forKey: idxPath.stringValue as NSString)
        //调用代理方法
        var edgeInsets: UIEdgeInsets = UIEdgeInsetsZero
        let prefix = self.prefixWithSection(idxPath.section)
        let selector = #selector(self.tableDelegate!.edgeInsetsForRowAtIndexPath(_:))
        if self.tableDelegate!.responds(to: selector, withPre: prefix) {
            edgeInsets = self.tableDelegate!.performWithUnretainedValue(selector, with: idxPath, withPre: prefix) as! UIEdgeInsets
        }
        //设置属性
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        return cell
    }
    
    /// UITableViewDatasource  & delegate
    private func prefixWithSection(_ section: Int) -> String {
        var prefix = ""
        if self.tableStyle == .split {
            if self.sectionPaths?.contains(section) ?? false {
                let idx: Int = self.sectionPaths!.index(of: section)
                prefix = KTableExaDesignKey + "\(idx)" + "_"
            }else {
                prefix = KTableExaDesignKey + "\(self.tableState)" + "_"
            }
        }
        return prefix
    }
    
    ///以下为UITableView的代理方法
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.tableStyle {
        case .default:
            var sections = 0
            let prefix = ""
            let selector = #selector(self.tableDelegate!.numberOfSectionsInTableView)
            if self.tableDelegate!.responds(to: selector, withPre: prefix) {
                sections = self.tableDelegate!.performWithUnretainedValue(selector, withPre: prefix) as! Int
            }
            return sections
        case .split:
            var sections = 0
            let prefix = KTableDesignKey + "\(self.tableState)" + "_"
            let selector = #selector(self.tableDelegate!.numberOfSectionsInTableView)
            if self.tableDelegate!.responds(to: selector, withPre: prefix) {
                sections = self.tableDelegate!.performWithUnretainedValue(selector, withPre: prefix) as! Int
            }
            return sections
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var items = 0
        let prefix = self.prefixWithSection(section)
        let selector: Selector = #selector(self.tableDelegate!.numberOfRowsInSection(_:))
        if self.tableDelegate!.responds(to: selector, withPre: prefix) {
            items = self.tableDelegate!.performWithUnretainedValue(selector, with: section, withPre: prefix) as! Int
        }
        return items
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        let prefix = self.prefixWithSection(section)
        let selector = #selector(self.tableDelegate!.heightForHeaderInSection(_:))
        if self.tableDelegate!.responds(to: selector, withPre: prefix) {
            height = self.tableDelegate!.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
        }
        return height
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        let prefix = self.prefixWithSection(section)
        let selector = #selector(self.tableDelegate!.heightForFooterInSection(_:))
        if self.tableDelegate!.responds(to: selector, withPre: prefix) {
            height = self.tableDelegate!.performWithUnretainedValue(selector, with: section, withPre: prefix) as! CGFloat
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0.0
        let prefix = self.prefixWithSection(indexPath.section)
        let selector = #selector(self.tableDelegate!.heightForRowAtIndexPath(_:))
        if self.tableDelegate!.responds(to: selector, withPre: prefix) {
            height = self.tableDelegate!.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! CGFloat
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //调用代理方法
        let prefix = self.prefixWithSection(indexPath.section)
        let selector: Selector = #selector(self.tableDelegate!.tableRow(_:atIndexPath:))
        let itemBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) in
            return self.dequeueReusableCellWithClass(cls, iblk: iblk, pre: pre, idx: idx, idxPath: indexPath)
        }
        if self.tableDelegate!.responds(to: selector, withPre: prefix) {
            self.tableDelegate!.perform(selector, with: itemBlock, with: indexPath, withPre: prefix)
        }
        //调用cell
        let cell = self.allReuseCells.object(forKey: indexPath.stringValue as NSString) as! HTableBaseCell
        //更新布局
        if cell.responds(to: #selector(cell.relayoutSubviews)) {
            cell.relayoutSubviews()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //调用代理方法
        let prefix = self.prefixWithSection(section)
        let selector: Selector = #selector(self.tableDelegate!.tableHeader(_:inSection:))
        let headerBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject in
            return self.dequeueReusableHeaderWithClass(cls, iblk: iblk, pre: pre, idx: idx, section: section)
        }
        if self.tableDelegate!.responds(to: selector, withPre: prefix) {
            self.tableDelegate!.perform(selector, with: headerBlock, with: section, withPre: prefix)
        }
        //更新布局
        let cell = self.allReuseHeaders.object(forKey: "\(section)" as NSString) as? HTableBaseApex
        if cell!.responds(to: #selector(cell!.relayoutSubviews)) {
            cell!.relayoutSubviews()
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //调用代理方法
        let prefix = self.prefixWithSection(section)
        let selector: Selector = #selector(self.tableDelegate!.tableFooter(_:inSection:))
        let footerBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject in
            return self.dequeueReusableFooterWithClass(cls, iblk: iblk, pre: pre, idx: idx, section: section)
        }
        if self.tableDelegate!.responds(to: selector, withPre: prefix) {
            self.tableDelegate!.perform(selector, with: footerBlock, with: section, withPre: prefix)
        }
        //更新布局
        let cell = self.allReuseFooters.object(forKey: "\(section)" as NSString) as? HTableBaseApex
        if cell!.responds(to: #selector(cell!.relayoutSubviews)) {
            cell!.relayoutSubviews()
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let prefix = self.prefixWithSection(indexPath.section)
        let selector = #selector(self.tableDelegate!.willDisplayCell(_:atIndexPath:))
        if self.tableDelegate!.responds(to: selector, withPre: prefix) {
            self.tableDelegate!.perform(selector, with: cell, with: indexPath, withPre: prefix)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.allReuseCells.object(forKey: indexPath.stringValue as NSString) as! HTableBaseCell
        if cell.didSelectCell != nil {
            cell.didSelectCell!(cell, indexPath)
        }
        let prefix = self.prefixWithSection(indexPath.section)
        let selector = #selector(self.tableDelegate!.didSelectRowAtIndexPath(_:))
        if self.tableDelegate!.responds(to: selector, withPre: prefix) {
            self.tableDelegate!.perform(selector, with: indexPath, withPre: prefix)
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
    func signalToTableView(_ signal: HTableSignal?) {
        if self.signalBlock != nil {
            DispatchQueue.main.async { [weak self] in
                self!.signalBlock!(self!, signal)
            }
        }
    }

    ///给所有item、某个section下的item或单独某个item发送信号
    func signalToAllItems(_ signal: HTableSignal?) {
        DispatchQueue.main.async { [weak self] in
            for object in self!.allReuseCells.objectEnumerator()!.allObjects {
                let cell = object as! HTableBaseCell
                if cell.signalBlock != nil {
                    cell.signalBlock!(cell, signal)
                }
            }
        }
    }

    func signal(_ signal: HTableSignal?, itemSection section: Int) {
        DispatchQueue.main.async { [weak self] in
            let items = self!.numberOfRows(inSection: section)
            for i in 0..<items {
                let cell = self!.allReuseCells.object(forKey: IndexPath.stringValue(i, section) as NSString) as! HTableBaseCell
                if cell.signalBlock != nil {
                    cell.signalBlock!(cell, signal)
                }
            }
        }
    }

    func signal(_ signal: HTableSignal?, toRow row: Int, inSection section: Int) {
        let cell = self.allReuseCells.object(forKey: indexPath(row, section).stringValue as NSString) as! HTableBaseCell
        if cell.signalBlock != nil {
            DispatchQueue.main.async { [weak cell] in
                cell!.signalBlock!(cell!, signal)
            }
        }
    }

    ///给所有header或单独某个header发送信号
    func signalToAllHeader(_ signal: HTableSignal?) {
        DispatchQueue.main.async { [weak self] in
            let sections = self!.numberOfSections
            for i in 0..<sections {
                let header = self!.allReuseCells.object(forKey: IndexPath.stringValue(0, i) as NSString) as! HTableBaseApex
                if header.signalBlock != nil {
                    header.signalBlock!(header, signal)
                }
            }
        }
    }

    func signal(_ signal: HTableSignal?, headerSection section: Int) {
        let header = self.allReuseCells.object(forKey: IndexPath.stringValue(0, section) as NSString) as! HTableBaseApex
        if header.signalBlock != nil {
            DispatchQueue.main.async { [weak header] in
                header!.signalBlock!(header!, signal)
            }
        }
    }

    ///给所有footer或单独某个footer发送信号
    func signalToAllFooter(_ signal: HTableSignal?) {
        DispatchQueue.main.async { [weak self] in
            let sections = self!.numberOfSections
            for i in 0..<sections {
                let footer = self!.allReuseCells.object(forKey: IndexPath.stringValue(0, i) as NSString) as! HTableBaseApex
                if footer.signalBlock != nil {
                    footer.signalBlock!(footer, signal)
                }
            }
        }
    }

    func signal(_ signal: HTableSignal?, footerSection section: Int) {
        let footer = self.allReuseCells.object(forKey: IndexPath.stringValue(0, section) as NSString) as! HTableBaseApex
        if footer.signalBlock != nil {
            DispatchQueue.main.async { [weak footer] in
                footer!.signalBlock!(footer!, signal)
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
                let cell = object as! HTableBaseCell
                if cell.signalBlock != nil {
                    cell.signalBlock = nil
                }
            }
            //release all header
            for object in self.allReuseHeaders.objectEnumerator()!.allObjects {
                let header = object as! HTableBaseApex
                if header.signalBlock != nil {
                    header.signalBlock = nil
                }
            }
            //release all footer
            for object in self.allReuseFooters.objectEnumerator()!.allObjects {
                let footer = object as! HTableBaseApex
                if footer.signalBlock != nil {
                    footer.signalBlock = nil
                }
            }
        }
    }

    ///根据传入的row和section获取cell或indexPath
    func cell(_ row: Int, _ section: Int) -> AnyObject? {
        return self.allReuseCells.object(forKey: IndexPath.stringValue(row, section) as NSString)
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
            var dict: NSMutableDictionary? = self.getAssociatedValueForKey(&tableStateSourceKey) as? NSMutableDictionary
            if dict == nil {
                dict = NSMutableDictionary()
                self.setAssociateValue(dict, key: &tableStateSourceKey)
            }
            return dict!
        }
    }
    
    ///tableView分体式设计所表示的状态
    var tableState: HTableState {
        get {
            return self.getAssociatedValueForKey(&tableStateKey) as? HTableState ?? 0
        }
        set {
            if newValue != self.tableState {
                self.setAssociateWeakValue(newValue, key: &tableStateKey)
                self.reloadData()
            }
        }
    }

    ///向某个状态或当前状态添加一个值
    func setObject(_ anObject: Any, forKey aKey: String) {
        self.setObject(anObject, forKey: aKey, state: self.tableState)
    }
    
    func setObject(_ anObject: Any, forKey aKey: String, state tableState: HTableState) {
        let key: NSString = aKey + KTableStateKey + "\(tableState)" as NSString
        self.tableStateSource.setObject(anObject, forKey: key)
    }

    ///获取某个状态或当前状态的一个值
    func objectForKey(_ aKey: String) -> Any? {
        return self.objectForKey(aKey, state: self.tableState)
    }
    
    func objectForKey(_ aKey: String, state tableState: HTableState) -> Any? {
        let key: NSString = aKey + KTableStateKey + "\(tableState)" as NSString
        return self.tableStateSource.object(forKey: key)
    }

    ///删除某个状态或当前状态下的一个值
    func removeObjectForKey(_ aKey: String) {
        self.removeObjectForKey(aKey, state: self.tableState)
    }
    
    func removeObjectForKey(_ aKey: String, state tableState: HTableState) {
        let key: NSString = aKey + KTableStateKey + "\(tableState)" as NSString
        self.tableStateSource.removeObject(forKey: key)
    }

    ///删除某个状态或当前状态的值
    func removeStateObject() {
        self.removeObjectForState(self.tableState)
    }
    
    func removeObjectForState(_ tableState: HTableState) {
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
