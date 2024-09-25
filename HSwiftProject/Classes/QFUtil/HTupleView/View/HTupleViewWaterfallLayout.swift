//
//  HTupleViewWaterfallLayout.swift
//  HSwiftProject
//
//  Created by owner on 2023/10/20.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

@objc protocol HTupleViewWaterfallLayoutDelegate: NSObjectProtocol {
    /// item高度
    @objc
    optional func waterHeightForItemAtIndexPath(_ indexPath: IndexPath, itemWidth: Any) -> Any
  
    /// 每个section 列数（默认2列）
    @objc
    optional func waterNumberOfColumnsInSection( _ section: Any) -> Any

    /// header高度（默认为0）
    @objc
    optional func waterSizeForHeaderInSection(_ section: Any) -> Any

    /// footer高度（默认为0）
    @objc
    optional func waterSizeForFooterInSection(_ section: Any) -> Any

    /// 每个section 边距（默认为0）
    @objc
    optional func waterInsetForSection( _ section: Any) -> Any

    /// 每个section item上下间距（默认为0）
    @objc
    optional func waterLineSpacingForSection( _ section: Any) -> Any

    /// 每个section item左右间距（默认为0）
    @objc
    optional func waterInteritemSpacingForSection( _ section: Any) -> Any

    /// section头部header与上个section尾部footer间距（默认为0）
    @objc
    optional func waterSpacingForLastSection( _ section: Any) -> Any
}

class HTupleViewWaterfallLayout: UICollectionViewFlowLayout {
    
    private weak var delegate: HTupleViewWaterfallLayoutDelegate?
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
    //每个section的header与上个section的footer距离
    private var spacingForLastSection: CGFloat = 0.0
    
    convenience init(delegate: HTupleViewWaterfallLayoutDelegate) {
        self.init()
        self.delegate = delegate
    }
  
