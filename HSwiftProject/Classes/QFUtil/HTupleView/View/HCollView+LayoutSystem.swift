//
//  HCollView+LayoutSystem.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 布局系统扩展
///
/// 提供更多高级布局类型和布局组合功能
extension HCollView {
    
    /// 布局类型
    enum LayoutType {
        case flow         // 流式布局
        case grid         // 网格布局
        case waterfall    // 瀑布流布局
        case masonry      //  masonry 布局
        case timeline     // 时间线布局
        case card         // 卡片布局
        case horizontal   // 水平滚动布局
        case vertical     // 垂直滚动布局
        case custom       // 自定义布局
    }
    
    /// 布局管理器
    class LayoutManager {
        
        // MARK: - 单例
        static let shared = LayoutManager()
        private init() {}
        
        // MARK: - 属性
        
        /// 当前布局类型
        private var currentLayoutType: LayoutType = .flow
        
        /// 布局缓存
        private var layoutCache: [LayoutType: UICollectionViewLayout] = [:]
        
        // MARK: - 方法
        
        /// 创建布局
        /// - Parameters:
        ///   - type: 布局类型
        ///   - configuration: 布局配置
        /// - Returns: 布局对象
        func createLayout(_ type: LayoutType, configuration: [String: Any] = [:]) -> UICollectionViewLayout {
            if let cachedLayout = layoutCache[type] {
                return cachedLayout
            }
            
            var layout: UICollectionViewLayout
            
            switch type {
            case .flow:
                layout = createFlowLayout(configuration)
            case .grid:
                layout = createGridLayout(configuration)
            case .waterfall:
                layout = createWaterfallLayout(configuration)
            case .masonry:
                layout = createMasonryLayout(configuration)
            case .timeline:
                layout = createTimelineLayout(configuration)
            case .card:
                layout = createCardLayout(configuration)
            case .horizontal:
                layout = createHorizontalLayout(configuration)
            case .vertical:
                layout = createVerticalLayout(configuration)
            case .custom:
                if let customLayout = configuration["layout"] as? UICollectionViewLayout {
                    layout = customLayout
                } else {
                    layout = createFlowLayout(configuration)
                }
            }
            
            layoutCache[type] = layout
            currentLayoutType = type
            
            return layout
        }
        
