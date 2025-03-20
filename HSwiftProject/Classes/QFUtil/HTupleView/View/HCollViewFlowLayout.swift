//
//  HCollViewFlowLayout.swift
//  HSwiftProject
//
//  Created by owner on 2023/10/20.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HCollViewFlowLayout: UICollectionViewFlowLayout {
    
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
    private var cntHeight: CGFloat = 0.0
    //记录上个section高度最高一列的高度
    private var lastCntHeight: CGFloat = 0.0
  
    override func prepare() {
        super.prepare()
        self.cntHeight = 0.0
        self.lastCntHeight = 0.0
        self.lineSpacing = 0.0
        self.sectionInsets = .zero
        self.headerSize = .zero
        self.footerSize = .zero
        self.columnHeights.removeAll()
        self.attrsArray.removeAll()

        guard let collView = self.collectionView as? HCollView else { return }
        let sectionCount = collView.numberOfSections
        // 遍历section
        for section in 0..<sectionCount {
            let indexPath = IndexPath(item: 0, section: section)

            // 获取每个section 列数
            self.columnCount = collView.collectionView(collView, numberOfColumnsInSection: indexPath.section)

            // 获取每个section 边距
            self.sectionInsets = collView.collectionView(collView, layout: self, insetForSectionAt: indexPath.section)
            
            // 生成header
            let itemCount = collView.numberOfItems(inSection: section)

            // Header是否吸顶
            if collView.sectionHeadersPinToVisibleBounds {
                let headerSize = collView.collectionView(collView, layout: self, referenceSizeForHeaderInSection: indexPath.section)
                if headerSize.width > 0 && headerSize.height > 0 {
                    self.cntHeight += headerSize.height
                    self.cntHeight += self.sectionInsets.top
                    self.columnHeights.removeAll()
                }
            }else {
                let headerAttri = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
                if let header = headerAttri {
                    self.attrsArray.append(header)
                    self.columnHeights.removeAll()
                }
            }
            
            // 记录上个section高度最高一列的高度，用于设置item的y值
            self.lastCntHeight = self.cntHeight
            
            // 按照列数初始化y值
            for _ in 0..<self.columnCount {
                self.columnHeights.append(self.cntHeight)
            }
            
            // 多少个item
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                let attri = self.layoutAttributesForItem(at: indexPath)
                if let attri = attri {
                    self.attrsArray.append(attri)
                }
            }
            
            // Footer是否吸顶
            if collView.sectionFootersPinToVisibleBounds {
                let footerSize = collView.collectionView(collView, layout: self, referenceSizeForFooterInSection: indexPath.section)
                if footerSize.width > 0 && footerSize.height > 0 {
                    self.cntHeight += self.sectionInsets.bottom
                    self.cntHeight += footerSize.height
                }
            }else {
                let footerAttri = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath)
                if let footer = footerAttri {
                    self.attrsArray.append(footer)
                }
            }
        }
    }
  
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attrsArray
    }
  
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collView = self.collectionView as? HCollView else { return nil }

        // 获取每个section 列数
        self.columnCount = collView.collectionView(collView, numberOfColumnsInSection: indexPath.section)

        // 获取每个section item上下间距
        self.lineSpacing = collView.collectionView(collView, layout: self, minimumLineSpacingForSectionAt: indexPath.section)

        // 获取每个section item左右间距
        self.interitemSpacing = collView.collectionView(collView, layout: self, minimumInteritemSpacingForSectionAt: indexPath.section)

        let attri = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        // collView的宽度
        let collWidth = collView.bounds.width
        // row的间隔
        let rowSpacing = CGFloat(self.columnCount - 1) * self.interitemSpacing
        // row的宽度
        let rowWidth = collWidth - self.sectionInsets.left - self.sectionInsets.right - rowSpacing
        // 单个item的宽度
        let itemWidth = rowWidth / CGFloat(self.columnCount)
        // 单个item的高度
        var itemHeight = 0.0
        
        // 获取每个section item高度
        itemHeight = collView.collectionView(collView, layout: self, sizeForItemAt: indexPath).height

        // 高度最小item的序号和高度
        var minItemIndex = 0
        var minItemHeight = 0.0
        
        // 取最小的item数据
        if let (tmpMinItemIndex, tmpMinItemHeight) = self.columnHeights.enumerated()
            .min(by: { $0.element < $1.element }) {
            minItemIndex = tmpMinItemIndex
            minItemHeight = tmpMinItemHeight
        }
        
        // 单个item的X坐标
        let itemX = self.sectionInsets.left + CGFloat(minItemIndex) * (itemWidth + self.interitemSpacing)
        // 单个item的Y坐标
        var itemY = minItemHeight
        // 非每个section的第一行
        if itemY != self.lastCntHeight {
            itemY += self.lineSpacing
        }

        // 重新修改每个item的数据
        attri.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
        // 修改列中y的值
        self.columnHeights[minItemIndex] = attri.frame.maxY
        
        // 取最大的item数据
        if let maxHeight = self.columnHeights.max() {
            self.cntHeight = maxHeight
        }

        return attri
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collView = self.collectionView as? HCollView else { return nil }
        if elementKind == UICollectionView.elementKindSectionHeader,
            !collView.sectionHeadersPinToVisibleBounds { //Header是否吸顶
            let headerSize = collView.collectionView(collView, layout: self, referenceSizeForHeaderInSection: indexPath.section)
            if headerSize.width > 0 && headerSize.height > 0 {
                let attri = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind,
                                                             with: indexPath)
                self.headerSize = headerSize
                attri.frame = CGRect(x: 0,
                                     y: self.cntHeight,
                                     width: self.headerSize.width,
                                     height: self.headerSize.height)
                self.cntHeight += self.headerSize.height
                self.cntHeight += self.sectionInsets.top
                return attri
            }
            return nil
        }else if elementKind == UICollectionView.elementKindSectionFooter,
                    !collView.sectionFootersPinToVisibleBounds { //Footer是否吸顶
            let footerSize = collView.collectionView(collView, layout: self, referenceSizeForFooterInSection: indexPath.section)
            if footerSize.width > 0 && footerSize.height > 0 {
                let attri = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind,
                                                             with: indexPath)
                self.footerSize = footerSize
                self.cntHeight += self.sectionInsets.bottom
                attri.frame = CGRect(x: 0,
                                     y: self.cntHeight,
                                     width: self.footerSize.width,
                                     height: self.footerSize.height)
                self.cntHeight += self.footerSize.height
                return attri
            }
            return nil
        }
        return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }
  
    override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else { return CGSize.zero }
        return CGSize(width: collectionView.bounds.width, height: self.cntHeight)
    }
    
}