    override func prepare() {
        super.prepare()
        self.cntHeight = 0.0
        self.lastCntHeight = 0.0
        self.spacingForLastSection = 0.0
        self.lineSpacing = 0.0
        self.sectionInsets = .zero
        self.headerSize = .zero
        self.footerSize = .zero
        self.columnHeights.removeAll()
        self.attrsArray.removeAll()

        guard let delegate = self.delegate, let tuple = self.collectionView as? HTupleView else { return }
        let sectionCount = tuple.numberOfSections
        // 遍历section
        for section in 0..<sectionCount {
            let prefix = tuple.tupleLayoutItemPrefix(section)
            let indexPath = IndexPath(item: 0, section: section)

            // 获取每个section 列数
            let columnSelector = #selector(delegate.waterNumberOfColumnsInSection(_:))
            if delegate.responds(to: columnSelector, withPre: prefix) {
                self.columnCount = delegate.performWithUnretainedValue(columnSelector, with: section, withPre: prefix) as! Int
            }

            // 获取每个section 边距
            let insetSelector = #selector(delegate.waterInsetForSection(_:))
            if delegate.responds(to: insetSelector, withPre: prefix) {
                self.sectionInsets = delegate.performWithUnretainedValue(insetSelector, with: section, withPre: prefix) as! UIEdgeInsets
            }

            // 获取section头部header与上个section尾部footer间距
            let slsSelector = #selector(delegate.waterSpacingForLastSection(_:))
            if delegate.responds(to: slsSelector, withPre: prefix) {
                self.spacingForLastSection = delegate.performWithUnretainedValue(slsSelector, with: section, withPre: prefix) as! CGFloat
            }
            
            // 生成header
            let itemCount = tuple.numberOfItems(inSection: section)
//            let headerAttri = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
//            if let header = headerAttri {
//                self.attrsArray.append(header)
//                self.columnHeights.removeAll()
//            }
            
            // Header高度
            let headerSizeSelector = #selector(delegate.waterSizeForHeaderInSection(_:))
            if delegate.responds(to: headerSizeSelector, withPre: prefix) {
                let headerSize = delegate.performWithUnretainedValue(headerSizeSelector,
                                                                     with: indexPath.section,
                                                                     withPre: prefix) as! CGSize
                if headerSize.width > 0 && headerSize.height > 0 {
                    self.cntHeight += headerSize.height
                    self.cntHeight += self.sectionInsets.top
                    self.cntHeight += self.spacingForLastSection
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
            
            // 初始化footer
//            let footerAttri = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath)
//            if let footer = footerAttri {
//                self.attrsArray.append(footer)
//            }
            
            // Footer高度
            let footerSizeSelector = #selector(delegate.waterSizeForFooterInSection(_:))
            if delegate.responds(to: footerSizeSelector, withPre: prefix) {
                let footerSize = delegate.performWithUnretainedValue(footerSizeSelector,
                                                                     with: indexPath.section,
                                                                     withPre: prefix) as! CGSize
                if footerSize.width > 0 && footerSize.height > 0 {
                    self.cntHeight += self.sectionInsets.bottom
                    self.cntHeight += self.footerSize.height
                }
            }
        }
    }
  
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attrsArray
    }
  
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let delegate = self.delegate, let tuple = self.collectionView as? HTupleView else { return nil }
        let prefix = tuple.tupleSplitPrefix(indexPath.section)

        // 获取每个section 列数
        let columnSelector = #selector(delegate.waterNumberOfColumnsInSection(_:))
        if delegate.responds(to: columnSelector, withPre: prefix) {
            self.columnCount = delegate.performWithUnretainedValue(columnSelector,
                                                                   with: indexPath.section,
                                                                   withPre: prefix) as! Int
        }

        // 获取每个section item上下间距
        let lineSelector = #selector(delegate.waterLineSpacingForSection(_:))
        if delegate.responds(to: lineSelector, withPre: prefix) {
            self.lineSpacing = delegate.performWithUnretainedValue(lineSelector,
                                                                   with: indexPath.section,
                                                                   withPre: prefix) as! CGFloat
        }

        // 获取每个section item左右间距
        let interitemSelector = #selector(delegate.waterInteritemSpacingForSection(_:))
        if delegate.responds(to: interitemSelector, withPre: prefix) {
            self.interitemSpacing = delegate.performWithUnretainedValue(interitemSelector, 
                                                                        with: indexPath.section,
                                                                        withPre: prefix) as! CGFloat
        }

        let attri = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        // tupleView的宽度
        let tupleWidth = tuple.bounds.width
        // row的间隔
        let rowSpacing = CGFloat(self.columnCount - 1) * self.interitemSpacing
        // row的宽度
        let rowWidth = tupleWidth - self.sectionInsets.left - self.sectionInsets.right - rowSpacing
        // 单个item的宽度
        let itemWidth = rowWidth / CGFloat(self.columnCount)
        // 单个item的高度
        var itemHeight = 0.0
        
        // 获取每个section item高度
        let cellHeightSelector = #selector(delegate.waterHeightForItemAtIndexPath(_:itemWidth:))
        if delegate.responds(to: cellHeightSelector, withPre: prefix) {
            itemHeight = delegate.performWithUnretainedValue(cellHeightSelector, 
                                                             with: indexPath,
                                                             with: itemWidth,
                                                             withPre: prefix) as! CGFloat
        }

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
//        guard let delegate = self.delegate, let tuple = self.collectionView as? HTupleView else { return nil }
//        let prefix = tuple.tupleLayoutViewPrefix(indexPath.section)
//        let attri = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
//        if elementKind == UICollectionView.elementKindSectionHeader {
//            var headerSize = CGSize.zero
//            let headerSizeSelector = #selector(delegate.waterSizeForHeaderInSection(_:))
//            if delegate.responds(to: headerSizeSelector, withPre: prefix) {
//                headerSize = delegate.performWithUnretainedValue(headerSizeSelector, 
//                                                                 with: indexPath.section,
//                                                                 withPre: prefix) as! CGSize
//            }
//            guard headerSize != .zero else { return nil }
//            self.headerSize = headerSize
//            self.cntHeight += self.spacingForLastSection
//            attri.frame = CGRect(x: 0, 
//                                 y: self.cntHeight,
//                                 width: self.headerSize.width,
//                                 height: self.headerSize.height)
//            self.cntHeight += self.headerSize.height
//            self.cntHeight += self.sectionInsets.top
//        }else if elementKind == UICollectionView.elementKindSectionFooter {
//            var footerSize = CGSize.zero
//            let footerSizeSelector = #selector(delegate.waterSizeForFooterInSection(_:))
//            if delegate.responds(to: footerSizeSelector, withPre: prefix) {
//                footerSize = delegate.performWithUnretainedValue(footerSizeSelector,
//                                                                 with: indexPath.section,
//                                                                 withPre: prefix) as! CGSize
//            }
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
