//
//  HCollView+DataProcessing.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 数据处理扩展
///
/// 提供数据过滤、搜索和排序功能
extension HCollView {
    
    /// 数据过滤管理器
    class DataFilterManager {
        
        // MARK: - 属性
        
        /// 过滤条件
        private var filters: [String: Any] = [:]
        
        /// 过滤回调
        var filterCallback: (([String: Any]) -> Void)?
        
        // MARK: - 方法
        
        /// 添加过滤条件
        /// - Parameters:
        ///   - key: 过滤键
        ///   - value: 过滤值
        func addFilter(key: String, value: Any) {
            filters[key] = value
            notifyFilterChanged()
        }
        
        /// 移除过滤条件
        /// - Parameter key: 过滤键
        func removeFilter(key: String) {
            filters.removeValue(forKey: key)
            notifyFilterChanged()
        }
        
        /// 清除所有过滤条件
        func clearFilters() {
            filters.removeAll()
            notifyFilterChanged()
        }
        
        /// 获取过滤条件
        /// - Returns: 过滤条件字典
        func getFilters() -> [String: Any] {
            return filters
        }
        
        /// 检查是否有过滤条件
        /// - Returns: 是否有过滤条件
        func hasFilters() -> Bool {
            return !filters.isEmpty
        }
        
        /// 通知过滤条件变化
        private func notifyFilterChanged() {
            filterCallback?(filters)
        }
    }
    
    /// 数据搜索管理器
    class DataSearchManager {
        
        // MARK: - 属性
        
        /// 搜索关键词
        private var searchText: String = ""
        
        /// 搜索回调
        var searchCallback: ((String) -> Void)?
        
        /// 搜索历史
        private var searchHistory: [String] = []
        
        /// 最大历史记录数量
        private let maxHistoryCount: Int = 10
        
        // MARK: - 方法
        
        /// 设置搜索关键词
        /// - Parameter text: 搜索关键词
        func setSearchText(_ text: String) {
            searchText = text
            
            // 添加到搜索历史
            if !text.isEmpty {
                addToHistory(text)
            }
            
            notifySearchChanged()
        }
        
        /// 获取搜索关键词
        /// - Returns: 搜索关键词
        func getSearchText() -> String {
            return searchText
        }
        
        /// 清除搜索
        func clearSearch() {
            searchText = ""
            notifySearchChanged()
        }
        
        /// 获取搜索历史
        /// - Returns: 搜索历史数组
        func getSearchHistory() -> [String] {
            return searchHistory
        }
        
        /// 清除搜索历史
        func clearSearchHistory() {
            searchHistory.removeAll()
        }
        
        /// 添加到搜索历史
        /// - Parameter text: 搜索关键词
        private func addToHistory(_ text: String) {
            // 移除已存在的相同关键词
            searchHistory.removeAll { $0 == text }
            
            // 添加到历史记录开头
            searchHistory.insert(text, at: 0)
            
            // 限制历史记录数量
            if searchHistory.count > maxHistoryCount {
                searchHistory.removeLast(searchHistory.count - maxHistoryCount)
            }
        }
        
        /// 通知搜索变化
        private func notifySearchChanged() {
            searchCallback?(searchText)
        }
    }
    
    /// 数据排序管理器
    class DataSortManager {
        
        // MARK: - 排序类型
        enum SortType {
            case ascending  // 升序
            case descending // 降序
        }
        
        // MARK: - 属性
        
        /// 排序键
        private var sortKey: String = ""
        
        /// 排序类型
        private var sortType: SortType = .ascending
        
        /// 排序回调
        var sortCallback: ((String, SortType) -> Void)?
        
        // MARK: - 方法
        
        /// 设置排序
        /// - Parameters:
        ///   - key: 排序键
        ///   - type: 排序类型
        func setSort(key: String, type: SortType) {
            sortKey = key
            sortType = type
            notifySortChanged()
        }
        
        /// 获取排序键
        /// - Returns: 排序键
        func getSortKey() -> String {
            return sortKey
        }
        
        /// 获取排序类型
        /// - Returns: 排序类型
        func getSortType() -> SortType {
            return sortType
        }
        
        /// 清除排序
        func clearSort() {
            sortKey = ""
            sortType = .ascending
            notifySortChanged()
        }
        
        /// 切换排序类型
        func toggleSortType() {
            sortType = sortType == .ascending ? .descending : .ascending
            notifySortChanged()
        }
        
        /// 通知排序变化
        private func notifySortChanged() {
            sortCallback?(sortKey, sortType)
        }
    }
    
    /// 数据处理管理器
    class DataProcessingManager {
        
        // MARK: - 属性
        
        /// 过滤管理器
        let filterManager = DataFilterManager()
        
        /// 搜索管理器
        let searchManager = DataSearchManager()
        
        /// 排序管理器
        let sortManager = DataSortManager()
        
        // MARK: - 方法
        
        /// 重置所有数据处理状态
        func reset() {
            filterManager.clearFilters()
            searchManager.clearSearch()
            searchManager.clearSearchHistory()
            sortManager.clearSort()
        }
    }
    
    /// 数据处理管理器
    var dataProcessingManager: DataProcessingManager {
        get {
            if let manager = objc_getAssociatedObject(self, &dataProcessingManagerKey) as? DataProcessingManager {
                return manager
            } else {
                let manager = DataProcessingManager()
                objc_setAssociatedObject(self, &dataProcessingManagerKey, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return manager
            }
        }
        set {
            objc_setAssociatedObject(self, &dataProcessingManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 设置过滤条件
    /// - Parameters:
    ///   - key: 过滤键
    ///   - value: 过滤值
    func setFilter(key: String, value: Any) {
        dataProcessingManager.filterManager.addFilter(key: key, value: value)
    }
    
    /// 移除过滤条件
    /// - Parameter key: 过滤键
    func removeFilter(key: String) {
        dataProcessingManager.filterManager.removeFilter(key: key)
    }
    /// 清除所有过滤条件
    func clearFilters() {
        dataProcessingManager.filterManager.clearFilters()
    }
    
    /// 设置搜索关键词
    /// - Parameter text: 搜索关键词
    func setSearchText(_ text: String) {
        dataProcessingManager.searchManager.setSearchText(text)
    }
    
    /// 清除搜索
    func clearSearch() {
        dataProcessingManager.searchManager.clearSearch()
    }
    
    /// 获取搜索历史
    /// - Returns: 搜索历史数组
    func getSearchHistory() -> [String] {
        return dataProcessingManager.searchManager.getSearchHistory()
    }
    
    /// 清除搜索历史
    func clearSearchHistory() {
        dataProcessingManager.searchManager.clearSearchHistory()
    }
    
    /// 设置排序
    /// - Parameters:
    ///   - key: 排序键
    ///   - type: 排序类型
    func setSort(key: String, type: DataSortManager.SortType) {
        dataProcessingManager.sortManager.setSort(key: key, type: type)
    }
    
    /// 清除排序
    func clearSort() {
        dataProcessingManager.sortManager.clearSort()
    }
    
    /// 切换排序类型
    func toggleSortType() {
        dataProcessingManager.sortManager.toggleSortType()
    }
    
    /// 重置数据处理状态
    func resetDataProcessing() {
        dataProcessingManager.reset()
    }
}

// 关联对象键
private var dataProcessingManagerKey: UInt8 = 0
