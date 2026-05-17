//
//  HCollViewLayout.swift
//  HSwiftProject
//
//  Created by owner on 2023/10/20.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

/// Extend the background color of the section
@objc protocol HCollViewLayoutDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, colorForSectionAt section: NSInteger) -> UIColor
}

/// 布局模式
enum HCollViewLayoutMode {
    /// 瀑布流模式：prepare() 中全量计算所有 item，通过 sizeForItemAtIndexPath 获取高度
    case waterfall
    /// Self-sizing 模式：prepare() 中用估计高度占位，由 cell 的 preferredLayoutAttributesFitting 返回真实高度
    /// 适用于 cell 使用 Auto Layout / SnapKit 布局的场景，图片下载后自动撑高
    case selfSizing
}

/// HCollView 自定义布局
///
/// 两种布局模式：
/// - `.waterfall`：多列瀑布流，全量计算，高度由 sizeForItemAtIndexPath 决定
/// - `.selfSizing`：单列或多列，支持 self-sizing（estimatedItemSize），cell 自动撑高
///
/// 支持特性:
/// - 多列瀑布流布局,每个 Section 可独立配置列数
/// - Header/Footer 吸顶(Sticky)功能
/// - Section 背景色扩展(Decoration View)
/// - 动态 Item 高度,自动排列到最短列
/// - Section 配置缓存,提升性能
class HCollViewLayout: UICollectionViewFlowLayout {
    
    // MARK: - Public Properties
    
    /// 布局模式，默认 waterfall
    var layoutMode: HCollViewLayoutMode = .waterfall
    
    // MARK: - Constants
    
    private enum LayoutConstants {
        static let defaultColumnCount = 2
        static let floatEpsilon: CGFloat = 0.0001
        static let minItemHeight: CGFloat = 1.0
        static let minItemWidth: CGFloat = 1.0
        static let sectionColorKind = "com.dqf.HCollElementKindSectionColor"
    }
    
    // MARK: - Section Config Cache
    
    private struct SectionConfig {
        let columnCount: Int
        let sectionInsets: UIEdgeInsets
        let lineSpacing: CGFloat
        let interitemSpacing: CGFloat
        let headerSize: CGSize
        let footerSize: CGSize
        let backgroundColor: UIColor?
    }
    
    private var sectionConfigs: [Int: SectionConfig] = [:]
    
    // MARK: - Layout State
    
    private var sectionInsets: UIEdgeInsets = .zero
    private var columnCount: Int = 2
    private var lineSpacing: CGFloat = 0.0
    private var interitemSpacing: CGFloat = 0.0

    private var attrsArray: [UICollectionViewLayoutAttributes] = []
    private var decorationAttrsArray: [UICollectionViewLayoutAttributes] = []
    private var columnHeights: [CGFloat] = []
    private var cntHeight: CGFloat = 0.0
    private var lastCntHeight: CGFloat = 0.0
  
    // MARK: - Initialization
    
    override init() {
        super.init()
        self.register(HCollSectionBackgroundView.self, forDecorationViewOfKind: LayoutConstants.sectionColorKind)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.register(HCollSectionBackgroundView.self, forDecorationViewOfKind: LayoutConstants.sectionColorKind)
    }
  
    // MARK: - Layout Preparation
    
