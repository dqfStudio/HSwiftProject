//
//  HWaterfallMutiSectionFlowLayout.swift
//  HSwiftProject
//
//  Created by owner on 2023/10/20.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

@objc protocol HWaterfallMutiSectionDelegate: NSObjectProtocol {
    /// item高度
    func heightForItemAtIndexPath(_ indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat
  
    /// 每个section 列数（默认2列）
    @objc optional func numberOfColumnsInSection( _ section: Int) -> Int

    /// header高度（默认为0）
    @objc optional func referenceSizeForHeaderInSection(_ section: Int) -> CGSize

    /// footer高度（默认为0）
    @objc optional func referenceSizeForFooterInSection(_ section: Int) -> CGSize

    /// 每个section 边距（默认为0）
    @objc optional func insetForSection( _ section: Int) -> UIEdgeInsets

    /// 每个section item上下间距（默认为0）
    @objc optional func lineSpacingForSection( _ section: Int) -> CGFloat

    /// 每个section item左右间距（默认为0）
    @objc optional func interitemSpacingForSection( _ section: Int) -> CGFloat

    /// section头部header与上个section尾部footer间距（默认为0）
    @objc optional func spacingForLastSection( _ section: Int) -> CGFloat
}

class HWaterfallMutiSectionFlowLayout: UICollectionViewFlowLayout {
    
    weak var delegate: HWaterfallMutiSectionDelegate?
    private var sectionInsets: UIEdgeInsets = .zero
    private var columnCount: Int = 2
    private var lineSpacing: CGFloat = 0.0
    private var interitemSpacing: CGFloat = 0.0
    private var headerSize: CGSize = .zero
    private var footerSize: CGSize = .zero

    //存放attribute的数组
    private var attrsArray: [UICollectionViewLayoutAttributes] = []
    //存放每个section中各个列的最后一个高度
    private var columnHeights: [CGFloat] = []
    //collectionView的Content的高度
    private var contentHeight: CGFloat = 0.0
    //记录上个section高度最高一列的高度
    private var lastContentHeight: CGFloat = 0.0
    //每个section的header与上个section的footer距离
    private var spacingForLastSection: CGFloat = 0.0
  
    override func prepare() {
        super.prepare()
        self.contentHeight = 0.0
        self.lastContentHeight = 0.0
        self.spacingForLastSection = 0.0
        self.lineSpacing = 0.0
        self.sectionInsets = .zero
        self.headerSize = .zero
        self.footerSize = .zero
        self.columnHeights.removeAll()
        self.attrsArray.removeAll()

        guard let delegate = self.delegate, let collectionView = self.collectionView else { return }
        let sectionCount = collectionView.numberOfSections
        // 遍历section
        for section in 0..<sectionCount {
            let indexPath = IndexPath(item: 0, section: section)
            if let columnCount = delegate.numberOfColumnsInSection?(section) {
                self.columnCount = columnCount
            }
            if let inset = delegate.insetForSection?(section) {
                self.sectionInsets = inset
            }
            if let spacingLastSection = delegate.spacingForLastSection?(section) {
                self.spacingForLastSection = spacingLastSection
            }
            // 生成header
            let itemCount = collectionView.numberOfItems(inSection: section)
            let headerAttri = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            if let header = headerAttri {
                self.attrsArray.append(header)
                self.columnHeights.removeAll()
            }
            self.lastContentHeight = self.contentHeight
            // 初始化区y值
            for _ in 0..<self.columnCount {
                self.columnHeights.append(self.contentHeight)
            }
            // 多少个item
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                let attri = self.layoutAttributesForItem(at: indexPath)
                if let attri = attri {
                    self.attrsArray.append(attri)
                }
            }
            // 初始化footer
            let footerAttri = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath)
            if let footer = footerAttri {
                self.attrsArray.append(footer)
            }
        }
    }
  
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attrsArray
    }
  
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let delegate = self.delegate, let collectionView = self.collectionView else { return nil }
        if let columnCount = delegate.numberOfColumnsInSection?(indexPath.section) {
            self.columnCount = columnCount
        }
        if let lineSpacing = delegate.lineSpacingForSection?(indexPath.section) {
            self.lineSpacing = lineSpacing
        }
        if let interitem = delegate.interitemSpacingForSection?(indexPath.section) {
            self.interitemSpacing = interitem
        }

        let attri = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let weight = collectionView.frame.size.width
        let itemSpacing = CGFloat(self.columnCount - 1) * self.interitemSpacing
        let allWeight = weight - self.sectionInsets.left - self.sectionInsets.right - itemSpacing
        let cellWeight = allWeight / CGFloat(self.columnCount)
        let cellHeight = delegate.heightForItemAtIndexPath(indexPath, itemWidth: cellWeight)

        var tmpMinColumn = 0
        var minColumnHeight = self.columnHeights[0]
        for i in 0..<self.columnCount {
            let columnH = self.columnHeights[i]
            if minColumnHeight > columnH {
                minColumnHeight = columnH
                tmpMinColumn = i
            }
        }
        let cellX = self.sectionInsets.left + CGFloat(tmpMinColumn) * (cellWeight + self.interitemSpacing)
        var cellY: CGFloat = 0.0
        cellY = minColumnHeight
        if cellY != self.lastContentHeight {
            cellY += self.lineSpacing
        }

        if self.contentHeight < minColumnHeight {
            self.contentHeight = minColumnHeight
        }

        attri.frame = CGRect(x: cellX, y: cellY, width: cellWeight, height: cellHeight)
        self.columnHeights[tmpMinColumn] = attri.frame.maxY
        //取最大的
        for i in 0..<self.columnHeights.count {
            if self.contentHeight < self.columnHeights[i] {
                self.contentHeight = self.columnHeights[i]
            }
        }

        return attri
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let delegate = self.delegate else { return nil }
        let attri = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        if elementKind == UICollectionView.elementKindSectionHeader {
            if let headerSize = delegate.referenceSizeForHeaderInSection?(indexPath.section) {
                self.headerSize = headerSize
            }
            self.contentHeight += self.spacingForLastSection
            attri.frame = CGRect(x: 0, y: self.contentHeight, width: self.headerSize.width, height: self.headerSize.height)
            self.contentHeight += self.headerSize.height
            self.contentHeight += self.sectionInsets.top
        }else if elementKind == UICollectionView.elementKindSectionFooter {
            if let footerSize = delegate.referenceSizeForFooterInSection?(indexPath.section) {
                self.footerSize = footerSize
            }
            self.contentHeight += self.sectionInsets.bottom
            attri.frame = CGRect(x: 0, y: self.contentHeight, width: self.footerSize.width, height: self.footerSize.height)
            self.contentHeight += self.footerSize.height
        }
        return attri
    }
  
    override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else { return CGSize.zero }
        return CGSize(width: collectionView.frame.size.width, height: self.contentHeight)
    }
    
}


