//
//  HTupleViewWaterfallLayout.swift
//  HSwiftProject
//
//  Created by owner on 2023/10/20.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HTupleViewWaterfallLayout: UICollectionViewFlowLayout {
    
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

        guard let tupleView = self.collectionView as? HTupleView else { return }
        let sectionCount = tupleView.numberOfSections
        // 遍历section
        for section in 0..<sectionCount {
            let indexPath = IndexPath(item: 0, section: section)

            // 获取每个section 列数
            self.columnCount = tupleView.collectionView(tupleView, numberOfColumnsInSection: indexPath.section)

            // 获取每个section 边距
            self.sectionInsets = tupleView.collectionView(tupleView, layout: self, insetForSectionAt: indexPath.section)
            
            // 生成header
            let itemCount = tupleView.numberOfItems(inSection: section)
//            let headerAttri = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
//            if let header = headerAttri {
//                self.attrsArray.append(header)
//                self.columnHeights.removeAll()
//            }
            
            // Header高度
            let headerSize = tupleView.collectionView(tupleView, layout: self, referenceSizeForHeaderInSection: indexPath.section)
            if headerSize.width > 0 && headerSize.height > 0 {
                self.cntHeight += headerSize.height
                self.cntHeight += self.sectionInsets.top
                self.columnHeights.removeAll()
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
            
            // 初始化footer
//            let footerAttri = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath)
//            if let footer = footerAttri {
//                self.attrsArray.append(footer)
//            }
            
            // Footer高度
            let footerSize = tupleView.collectionView(tupleView, layout: self, referenceSizeForFooterInSection: indexPath.section)
            if footerSize.width > 0 && footerSize.height > 0 {
                self.cntHeight += self.sectionInsets.bottom
                self.cntHeight += self.footerSize.height
            }
        }
    }
  
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attrsArray
    }
  
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let tupleView = self.collectionView as? HTupleView else { return nil }

        // 获取每个section 列数
        self.columnCount = tupleView.collectionView(tupleView, numberOfColumnsInSection: indexPath.section)

        // 获取每个section item上下间距
        self.lineSpacing = tupleView.collectionView(tupleView, layout: self, minimumLineSpacingForSectionAt: indexPath.section)

        // 获取每个section item左右间距
        self.interitemSpacing = tupleView.collectionView(tupleView, layout: self, minimumInteritemSpacingForSectionAt: indexPath.section)

        let attri = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        // tupleView的宽度
        let tupleWidth = tupleView.bounds.width
        // row的间隔
        let rowSpacing = CGFloat(self.columnCount - 1) * self.interitemSpacing
        // row的宽度
        let rowWidth = tupleWidth - self.sectionInsets.left - self.sectionInsets.right - rowSpacing
        // 单个item的宽度
        let itemWidth = rowWidth / CGFloat(self.columnCount)
        // 单个item的高度
        var itemHeight = 0.0
        
        // 获取每个section item高度
        itemHeight = tupleView.collectionView(tupleView, layout: self, sizeForItemAt: indexPath).height

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
    
//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let tupleView = self.collectionView as? HTupleView else { return nil }
//        let attri = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
//        if elementKind == UICollectionView.elementKindSectionHeader {
//            let headerSize = tupleView.collectionView(tupleView, layout: self, referenceSizeForHeaderInSection: indexPath.section)
//            guard headerSize != .zero else { return nil }
//            self.headerSize = headerSize
//            attri.frame = CGRect(x: 0, 
//                                 y: self.cntHeight,
//                                 width: self.headerSize.width,
//                                 height: self.headerSize.height)
//            self.cntHeight += self.headerSize.height
//            self.cntHeight += self.sectionInsets.top
//        }else if elementKind == UICollectionView.elementKindSectionFooter {
//            let footerSize = tupleView.collectionView(tupleView, layout: self, referenceSizeForFooterInSection: indexPath.section)
//            guard footerSize != .zero else { return nil }
//            self.footerSize = footerSize
//            self.cntHeight += self.sectionInsets.bottom
//            attri.frame = CGRect(x: 0,
//                                 y: self.cntHeight,
//                                 width: self.footerSize.width,
//                                 height: self.footerSize.height)
//            self.cntHeight += self.footerSize.height
//        }
//        return attri
//    }
  
    override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else { return CGSize.zero }
        return CGSize(width: collectionView.bounds.width, height: self.cntHeight)
    }
    
}
