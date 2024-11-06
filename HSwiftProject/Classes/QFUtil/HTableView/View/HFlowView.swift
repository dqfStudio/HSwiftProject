//
//  HFlowView.swift
//  HSwiftProject
//
//  Created by owner on 2024/10/21.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit
import Kingfisher
import SDWebImage

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
    optional func heightForRowAtIndexPath(_ indexPath: IndexPath) -> Any
    
    @objc
    optional func flowHeader(_ flow: HFlowView, inSection section: Any) -> UIView?
    @objc
    optional func flowFooter(_ flow: HFlowView, inSection section: Any) -> UIView?
    @objc
    optional func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath) -> UITableViewCell?

    @objc
    optional func willDisplayCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
    @objc
    optional func didEndDisplayingCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
    @objc
    optional func didSelectCell(_ indexPath: IndexPath)
    
    /// UIScrollViewDelegate
    @objc
    optional func flowViewDidScroll(_ scrollView: UIScrollView)
}

class HFlowView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private var flowReload = HFlowReload()
    private var cellHeights: [String: CGFloat] = [:]
    private var allPassedCells = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// The following are the delegate methods for UITableView.
    func numberOfSections(in tableView: UITableView) -> Int {
        // remove cache data
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
        } else if tableView.estimatedRowHeight != UITableView.automaticDimension {
            return tableView.estimatedRowHeight
        }
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.rowHeight != UITableView.automaticDimension {
            return tableView.rowHeight
        } else {
            var height: CGFloat = 0.0
            if let delegate = self.flowDelegate {
                let selector = #selector(delegate.heightForRowAtIndexPath(_:))
                if delegate.responds(to: selector) {
                    height = delegate.performWithUnretainedValue(selector, with: indexPath) as! CGFloat
                }
                // Prevent negative size
                height = max(height, 0.0)
                if height > 0 { return height }
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Update passed cells
        if self.allPassedCells.count > 20 {
            self.allPassedCells.removeAllObjects()
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk(onCompletion: {})
            KingfisherManager.shared.cache.clearMemoryCache()
        }
        // Call delegate method
        if let delegate = self.flowDelegate {
            let selector = #selector(delegate.flowRow(_:atIndexPath:))
            if delegate.responds(to: selector) {
                let cell = delegate.performWithUnretainedValue(selector, with: self, with: indexPath) as? UITableViewCell
                if let cell = cell { return cell }
            }
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        return tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Call delegate method
        if let delegate = self.flowDelegate {
            let selector = #selector(delegate.flowHeader(_:inSection:))
            if delegate.responds(to: selector) {
                return delegate.performWithUnretainedValue(selector, with: self, with: section) as? UIView
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Call delegate method
        if let delegate = self.flowDelegate {
            let selector = #selector(delegate.flowFooter(_:inSection:))
            if delegate.responds(to: selector) {
                return delegate.performWithUnretainedValue(selector, with: self, with: section) as? UIView
            }
        }
        return nil
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
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let delegate = self.flowDelegate {
            let selector = #selector(delegate.didEndDisplayingCell(_:atIndexPath:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: cell, with: indexPath)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.flowDelegate {
            let selector = #selector(delegate.didSelectCell(_:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: indexPath)
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