        /// 创建流式布局
        /// - Parameter configuration: 布局配置
        /// - Returns: 流式布局
        private func createFlowLayout(_ configuration: [String: Any]) -> UICollectionViewLayout {
            let layout = UICollectionViewFlowLayout()
            
            if let itemSize = configuration["itemSize"] as? CGSize {
                layout.itemSize = itemSize
            } else {
                layout.itemSize = CGSize(width: 100, height: 100)
            }
            
            if let minimumInteritemSpacing = configuration["minimumInteritemSpacing"] as? CGFloat {
                layout.minimumInteritemSpacing = minimumInteritemSpacing
            } else {
                layout.minimumInteritemSpacing = 10
            }
            
            if let minimumLineSpacing = configuration["minimumLineSpacing"] as? CGFloat {
                layout.minimumLineSpacing = minimumLineSpacing
            } else {
                layout.minimumLineSpacing = 10
            }
            
            if let sectionInset = configuration["sectionInset"] as? UIEdgeInsets {
                layout.sectionInset = sectionInset
            } else {
                layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
            
            return layout
        }
        
        /// 创建网格布局
        /// - Parameter configuration: 布局配置
        /// - Returns: 网格布局
        private func createGridLayout(_ configuration: [String: Any]) -> UICollectionViewLayout {
            let layout = UICollectionViewFlowLayout()
            
            let columns = configuration["columns"] as? Int ?? 3
            let spacing = configuration["spacing"] as? CGFloat ?? 10
            let insets = configuration["insets"] as? UIEdgeInsets ?? UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
            let itemWidth = (UIScreen.main.bounds.width - insets.left - insets.right - CGFloat(columns - 1) * spacing) / CGFloat(columns)
            let itemHeight = configuration["itemHeight"] as? CGFloat ?? itemWidth
            
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.minimumInteritemSpacing = spacing
            layout.minimumLineSpacing = spacing
            layout.sectionInset = insets
            
            return layout
        }
        
        /// 创建瀑布流布局
        /// - Parameter configuration: 布局配置
        /// - Returns: 瀑布流布局
        private func createWaterfallLayout(_ configuration: [String: Any]) -> UICollectionViewLayout {
            return HCollWaterfallLayout(configuration: configuration)
        }
        
        /// 创建 masonry 布局
        /// - Parameter configuration: 布局配置
        /// - Returns: masonry 布局
        private func createMasonryLayout(_ configuration: [String: Any]) -> UICollectionViewLayout {
            return HCollMasonryLayout(configuration: configuration)
        }
        
        /// 创建时间线布局
        /// - Parameter configuration: 布局配置
        /// - Returns: 时间线布局
        private func createTimelineLayout(_ configuration: [String: Any]) -> UICollectionViewLayout {
            return HCollTimelineLayout(configuration: configuration)
        }
        
        /// 创建卡片布局
        /// - Parameter configuration: 布局配置
        /// - Returns: 卡片布局
        private func createCardLayout(_ configuration: [String: Any]) -> UICollectionViewLayout {
            let layout = UICollectionViewFlowLayout()
            
            let itemWidth = UIScreen.main.bounds.width - 40
            let itemHeight = configuration["itemHeight"] as? CGFloat ?? 200
            
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            
            return layout
        }
        
        /// 创建水平滚动布局
        /// - Parameter configuration: 布局配置
        /// - Returns: 水平滚动布局
        private func createHorizontalLayout(_ configuration: [String: Any]) -> UICollectionViewLayout {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            if let itemSize = configuration["itemSize"] as? CGSize {
                layout.itemSize = itemSize
            } else {
                layout.itemSize = CGSize(width: 200, height: 200)
            }
            
            if let minimumInteritemSpacing = configuration["minimumInteritemSpacing"] as? CGFloat {
                layout.minimumInteritemSpacing = minimumInteritemSpacing
            } else {
                layout.minimumInteritemSpacing = 10
            }
            
            if let minimumLineSpacing = configuration["minimumLineSpacing"] as? CGFloat {
                layout.minimumLineSpacing = minimumLineSpacing
            } else {
                layout.minimumLineSpacing = 10
            }
            
            if let sectionInset = configuration["sectionInset"] as? UIEdgeInsets {
                layout.sectionInset = sectionInset
            } else {
                layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
            
            return layout
        }
        
        /// 创建垂直滚动布局
        /// - Parameter configuration: 布局配置
        /// - Returns: 垂直滚动布局
        private func createVerticalLayout(_ configuration: [String: Any]) -> UICollectionViewLayout {
            return createFlowLayout(configuration)
        }
        
        /// 切换布局
        /// - Parameters:
        ///   - type: 布局类型
        ///   - collectionView: 集合视图
        ///   - animated: 是否动画
        func switchLayout(_ type: LayoutType, in collectionView: UICollectionView, animated: Bool = true) {
            let layout = createLayout(type)
            collectionView.setCollectionViewLayout(layout, animated: animated)
        }
        
        /// 获取当前布局类型
        /// - Returns: 当前布局类型
        func getCurrentLayoutType() -> LayoutType {
            return currentLayoutType
        }
        
        /// 清除布局缓存
        func clearLayoutCache() {
            layoutCache.removeAll()
        }
    }
    
    /// 布局管理器
    var layoutManager: LayoutManager {
        return LayoutManager.shared
    }
    
    /// 设置布局
    /// - Parameters:
    ///   - type: 布局类型
    ///   - configuration: 布局配置
    ///   - animated: 是否动画
    func setLayout(_ type: LayoutType, configuration: [String: Any] = [:], animated: Bool = true) {
        let layout = layoutManager.createLayout(type, configuration: configuration)
        setCollectionViewLayout(layout, animated: animated)
    }
    
    /// 切换布局
    /// - Parameters:
    ///   - type: 布局类型
    ///   - animated: 是否动画
    func switchLayout(_ type: LayoutType, animated: Bool = true) {
        layoutManager.switchLayout(type, in: self, animated: animated)
    }
    
    /// 获取当前布局类型
    /// - Returns: 当前布局类型
    func getCurrentLayoutType() -> LayoutType {
        return layoutManager.getCurrentLayoutType()
    }
    
    /// 清除布局缓存
    func clearLayoutCache() {
        layoutManager.clearLayoutCache()
    }
}

/// 瀑布流布局
class HCollWaterfallLayout: UICollectionViewLayout {
    
