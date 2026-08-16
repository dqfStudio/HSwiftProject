//
//  HCollViewLayout.swift
//  HSwiftProject
//
//  Created by owner on 2023/10/20.
//  Copyright © 2023 wind. All rights reserved.
//
//  瀑布流 / self-sizing 布局：最短列排列、header/footer 吸顶、section 背景。
//

import UIKit

/// section 背景色走 Decoration View，由布局向代理询问颜色。
@objc protocol HCollViewLayoutDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, colorForSectionAt section: NSInteger) -> UIColor
}

enum HCollViewLayoutMode {
    /// `prepare()` 全量计算，高度来自 `sizeForItemAtIndexPath`，item 落到当前最短列。
    case waterfall
    /// `prepare()` 用 `estimatedItemSize` 占位，真实高度由 cell 的 `preferredLayoutAttributesFitting` 回写。
    case selfSizing
}

/// 瀑布流 / self-sizing 布局。每个 section 可独立列数；header / footer 可吸顶；section 背景用 decoration view。
class HCollViewLayout: UICollectionViewFlowLayout {

    // MARK: - 公开属性

    var layoutMode: HCollViewLayoutMode = .waterfall
    
    // MARK: - 常量
    
    private enum LayoutConstants {
        static let defaultColumnCount = 2
        static let floatEpsilon: CGFloat = 0.0001
        static let minItemHeight: CGFloat = 1.0
        static let minItemWidth: CGFloat = 1.0
        static let sectionColorKind = "com.dqf.HCollElementKindSectionColor"
    }
    
    // MARK: - Section 配置缓存
    
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
    
    // MARK: - 布局状态
    
    private var sectionInsets: UIEdgeInsets = .zero
    private var columnCount: Int = LayoutConstants.defaultColumnCount
    private var lineSpacing: CGFloat = 0.0
    private var interitemSpacing: CGFloat = 0.0

    private var attrsArray: [UICollectionViewLayoutAttributes] = []
    private var decorationAttrsArray: [UICollectionViewLayoutAttributes] = []
    private var columnHeights: [CGFloat] = []
    private var cntHeight: CGFloat = 0.0
    private var lastCntHeight: CGFloat = 0.0
    /// 仅 bounds 滚动失效时为 true，prepare 不再全量重算，吸顶在 `layoutAttributesForElements` 里调。
    private var skipFullPrepare = false
    /// `invalidationContext(forBoundsChange:)` 里置位，避免 self-sizing 失效也被当成滚动跳过 prepare。
    private var pendingBoundsOnlyInvalidation = false
  
    // MARK: - 初始化
    
    override init() {
        super.init()
        self.register(HCollSectionBackgroundView.self, forDecorationViewOfKind: LayoutConstants.sectionColorKind)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.register(HCollSectionBackgroundView.self, forDecorationViewOfKind: LayoutConstants.sectionColorKind)
    }
  
    // MARK: - prepare
    
    override func prepare() {
        super.prepare()
        if skipFullPrepare, !attrsArray.isEmpty {
            return
        }
        skipFullPrepare = false
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
            }

            // 无论有没有 header / footer，都要加上 section inset。
            let sectionStartY = self.cntHeight
            self.cntHeight += config.sectionInsets.top
            self.lastCntHeight = self.cntHeight
            self.columnHeights.removeAll()
            for _ in 0..<self.columnCount {
                self.columnHeights.append(self.cntHeight)
            }
            
            switch layoutMode {
            case .waterfall:
                for item in 0..<itemCount {
                    let indexPath = IndexPath(item: item, section: section)
                    if let attri = self.waterfallLayoutAttributesForItem(at: indexPath) {
                        self.attrsArray.append(attri)
                    }
                }
                
            case .selfSizing:
                let estimatedH = max(estimatedItemSize.height, LayoutConstants.minItemHeight)
                for item in 0..<itemCount {
                    let indexPath = IndexPath(item: item, section: section)
                    if let attri = selfSizingLayoutAttributesForItem(at: indexPath, estimatedHeight: estimatedH) {
                        self.attrsArray.append(attri)
                    }
                }
            }

