////
////  HTableView.swift
////  HSwiftProject
////
////  Created by owner on 2024/10/21.
////  Copyright © 2024 wind. All rights reserved.
////
//
//import UIKit
//import Kingfisher
//import SDWebImage
//
//class HTableReload: NSObject {
//    var isRefresh = false //是否正在刷新
//    var needRefresh = false //是否需要刷新
//}
//
//@objc protocol HTableViewDelegate: UITableViewDelegate {
//    @objc
//    optional func heightForHeaderInSection(_ section: Int) -> CGFloat
//    @objc
//    optional func heightForFooterInSection(_ section: Int) -> CGFloat
//    @objc
//    optional func heightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat
//    
//    @objc
//    optional func tableHeader(_ table: HTableView, inSection section: Int) -> UIView?
//    @objc
//    optional func tableFooter(_ table: HTableView, inSection section: Int) -> UIView?
//    @objc
//    optional func tableRow(_ table: HTableView, atIndexPath indexPath: IndexPath) -> UITableViewCell?
//
//    @objc
//    optional func willDisplayCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
//    @objc
//    optional func didEndDisplayingCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
//    @objc
//    optional func didSelectCell(_ indexPath: IndexPath)
//    
//    /// UIScrollViewDelegate
//    @objc
//    optional func tableViewDidScroll(_ scrollView: UIScrollView)
//    
//    @objc
//    optional func tableViewWillBeginDragging(_ scrollView: UIScrollView)
//    
//    @objc
//    optional func tableViewWillEndDragging(_ velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
//    
//    @objc
//    optional func tableViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
//    
//    @objc
//    optional func tableViewDidEndDecelerating(_ scrollView: UIScrollView)
//}
//
//// 数据源分区
//private enum HChatSection {
//    case main
//}
//
//private struct HChatItem: Hashable {
//    let id: String
//    let title: String
//}
//
//class HTableView: UITableView, UITableViewDelegate {
//    
//    // delay reload table
//    private var tableReload = HTableReload()
//    
//    // delay reload item
//    private var allReloadItems: [IndexPath] = []
//    private var reloadedItems: [IndexPath] = []
//    private var itemReload = HTableReload()
//    
//    private var cellHeights: [String: CGFloat] = [:]
//    private var allPassedCells = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
//    
//    private var chatItems: [HChatItem] = []
//    
//    // 定义 Diffable Data Source
//    private lazy var chatSource: UITableViewDiffableDataSource<HChatSection, HChatItem> = {
//        let dataSource = UITableViewDiffableDataSource<HChatSection, HChatItem>(tableView: self) { [weak self] (tableView, indexPath, item) -> UITableViewCell? in
//            guard let self = self else { return nil }
//            // Update passed cells
//            if self.allPassedCells.count > 20 {
//                self.allPassedCells.removeAllObjects()
//                SDImageCache.shared.clearMemory()
//                SDImageCache.shared.clearDisk(onCompletion: {})
//                KingfisherManager.shared.cache.clearMemoryCache()
//            }
//            // Call delegate method
//            let cell = tableDelegate?.tableRow?(self, atIndexPath: indexPath)
//            guard let cell = cell else {
//                self.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
//                return self.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
//            }
//            return cell
//        }
//        return dataSource
//    }()
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//    
//    convenience init(frame: CGRect) {
//        self.init(frame: frame, style: .plain)
//    }
//    
//    override init(frame: CGRect, style: UITableView.Style) {
//        super.init(frame: frame, style: style)
//        self.setup()
//    }
//    
//    private weak var tableDelegate: HTableViewDelegate?
//    override weak var delegate: UITableViewDelegate? {
//        get { return super.delegate }
//        set { tableDelegate = newValue as? HTableViewDelegate }
//    }
//    override weak var dataSource: UITableViewDataSource? {
//        get { return super.dataSource }
//        set { _ = newValue }
//    }
//    
//    private func setup() {
//        self.backgroundColor = .clear
//        self.alwaysBounceVertical = true
//        self.keyboardDismissMode = .onDrag
//        self.estimatedSectionHeaderHeight = 0.0
//        self.estimatedSectionFooterHeight = 0.0
//        self.showsVerticalScrollIndicator = false
//        self.showsHorizontalScrollIndicator = false
//
//        if #available(iOS 11.0, *) {
//            self.contentInsetAdjustmentBehavior = .never
//        }
//        if #available(iOS 15.0, *) {
//            self.sectionHeaderTopPadding = 0.0
//        }
//        
//        self.separatorStyle = .none
//        self.tableFooterView = UIView()
//        
//        super.delegate = self
//    }
//    
//    /// Scroll to top
//    func scrollToTop(_ animated: Bool) {
//        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
//        self.scrollRectToVisible(rect, animated: animated)
//    }
//
//    /// Scroll to bottom
//    func scrollsToBottom(_ animated: Bool) {
//        let sections = self.numberOfSections
//        let items = self.numberOfRows(inSection: sections - 1)
//        let indexPath = IndexPath(row: items - 1, section: sections - 1)
//        self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
//    }
//    
//    // 多少秒内只刷新一次
//    func reloadIfNeeded(_ delay: TimeInterval = 2.0) {
//        if self.tableReload.isRefresh {
//            self.tableReload.needRefresh = true
//        }else {
//            self.reloadAsync(delay)
//        }
//    }
//    
//    private func reloadAsync(_ delay: TimeInterval) {
//        self.tableReload.isRefresh = true
//        self.tableReload.needRefresh = false
//        self.reloadTableData()
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
//            guard let self = self else { return }
//            if self.tableReload.needRefresh {
//                self.reloadAsync(delay)
//            }else {
//                self.tableReload.isRefresh = false
//            }
//        }
//    }
//    
//    // 多少秒内只刷新一次
//    func reloadItemsIfNeeded(at indexPaths: [IndexPath], _ delay: TimeInterval = 0.25) {
//        self.allReloadItems.append(contentsOf: indexPaths)
//        
//        if self.itemReload.isRefresh {
//            self.itemReload.needRefresh = true
//        }else {
//            self.reloadItemsAsync(at: indexPaths, delay)
//        }
//    }
//    
//    private func reloadItemsAsync(at indexPaths: [IndexPath], _ delay: TimeInterval) {
//        self.itemReload.isRefresh = true
//        self.itemReload.needRefresh = false
//        self.reloadedItems.append(contentsOf: indexPaths)
//        var snapshot = chatSource.snapshot()
//        if #available(iOS 15.0, *) {
//            snapshot.reconfigureItems([HChatItem(id: "", title: "")])
//        } else {
//            // Fallback on earlier versions
//        }
//        chatSource.apply(snapshot, animatingDifferences: false)
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
//            guard let self = self else { return }
//            if self.itemReload.needRefresh {
//                // 更改标签
//                self.itemReload.needRefresh = false
//                // 将数组转换为集合，通过集合差集操作实现删除效果
//                let finalArrayAll = Array(Set(self.allReloadItems).subtracting(Set(self.reloadedItems)))
//                if !finalArrayAll.isEmpty { //递归调用
//                    self.reloadItemsAsync(at: finalArrayAll, delay)
//                }
//            }else {
//                self.itemReload.isRefresh = false
//                self.allReloadItems.removeAll()
//                self.reloadedItems.removeAll()
//            }
//        }
//    }
//    
//    @objc
//    func reloadTableData() {
//        DispatchQueue.mainAsync { [weak self] in
//            guard let self = self else { return }
//            // remove cache data
//            self.cellHeights.removeAll()
//            
//            var snapshot = NSDiffableDataSourceSnapshot<HChatSection, HChatItem>()
//            snapshot.appendSections([.main])
//            snapshot.appendItems(chatItems)
//            chatSource.apply(snapshot, animatingDifferences: false)
//        }
//    }
//    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//        self.removeFromSuperview()
//        self.tableDelegate = nil
//        self.dataSource = nil
//        self.delegate = nil
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let height = tableDelegate?.heightForHeaderInSection?(section) ?? 0.0
//        return max(height, 0.0)
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        let height = tableDelegate?.heightForFooterInSection?(section) ?? 0.0
//        return max(height, 0.0)
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let height = self.cellHeights[indexPath.stringValue] {
//            return height
//        } else if tableView.estimatedRowHeight != UITableView.automaticDimension {
//            return tableView.estimatedRowHeight
//        }
//        return 50.0
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView.rowHeight != UITableView.automaticDimension {
//            return tableView.rowHeight
//        } else {
//            var height = tableDelegate?.heightForRowAtIndexPath?(indexPath) ?? 0.0
//            // Prevent negative size
//            height = max(height, 0.0)
//            if height > 0 { return height }
//        }
//        return UITableView.automaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return tableDelegate?.tableHeader?(self, inSection: section)
//    }
//    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return tableDelegate?.tableFooter?(self, inSection: section)
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // Save cell height
//        self.cellHeights[indexPath.stringValue] = cell.frame.size.height
//        // Call delegate method
//        self.tableDelegate?.willDisplayCell?(cell, atIndexPath: indexPath)
//    }
//    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        tableDelegate?.didEndDisplayingCell?(cell, atIndexPath: indexPath)
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableDelegate?.didSelectCell?(indexPath)
//    }
//    
//    /// UIScrollViewDelegate
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        tableDelegate?.tableViewDidScroll?(scrollView)
//    }
//    
//    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        tableDelegate?.tableViewWillBeginDragging?(scrollView)
//    }
//    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        tableDelegate?.tableViewWillEndDragging?(velocity, targetContentOffset: targetContentOffset)
//    }
//    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        tableDelegate?.tableViewDidEndDragging?(scrollView, willDecelerate: decelerate)
//        // Update passed cells
//        if !decelerate, self.allPassedCells.count > 5 {
//            self.allPassedCells.removeAllObjects()
//            SDImageCache.shared.clearMemory()
//            SDImageCache.shared.clearDisk(onCompletion: {})
//            KingfisherManager.shared.cache.clearMemoryCache()
//        }
//    }
//    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        tableDelegate?.tableViewDidEndDecelerating?(scrollView)
//        // Update passed cells
//        if self.allPassedCells.count > 5 {
//            self.allPassedCells.removeAllObjects()
//            SDImageCache.shared.clearMemory()
//            SDImageCache.shared.clearDisk(onCompletion: {})
//            KingfisherManager.shared.cache.clearMemoryCache()
//        }
//    }
//}
