//
//  HChatView.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/10.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

private var kChatPageNo = 1
private var kChatPageSize = 20
private var kChatTotalPageNo = 1000000

/// Refresh & LoadMore block
typealias HChatRefreshBlock = () -> Void
typealias HChatLoadMoreBlock = () -> Void

@objc protocol HChatViewDelegate: UITableViewDelegate {
    @objc
    optional func numberOfSectionsInChatView() -> Any
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
    optional func tableHeader(_ chat: HChatView, inSection section: Any)
    @objc
    optional func tableFooter(_ chat: HChatView, inSection section: Any)
    @objc
    optional func tableRow(_ chat: HChatView, atIndexPath indexPath: IndexPath)

    @objc
    optional func willDisplayCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
    @objc
    optional func didSelectCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
}

class HChatView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
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
    
    private weak var chatDelegate: HChatViewDelegate?
    override weak var delegate: UITableViewDelegate? {
        get { return super.delegate }
        set { chatDelegate = newValue as? HChatViewDelegate }
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
    var pageNo: Int = kChatPageNo {
        didSet {
            if pageNo <= 0 {
                pageNo = kChatPageNo
            }
        }
    }
    
    /// Page size, Default 20
    var pageSize: Int = kChatPageSize {
        didSet {
            if pageSize <= 0 {
                pageSize = kChatPageSize
            }
        }
    }
    
    /// Total number. Default 10000
    var totalNo: Int = kChatTotalPageNo {
        didSet {
            if totalNo <= 0 {
                totalNo = kChatTotalPageNo
            }
        }
    }
    
    /// Refresh header style
    var refreshHeaderStyle: HChatRefreshHeaderStyle = .gray
    
    /// Load more footer style
    var refreshFooterStyle: HChatRefreshFooterStyle = .style1

    /// Block to refresh data
    var refreshBlock: HChatRefreshBlock? {
        didSet {
            if let refreshBlock = refreshBlock {
                self.mj_header = HChatRefresh.refreshHeaderWithStyle(refreshHeaderStyle) {
                    self.pageNo = 1
                    refreshBlock()
                }
            } else {
                self.mj_header = nil
            }
        }
    }

    /// Block to load more data
    var loadMoreBlock: HChatLoadMoreBlock? {
        didSet {
            if let loadMoreBlock = loadMoreBlock {
                self.pageNo = 1
                self.mj_footer = HChatRefresh.refreshFooterWithStyle(refreshFooterStyle) { [weak self] in
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
    
    @objc
    func reloadChatData() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }
    
    /// Scroll to top
    func scrollToTop(_ animated: Bool) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        self.scrollRectToVisible(rect, animated: animated)
    }

    /// Scroll to bottom
    func scrollsToBottom(_ animated: Bool) {
        let sections = max(self.numberOfSections - 1, 0)
        let items = max(self.numberOfRows(inSection: sections) - 1, 0)
        let indexPath = IndexPath(row: items, section: sections)
        self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }

    /// Release method
    @objc
    func releaseChatBlock() {
        DispatchQueue.global().async {
            self.chatDelegate = nil
            self.refreshBlock = nil
            self.loadMoreBlock = nil
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Register class
    func header(_ cls: AnyClass, _ idx: Bool, _ section: Any) -> AnyObject {
        // Unique identifier
        var identifier = "HeaderCell" + NSStringFromClass(cls)
        // Determine whether it contains an index
        identifier += idx ? "\(section)" : ""
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
    
    func footer(_ cls: AnyClass, _ idx: Bool, _ section: Any) -> AnyObject {
        // Unique identifier
        var identifier = "FooterCell" + NSStringFromClass(cls)
        // Determine whether it contains an index
        identifier += idx ? "\(section)" : ""
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

    func cell(_ cls: AnyClass, _ idx: Bool, _ indexPath: IndexPath) -> AnyObject {
        // Unique identifier
        var identifier = "ItemCell" + NSStringFromClass(cls)
        // Determine whether it contains an index
        identifier += idx ? indexPath.stringValue : ""
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
        // table Style
        var sections = 1
        if let delegate = self.chatDelegate {
            let prefix = ""
            let selector = #selector(delegate.numberOfSectionsInChatView)
            if delegate.responds(to: selector, withPre: prefix) {
                sections = delegate.performWithUnretainedValue(selector, withPre: prefix) as! Int
            }
            // Prevents quantity from being less than 1
            sections = max(sections, 1)
        }
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var items = 0
        if let delegate = self.chatDelegate {
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
        if let delegate = self.chatDelegate {
            let selector = #selector(delegate.minimumHeaderSpacingForSectionAt(_:))
            if delegate.responds(to: selector) {
                height = delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
            } else {
                let selector = #selector(delegate.heightForHeaderInSection(_:))
                if delegate.responds(to: selector) {
                    height = delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
                }
            }
            // Prevent negative size
            height = max(height, 0.0)
        }
        return height
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        if let delegate = self.chatDelegate {
            let selector: Selector = #selector(delegate.minimumFooterSpacingForSectionAt(_:))
            if delegate.responds(to: selector) {
                height = delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
            } else {
                let selector = #selector(delegate.heightForFooterInSection(_:))
                if delegate.responds(to: selector) {
                    height = delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
                }
            }
            // Prevent negative size
            height = max(height, 0.0)
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Call delegate method
        if let delegate = self.chatDelegate {
            let selector = #selector(delegate.tableRow(_:atIndexPath:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: self, with: indexPath)
            }
        }
        // Call cell
        return self.allReuseCells.object(forKey: indexPath.nsStringValue) as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Call delegate method
        if let delegate = self.chatDelegate {
            let selector = #selector(delegate.tableHeader(_:inSection:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: self, with: section)
            }
        }
        // Update layout
        return self.allReuseHeaders.object(forKey: "\(section)" as NSString) as? UITableViewCell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Call delegate method
        if let delegate = self.chatDelegate {
            let selector = #selector(delegate.tableFooter(_:inSection:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: self, with: section)
            }
        }
        // Update layout
        return self.allReuseFooters.object(forKey: "\(section)" as NSString) as? UITableViewCell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? UITableViewCell
        if let delegate = self.chatDelegate, let cell = cell {
            let selector = #selector(delegate.willDisplayCell(_:atIndexPath:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: cell, with: indexPath)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? UITableViewCell
        if let delegate = self.chatDelegate, let cell = cell {
            let selector = #selector(delegate.didSelectCell(_:atIndexPath:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: cell, with: indexPath)
            }
        }
    }
    
}