            self.cntHeight = self.columnHeights.max() ?? self.cntHeight
            self.cntHeight += config.sectionInsets.bottom

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
                self.cntHeight += config.footerSize.height
            }

            self.createSectionBackground(for: section,
                                        startY: sectionStartY,
                                        endY: self.cntHeight,
                                        config: config)
        }
    }
  
    // MARK: - Attributes
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collView = self.collectionView as? HCollView else { 
            return copiedAttributes(attrsArray) + copiedAttributes(decorationAttrsArray)
        }

        let pinHeaders = collView.sectionHeadersPinToVisibleBounds
        let pinFooters = collView.sectionFootersPinToVisibleBounds

        var visibleAttrs = self.attrsArray.filter { $0.frame.intersects(rect) }
        if pinHeaders {
            appendSupplementaryIfNeeded(&visibleAttrs, kind: UICollectionView.elementKindSectionHeader)
        }
        if pinFooters {
            appendSupplementaryIfNeeded(&visibleAttrs, kind: UICollectionView.elementKindSectionFooter)
        }

        let visibleDecorationAttrs = self.decorationAttrsArray.filter { $0.frame.intersects(rect) }
        let copiedDecoration = copiedAttributes(visibleDecorationAttrs)
        
        guard pinHeaders || pinFooters else {
            return copiedAttributes(visibleAttrs) + copiedDecoration
        }
        
        var adjustedAttrs = copiedAttributes(visibleAttrs)
        
        if pinHeaders {
            adjustStickyHeaders(&adjustedAttrs, visibleRect: rect)
        }
        
        if pinFooters {
            adjustStickyFooters(&adjustedAttrs, visibleRect: rect)
        }
        
        return adjustedAttrs + copiedDecoration
    }

    /// UIKit 单独问某个 item 时只查 prepare 结果，不能再改列高；返回副本以免系统改掉缓存。
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        copiedAttribute(attrsArray.first { $0.representedElementCategory == .cell && $0.indexPath == indexPath })
    }

    private func appendSupplementaryIfNeeded(_ attrs: inout [UICollectionViewLayoutAttributes], kind: String) {
        for attr in attrsArray where attr.representedElementKind == kind {
            let already = attrs.contains {
                $0.representedElementKind == kind && $0.indexPath == attr.indexPath
            }
            if !already {
                attrs.append(attr)
            }
        }
    }

    private func copiedAttribute(_ attr: UICollectionViewLayoutAttributes?) -> UICollectionViewLayoutAttributes? {
        attr?.copy() as? UICollectionViewLayoutAttributes
    }

    private func copiedAttributes(_ attrs: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes] {
        attrs.map { $0.copy() as! UICollectionViewLayoutAttributes }
    }
    
    // MARK: - 瀑布流
    
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
        let itemWidth = max(rowWidth / CGFloat(self.columnCount), LayoutConstants.minItemWidth)
        
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
    
    // MARK: - Self-sizing 占位
    
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
        let itemWidth = max(rowWidth / CGFloat(self.columnCount), LayoutConstants.minItemWidth)
        
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
    
    // MARK: - Self-sizing 回写
    
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
        copiedAttribute(attrsArray.first { $0.representedElementKind == elementKind && $0.indexPath == indexPath })
    }
    
    override func layoutAttributesForDecorationView(ofKind decorationViewKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        copiedAttribute(decorationAttrsArray.first {
            $0.indexPath == indexPath && $0.representedElementKind == decorationViewKind
        })
    }
  
    override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else { return CGSize.zero }
        return CGSize(width: collectionView.bounds.width, height: self.cntHeight)
    }
    
    // MARK: - Header / Footer 吸顶
    
    private func adjustStickyHeaders(_ attrs: inout [UICollectionViewLayoutAttributes], 
                                     visibleRect: CGRect) {
        let headers = attrs.filter {
            $0.representedElementKind == UICollectionView.elementKindSectionHeader
        }.sorted { $0.indexPath.section < $1.indexPath.section }
        
        guard !headers.isEmpty else { return }
        let originalFrames = headers.map { $0.frame }
        
        for (index, headerAttr) in headers.enumerated() {
            let originalFrame = originalFrames[index]
            var stickyY = max(originalFrame.origin.y, visibleRect.minY)
            if index + 1 < originalFrames.count {
                stickyY = min(stickyY, originalFrames[index + 1].origin.y - originalFrame.height)
            }
            guard abs(stickyY - originalFrame.origin.y) > LayoutConstants.floatEpsilon else { continue }
            var newFrame = originalFrame
            newFrame.origin.y = stickyY
            headerAttr.frame = newFrame
            headerAttr.zIndex = 1024
        }
    }
    
    private func adjustStickyFooters(_ attrs: inout [UICollectionViewLayoutAttributes], 
                                     visibleRect: CGRect) {
        let footers = attrs.filter {
            $0.representedElementKind == UICollectionView.elementKindSectionFooter
        }.sorted { $0.indexPath.section < $1.indexPath.section }
        
        guard !footers.isEmpty else { return }
        let originalFrames = footers.map { $0.frame }
        
        for (index, footerAttr) in footers.enumerated() {
            let originalFrame = originalFrames[index]
            var stickyY = min(originalFrame.origin.y, visibleRect.maxY - originalFrame.height)
            if index > 0 {
                stickyY = max(stickyY, originalFrames[index - 1].maxY)
            }
            guard abs(stickyY - originalFrame.origin.y) > LayoutConstants.floatEpsilon else { continue }
            var newFrame = originalFrame
            newFrame.origin.y = stickyY
            footerAttr.frame = newFrame
            footerAttr.zIndex = 1024
        }
    }
    
    // MARK: - Section 背景
    
    private func fetchBackgroundColor(for section: Int, collectionView: HCollView) -> UIColor? {
        if let delegate = collectionView.delegate as? HCollViewLayoutDelegate {
            return delegate.collectionView(collectionView, layout: self, colorForSectionAt: section)
        }
        return nil
    }
    
    private func createSectionBackground(for section: Int,
                                        startY: CGFloat,
                                        endY: CGFloat,
                                        config: SectionConfig) {
        guard config.backgroundColor != nil && config.backgroundColor != .clear else { return }
        guard let collView = self.collectionView else { return }
        let height = max(endY - startY, 0)
        guard height > 0 else { return }

        let attr = HCollSectionBackgroundAttributes(
            forDecorationViewOfKind: LayoutConstants.sectionColorKind,
            with: IndexPath(item: 0, section: section)
        )
        attr.frame = CGRect(x: 0, y: startY, width: collView.bounds.width, height: height)
        attr.zIndex = -1
        attr.backgroundColor = config.backgroundColor
        self.decorationAttrsArray.append(attr)
    }
    
    // MARK: - 失效

    /// 宽度变化整表重算；吸顶开启时滚动也失效，但不走全量 prepare。
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldWidth = collectionView?.bounds.width ?? 0
        if abs(newBounds.width - oldWidth) > LayoutConstants.floatEpsilon {
            return true
        }
        return sectionHeadersPinToVisibleBounds || sectionFootersPinToVisibleBounds
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        let widthChanged = abs(newBounds.width - (collectionView?.bounds.width ?? 0)) > LayoutConstants.floatEpsilon
        if let flow = context as? UICollectionViewFlowLayoutInvalidationContext {
            flow.invalidateFlowLayoutDelegateMetrics = widthChanged
            flow.invalidateFlowLayoutAttributes = widthChanged
        }
        pendingBoundsOnlyInvalidation = !widthChanged
        return context
    }

    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if context.invalidateEverything || context.invalidateDataSourceCounts {
            skipFullPrepare = false
            pendingBoundsOnlyInvalidation = false
        } else if pendingBoundsOnlyInvalidation {
            skipFullPrepare = !attrsArray.isEmpty
            pendingBoundsOnlyInvalidation = false
        } else {
            skipFullPrepare = false
        }
        super.invalidateLayout(with: context)
    }
}

// MARK: - Section 背景 View

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
