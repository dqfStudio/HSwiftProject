//
//  HFlowView.swift
//  HSwiftProject
//
//  Created by owner on 2024/10/21.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

private var kFlowPageNo = 1
private var kFlowPageSize = 20
private var kFlowTotalPageNo = 1000000

/// Refresh & LoadMore block
typealias HFlowRefreshBlock = () -> Void
typealias HFlowLoadMoreBlock = () -> Void

class HFlowReload: NSObject {
    var isRefresh = false //是否正在刷新
    var needRefresh = false //是否需要刷新
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
    optional func flowHeader(_ flow: HFlowView, inSection section: Any)
    @objc
    optional func flowFooter(_ flow: HFlowView, inSection section: Any)
    @objc
    optional func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath)

    @objc
    optional func willDisplayCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
    @objc
    optional func didSelectCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
}

class HFlowView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private var flowReload = HFlowReload()
    private var cellHeights: [String: CGFloat] = [:]
    private var allReuseIdentifiers = NSMutableSet()
    private var allReuseCells   = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
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
    
    private weak var flowDelegate: HFlowViewDelegate?
    override weak var delegate: UITableViewDelegate? {
        get { return super.delegate }
        set { flowDelegate = newValue as? HFlowViewDelegate }
    }
    override weak var dataSource: UITableViewDataSource? {
        get { return super.dataSource }
        set { _ = newValue }
    }
    
    private func setup() {
        self.backgroundColor = .clear
        self.alwaysBounceVertical = true
        self.keyboardDismissMode = .onDrag
        self.estimatedSectionHeaderHeight = 0.0
        self.estimatedSectionFooterHeight = 0.0
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false

        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0.0
        }
        
        self.separatorStyle = .none
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
    
    /// Scroll to top
    func scrollToTop(_ animated: Bool) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        self.scrollRectToVisible(rect, animated: animated)
    }

    /// Scroll to bottom
    func scrollsToBottom(_ animated: Bool) {
        let sections = self.numberOfSections
        let items = self.numberOfRows(inSection: sections - 1)
        let indexPath = IndexPath(row: items - 1, section: sections - 1)
        self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
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
        DispatchQueue.global().async {
            self.flowDelegate = nil
            self.refreshBlock = nil
            self.loadMoreBlock = nil
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Register class
    func header(_ cls: AnyClass, _ pre: String?, _ section: Any) -> AnyObject {
        // Unique identifier
        let identifier = (pre ?? "") + NSStringFromClass(cls)
        // Register cell if not already registered
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forHeaderFooterViewReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier)!
        // Save cell
        self.allReuseHeaders.setObject(cell, forKey: "\(section)" as NSString)
        // Return cell
        return cell
    }
    
    func footer(_ cls: AnyClass, _ pre: String?, _ section: Any) -> AnyObject {
        // Unique identifier
        let identifier = (pre ?? "") + NSStringFromClass(cls)
        // Register cell if not already registered
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forHeaderFooterViewReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier)!
        // Save cell
        self.allReuseFooters.setObject(cell, forKey: "\(section)" as NSString)
        // Return cell
        return cell
    }

    func cell(_ cls: AnyClass, _ pre: String?, _ indexPath: IndexPath) -> AnyObject {
        // Unique identifier
        let identifier = (pre ?? "") + NSStringFromClass(cls)
        // Register cell if not already registered
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forCellReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        // Save cell
        self.allReuseCells.setObject(cell, forKey: indexPath.nsStringValue)
        // Return cell
        return cell
    }
    
    /// The following are the delegate methods for UITableView.
    func numberOfSections(in tableView: UITableView) -> Int {
        // remove cache data
        self.allReuseIdentifiers.removeAllObjects()
        self.cellHeights.removeAll()
        // table Style
        var sections = 1
        if let delegate = self.flowDelegate {
            let selector = #selector(delegate.numberOfSectionsInFlowView)
            if delegate.responds(to: selector) {
                sections = delegate.performWithUnretainedValue(selector) as! Int
            }
            // Prevents quantity from being less than 1
            sections = max(sections, 1)
        }
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var items = 0
        if let delegate = self.flowDelegate {
            // Get the number of items
            let selector = #selector(delegate.numberOfRowsInSection(_:))
            if delegate.responds(to: selector) {
                items = delegate.performWithUnretainedValue(selector, with: section) as! Int
            }
            // Prevents quantity from being less than 0
            items = max(items, 0)
        }
        return items
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        if let delegate = self.flowDelegate {
            let selector = #selector(delegate.heightForHeaderInSection(_:))
            if delegate.responds(to: selector) {
                height = delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
            }
            // Prevent negative size
            height = max(height, 0.0)
        }
        return height
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        if let delegate = self.flowDelegate {
            let selector = #selector(delegate.heightForFooterInSection(_:))
            if delegate.responds(to: selector) {
                height = delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
            }
            // Prevent negative size
            height = max(height, 0.0)
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = self.cellHeights[indexPath.stringValue] {
            return height
        } else {
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Call delegate method
        if let delegate = self.flowDelegate {
            let selector = #selector(delegate.flowRow(_:atIndexPath:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: self, with: indexPath)
            }
        }
        // Call cell
        return self.allReuseCells.object(forKey: indexPath.nsStringValue) as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Call delegate method
        if let delegate = self.flowDelegate {
            let selector = #selector(delegate.flowHeader(_:inSection:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: self, with: section)
            }
        }
        // Update layout
        return self.allReuseHeaders.object(forKey: "\(section)" as NSString) as? UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Call delegate method
        if let delegate = self.flowDelegate {
            let selector = #selector(delegate.flowFooter(_:inSection:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: self, with: section)
            }
        }
        // Update layout
        return self.allReuseFooters.object(forKey: "\(section)" as NSString) as? UITableViewCell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let delegate = self.flowDelegate {
            // Save cell height
            self.cellHeights[indexPath.stringValue] = cell.frame.size.height
            // Call delegate method
            let selector = #selector(delegate.willDisplayCell(_:atIndexPath:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: cell, with: indexPath)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? UITableViewCell
        if let delegate = self.flowDelegate, let cell = cell {
            let selector = #selector(delegate.didSelectCell(_:atIndexPath:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: cell, with: indexPath)
            }
        }
    }
    
}

extension HFlowView {
    func cell(_ row: Int, _ section: Int) -> AnyObject? {
        return self.allReuseCells.object(forKey: IndexPath.nsStringValue(row, section))
    }
    
    func cell(for indexPath: IndexPath) -> AnyObject? {
        return self.allReuseCells.object(forKey: indexPath.nsStringValue)
    }
    
    func header(for section: Int) -> AnyObject? {
        return self.allReuseHeaders.object(forKey: IndexPath.nsStringValue(0, section))
    }
    
    func footer(for section: Int) -> AnyObject? {
        return self.allReuseFooters.object(forKey: IndexPath.nsStringValue(0, section))
    }
}