    override func prepare() {
        super.prepare()
        
        // 重置所有状态
        self.cntHeight = 0.0
        self.lastCntHeight = 0.0
        self.lineSpacing = 0.0
        self.sectionInsets = .zero
        self.columnHeights.removeAll()
        self.attrsArray.removeAll()
        self.decorationAttrsArray.removeAll()
        self.sectionConfigs.removeAll(keepingCapacity: false)

        guard let collView = self.collectionView as? HCollView else {
            return
        }
        
        let sectionCount = collView.numberOfSections
        
        // 预获取所有 item attributes,用于计算 section 背景范围
        let allAttributes = super.layoutAttributesForElements(in: CGRect(x: -CGFloat.greatestFiniteMagnitude, 
                                                                          y: -CGFloat.greatestFiniteMagnitude, 
                                                                          width: CGFloat.greatestFiniteMagnitude, 
                                                                          height: CGFloat.greatestFiniteMagnitude)) ?? []
        
        var attributesBySection: [Int: [UICollectionViewLayoutAttributes]] = [:]
        for attr in allAttributes {
            if attr.representedElementCategory == .cell {
                attributesBySection[attr.indexPath.section, default: []].append(attr)
            }
        }
        
        for section in 0..<sectionCount {
            let backgroundColor = self.fetchBackgroundColor(for: section, collectionView: collView)
            
            let config = SectionConfig(
                columnCount: collView.collectionView(collView, numberOfColumnsInSection: section),
                sectionInsets: collView.collectionView(collView, layout: self, insetForSectionAt: section),
                lineSpacing: collView.collectionView(collView, layout: self, minimumLineSpacingForSectionAt: section),
                interitemSpacing: collView.collectionView(collView, layout: self, minimumInteritemSpacingForSectionAt: section),
                headerSize: collView.collectionView(collView, layout: self, referenceSizeForHeaderInSection: section),
                footerSize: collView.collectionView(collView, layout: self, referenceSizeForFooterInSection: section),
                backgroundColor: backgroundColor
            )
            self.sectionConfigs[section] = config
            
            self.columnCount = config.columnCount
            self.sectionInsets = config.sectionInsets
            
            let itemCount = collView.numberOfItems(inSection: section)

            // 处理 Header（两种模式共用）
            if config.headerSize.width > 0 && config.headerSize.height > 0 {
                let headerIndexPath = IndexPath(item: 0, section: section)
                let headerAttri = UICollectionViewLayoutAttributes(
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    with: headerIndexPath
                )
                headerAttri.frame = CGRect(
                    x: 0,
                    y: self.cntHeight,
                    width: config.headerSize.width,
                    height: config.headerSize.height
                )
                self.attrsArray.append(headerAttri)
                
                self.cntHeight += config.headerSize.height
                self.cntHeight += config.sectionInsets.top
                self.columnHeights.removeAll()
            }
            
            self.lastCntHeight = self.cntHeight
            
            // 初始化列高度
            for _ in 0..<self.columnCount {
                self.columnHeights.append(self.cntHeight)
            }
            
            let sectionStartY = self.cntHeight
            
            switch layoutMode {
            case .waterfall:
                // ── 瀑布流模式 ──
                // 全量计算所有 item，高度由 sizeForItemAtIndexPath 决定
                for item in 0..<itemCount {
                    let indexPath = IndexPath(item: item, section: section)
                    if let attri = self.waterfallLayoutAttributesForItem(at: indexPath) {
                        self.attrsArray.append(attri)
                    }
                }
                
            case .selfSizing:
                // ── Self-sizing 模式 ──
                // 用 estimatedItemSize 占位，系统通过 preferredLayoutAttributesFitting 获取真实高度
                let estimatedH = max(estimatedItemSize.height, LayoutConstants.minItemHeight)
                for item in 0..<itemCount {
                    let indexPath = IndexPath(item: item, section: section)
                    if let attri = selfSizingLayoutAttributesForItem(at: indexPath, estimatedHeight: estimatedH) {
                        self.attrsArray.append(attri)
                    }
                }
            }
            
            // 处理 Footer（两种模式共用）
            if config.footerSize.width > 0 && config.footerSize.height > 0 {
                let footerIndexPath = IndexPath(item: 0, section: section)
                let footerAttri = UICollectionViewLayoutAttributes(
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                    with: footerIndexPath
                )
                footerAttri.frame = CGRect(
                    x: 0,
                    y: self.cntHeight,
                    width: config.footerSize.width,
                    height: config.footerSize.height
                )
                self.attrsArray.append(footerAttri)
                
                self.cntHeight += config.sectionInsets.bottom
                self.cntHeight += config.footerSize.height
            }
            
            // 计算并创建 Section 背景色 Decoration View
            self.createSectionBackground(for: section, 
                                        startY: sectionStartY, 
                                        endY: self.cntHeight, 
                                        config: config, 
                                        itemAttributes: attributesBySection[section])
        }
    }
  