    // MARK: - 属性
    
    private var itemAttributes: [UICollectionViewLayoutAttributes] = []
    private var columnHeights: [CGFloat] = []
    private var contentSize: CGSize = .zero
    
    private let columns: Int
    private let spacing: CGFloat
    private let insets: UIEdgeInsets
    
    // MARK: - 初始化
    
    init(configuration: [String: Any] = [:]) {
        self.columns = configuration["columns"] as? Int ?? 2
        self.spacing = configuration["spacing"] as? CGFloat ?? 10
        self.insets = configuration["insets"] as? UIEdgeInsets ?? UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewLayout
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        itemAttributes.removeAll()
        columnHeights = Array(repeating: insets.top, count: columns)
        
        let itemWidth = (collectionView.bounds.width - insets.left - insets.right - CGFloat(columns - 1) * spacing) / CGFloat(columns)
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                
                // 找到高度最小的列
                var minHeight = columnHeights[0]
                var minColumn = 0
                for (i, height) in columnHeights.enumerated() {
                    if height < minHeight {
                        minHeight = height
                        minColumn = i
                    }
                }
                
                // 计算 item 位置
                let x = insets.left + CGFloat(minColumn) * (itemWidth + spacing)
                let y = minHeight
                
                // 随机高度（实际应用中应该根据内容计算）
                let itemHeight = CGFloat(arc4random_uniform(100)) + 100
                
                // 创建布局属性
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
                itemAttributes.append(attributes)
                
                // 更新列高度
                columnHeights[minColumn] = y + itemHeight + spacing
            }
        }
        
        // 计算内容大小
        let maxHeight = columnHeights.max() ?? 0
        contentSize = CGSize(width: collectionView.bounds.width, height: maxHeight + insets.bottom - spacing)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemAttributes.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes.first { $0.indexPath == indexPath }
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
}

/// Masonry 布局
class HCollMasonryLayout: UICollectionViewLayout {
    
    // MARK: - 属性
    
    private var itemAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = .zero
    
    private let spacing: CGFloat
    private let insets: UIEdgeInsets
    
    // MARK: - 初始化
    
    init(configuration: [String: Any] = [:]) {
        self.spacing = configuration["spacing"] as? CGFloat ?? 10
        self.insets = configuration["insets"] as? UIEdgeInsets ?? UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewLayout
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        itemAttributes.removeAll()
        
        var y: CGFloat = insets.top
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                
                // 随机宽度和高度（实际应用中应该根据内容计算）
                let itemWidth = CGFloat(arc4random_uniform(100)) + 100
                let itemHeight = CGFloat(arc4random_uniform(100)) + 100
                
                // 计算 x 位置（居中）
                let x = (collectionView.bounds.width - itemWidth) / 2
                
                // 创建布局属性
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
                itemAttributes.append(attributes)
                
                // 更新 y 位置
                y += itemHeight + spacing
            }
        }
        
        // 计算内容大小
        contentSize = CGSize(width: collectionView.bounds.width, height: y + insets.bottom - spacing)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemAttributes.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes.first { $0.indexPath == indexPath }
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
}

/// 时间线布局
class HCollTimelineLayout: UICollectionViewLayout {
    
    // MARK: - 属性
    
    private var itemAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = .zero
    
    private let lineWidth: CGFloat = 2
    private let dotSize: CGFloat = 10
    private let spacing: CGFloat = 20
    private let insets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 20)
    
    // MARK: - 初始化
    
    init(configuration: [String: Any] = [:]) {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewLayout
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        itemAttributes.removeAll()
        
        var y: CGFloat = insets.top
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                
                // 固定宽度，高度根据内容计算
                let itemWidth = collectionView.bounds.width - insets.left - insets.right
                let itemHeight = CGFloat(arc4random_uniform(100)) + 100
                
                // 创建布局属性
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: insets.left, y: y, width: itemWidth, height: itemHeight)
                itemAttributes.append(attributes)
                
                // 更新 y 位置
                y += itemHeight + spacing
            }
        }
        
        // 计算内容大小
        contentSize = CGSize(width: collectionView.bounds.width, height: y + insets.bottom - spacing)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemAttributes.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes.first { $0.indexPath == indexPath }
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
}