    // MARK: - Layout Attributes
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collView = self.collectionView as? HCollView else { 
            return self.attrsArray + self.decorationAttrsArray
        }
        
        let visibleAttrs = self.attrsArray.filter { $0.frame.intersects(rect) }
        let visibleDecorationAttrs = self.decorationAttrsArray.filter { $0.frame.intersects(rect) }
        
        var resultAttrs = visibleAttrs + visibleDecorationAttrs
        
        guard collView.sectionHeadersPinToVisibleBounds || 
              collView.sectionFootersPinToVisibleBounds else {
            return resultAttrs
        }
        
        var adjustedAttrs = visibleAttrs.map { $0.copy() as! UICollectionViewLayoutAttributes }
        
        if collView.sectionHeadersPinToVisibleBounds {
            adjustStickyHeaders(&adjustedAttrs, visibleRect: rect)
        }
        
        if collView.sectionFootersPinToVisibleBounds {
            adjustStickyFooters(&adjustedAttrs, visibleRect: rect)
        }
        
        return adjustedAttrs + visibleDecorationAttrs
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch layoutMode {
        case .waterfall:
            return waterfallLayoutAttributesForItem(at: indexPath)
        case .selfSizing:
            let estimatedH = max(estimatedItemSize.height, LayoutConstants.minItemHeight)
            return selfSizingLayoutAttributesForItem(at: indexPath, estimatedHeight: estimatedH)
        }
    }
    
    // MARK: - Waterfall Mode
    
    private func waterfallLayoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collView = self.collectionView as? HCollView,
              let config = self.sectionConfigs[indexPath.section] else { return nil }
        
        self.columnCount = config.columnCount
        self.lineSpacing = config.lineSpacing
        self.interitemSpacing = config.interitemSpacing
        self.sectionInsets = config.sectionInsets

        let attri = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let collWidth = collView.bounds.width
        let rowSpacing = CGFloat(self.columnCount - 1) * self.interitemSpacing
        let rowWidth = collWidth - self.sectionInsets.left - self.sectionInsets.right - rowSpacing
        let itemWidth = rowWidth / CGFloat(self.columnCount)
        
        let itemSize = collView.collectionView(collView, layout: self, sizeForItemAt: indexPath)
        guard itemSize.width >= LayoutConstants.minItemWidth &&
              itemSize.height >= LayoutConstants.minItemHeight else { return nil }
        
        if self.columnHeights.isEmpty {
            for _ in 0..<self.columnCount {
                self.columnHeights.append(self.lastCntHeight)
            }
        }
        guard !self.columnHeights.isEmpty else { return nil }
        
        guard let (minItemIndex, minItemHeight) = self.columnHeights.enumerated()
            .min(by: { $0.element < $1.element }) else { return nil }
        
        let itemX = self.sectionInsets.left + CGFloat(minItemIndex) * (itemWidth + self.interitemSpacing)
        var itemY = minItemHeight
        if abs(itemY - self.lastCntHeight) > LayoutConstants.floatEpsilon {
            itemY += self.lineSpacing
        }

        attri.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemSize.height)
        self.columnHeights[minItemIndex] = attri.frame.maxY
        if let maxHeight = self.columnHeights.max() {
            self.cntHeight = maxHeight
        }

        return attri
    }
    
    // MARK: - Self-Sizing Mode
    
    private func selfSizingLayoutAttributesForItem(at indexPath: IndexPath, estimatedHeight: CGFloat) -> UICollectionViewLayoutAttributes? {
        guard let collView = self.collectionView as? HCollView,
              let config = self.sectionConfigs[indexPath.section] else { return nil }
        
        self.columnCount = config.columnCount
        self.lineSpacing = config.lineSpacing
        self.interitemSpacing = config.interitemSpacing
        self.sectionInsets = config.sectionInsets

        let attri = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let collWidth = collView.bounds.width
        let rowSpacing = CGFloat(self.columnCount - 1) * self.interitemSpacing
        let rowWidth = collWidth - self.sectionInsets.left - self.sectionInsets.right - rowSpacing
        let itemWidth = rowWidth / CGFloat(self.columnCount)
        
        if self.columnHeights.isEmpty {
            for _ in 0..<self.columnCount {
                self.columnHeights.append(self.lastCntHeight)
            }
        }
        guard !self.columnHeights.isEmpty else { return nil }
        
        guard let (minItemIndex, minItemHeight) = self.columnHeights.enumerated()
            .min(by: { $0.element < $1.element }) else { return nil }
        
        let itemX = self.sectionInsets.left + CGFloat(minItemIndex) * (itemWidth + self.interitemSpacing)
        var itemY = minItemHeight
        if abs(itemY - self.lastCntHeight) > LayoutConstants.floatEpsilon {
            itemY += self.lineSpacing
        }
        
        attri.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: estimatedHeight)
        self.columnHeights[minItemIndex] = attri.frame.maxY
        if let maxHeight = self.columnHeights.max() {
            self.cntHeight = maxHeight
        }
        
        return attri
    }
    
    // MARK: - Self-sizing support via preferredLayoutAttributesFitting
    
    override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
                                          withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        guard layoutMode == .selfSizing else { return false }
        return abs(preferredAttributes.frame.height - originalAttributes.frame.height) > LayoutConstants.floatEpsilon
    }
    
    override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
                                       withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes,
                                                 withOriginalAttributes: originalAttributes)
        
        if layoutMode == .selfSizing {
            let indexPath = originalAttributes.indexPath
            context.invalidateItems(at: [indexPath])
            let section = indexPath.section
            context.invalidateSupplementaryElements(
                ofKind: UICollectionView.elementKindSectionHeader,
                at: [IndexPath(item: 0, section: section)]
            )
            context.invalidateSupplementaryElements(
                ofKind: UICollectionView.elementKindSectionFooter,
                at: [IndexPath(item: 0, section: section)]
            )
        }
        
        return context
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    override func layoutAttributesForDecorationView(ofKind decorationViewKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.decorationAttrsArray.first { 
            $0.indexPath == indexPath && $0.representedElementKind == decorationViewKind 
        }
    }
  
    override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else { return CGSize.zero }
        return CGSize(width: collectionView.bounds.width, height: self.cntHeight)
    }
    
    // MARK: - Sticky Header/Footer Logic
    
    private func adjustStickyHeaders(_ attrs: inout [UICollectionViewLayoutAttributes], 
                                     visibleRect: CGRect) {
        let headerData = attrs.compactMap { attr -> (IndexPath, UICollectionViewLayoutAttributes)? in
            guard attr.representedElementKind == UICollectionView.elementKindSectionHeader else { return nil }
            return (attr.indexPath, attr)
        }.sorted { $0.0.section < $1.0.section }
        
        guard !headerData.isEmpty else { return }
        
        for (index, (_, headerAttr)) in headerData.enumerated() {
            let originalFrame = headerAttr.frame
            if originalFrame.maxY <= visibleRect.minY { continue }
            if originalFrame.origin.y >= visibleRect.maxY { break }
            
            if originalFrame.origin.y < visibleRect.minY {
                var stickyY = visibleRect.minY
                if index + 1 < headerData.count {
                    let nextOriginalY = headerData[index + 1].1.frame.origin.y
                    if nextOriginalY < visibleRect.maxY {
                        let maxStickyY = nextOriginalY - originalFrame.height
                        if stickyY > maxStickyY { stickyY = maxStickyY }
                    }
                }
                var newFrame = originalFrame
                newFrame.origin.y = stickyY
                headerAttr.frame = newFrame
            }
        }
    }
    
    private func adjustStickyFooters(_ attrs: inout [UICollectionViewLayoutAttributes], 
                                     visibleRect: CGRect) {
        let footerData = attrs.compactMap { attr -> (IndexPath, UICollectionViewLayoutAttributes)? in
            guard attr.representedElementKind == UICollectionView.elementKindSectionFooter else { return nil }
            return (attr.indexPath, attr)
        }.sorted { $0.0.section < $1.0.section }
        
        guard !footerData.isEmpty else { return }
        
        for (index, (_, footerAttr)) in footerData.enumerated().reversed() {
            let originalFrame = footerAttr.frame
            if originalFrame.origin.y >= visibleRect.maxY { continue }
            if originalFrame.maxY <= visibleRect.minY { break }
            
            if originalFrame.maxY > visibleRect.maxY {
                var stickyY = visibleRect.maxY - originalFrame.height
                if index > 0 {
                    let prevMaxY = footerData[index - 1].1.frame.maxY
                    if stickyY < prevMaxY { stickyY = prevMaxY }
                }
                var newFrame = originalFrame
                newFrame.origin.y = stickyY
                footerAttr.frame = newFrame
            }
        }
    }
    
    // MARK: - Section Background Helper
    
    private func fetchBackgroundColor(for section: Int, collectionView: HCollView) -> UIColor? {
        if let delegate = collectionView.delegate as? HCollViewLayoutDelegate {
            return delegate.collectionView(collectionView, layout: self, colorForSectionAt: section)
        }
        return nil
    }
    
    private func createSectionBackground(for section: Int, 
                                        startY: CGFloat, 
                                        endY: CGFloat, 
                                        config: SectionConfig, 
                                        itemAttributes: [UICollectionViewLayoutAttributes]?) {
        guard config.backgroundColor != nil && config.backgroundColor != .clear else { return }
        guard let collView = self.collectionView else { return }
        
        var backgroundFrame: CGRect
        if let items = itemAttributes, !items.isEmpty {
            let firstItem = items.min(by: { $0.frame.minY < $1.frame.minY })
            let lastItem = items.max(by: { $0.frame.maxY < $1.frame.maxY })
            if let first = firstItem, let last = lastItem {
                var unionFrame = first.frame.union(last.frame)
                unionFrame.origin.x -= config.sectionInsets.left
                unionFrame.origin.y -= config.sectionInsets.top
                unionFrame.size.width += config.sectionInsets.left + config.sectionInsets.right
                unionFrame.size.height += config.sectionInsets.top + config.sectionInsets.bottom
                unionFrame.origin.x = 0
                unionFrame.size.width = collView.bounds.width
                backgroundFrame = unionFrame
            } else {
                backgroundFrame = CGRect(x: 0, y: startY, width: collView.bounds.width, height: endY - startY)
            }
        } else {
            backgroundFrame = CGRect(x: 0, y: startY, width: collView.bounds.width, height: endY - startY)
        }
        
        let indexPath = IndexPath(item: 0, section: section)
        let attr = HCollSectionBackgroundAttributes(forDecorationViewOfKind: LayoutConstants.sectionColorKind, with: indexPath)
        attr.frame = backgroundFrame
        attr.zIndex = -1
        attr.backgroundColor = config.backgroundColor
        self.decorationAttrsArray.append(attr)
    }
    
    // MARK: - Layout Invalidation
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds = self.collectionView?.bounds ?? .zero
        if abs(newBounds.width - oldBounds.width) > LayoutConstants.floatEpsilon {
            return true
        }
        return false
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        return super.invalidationContext(forBoundsChange: newBounds)
    }
}

// MARK: - Supporting Classes

private class HCollSectionBackgroundAttributes: UICollectionViewLayoutAttributes {
    var backgroundColor: UIColor?
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! HCollSectionBackgroundAttributes
        copy.backgroundColor = self.backgroundColor
        return copy
    }
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? HCollSectionBackgroundAttributes else { return false }
        return super.isEqual(other) && self.backgroundColor == other.backgroundColor
    }
}

private class HCollSectionBackgroundView: UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attr = layoutAttributes as? HCollSectionBackgroundAttributes,
              let backgroundColor = attr.backgroundColor,
              self.backgroundColor != backgroundColor else { return }
        self.backgroundColor = backgroundColor
    }
}
