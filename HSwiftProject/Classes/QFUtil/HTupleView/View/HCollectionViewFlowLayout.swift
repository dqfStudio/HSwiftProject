//
//  HCollectionViewFlowLayout.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var HCollectionViewSectionColor = "com.dqf.HCollectionElementKindSectionColor"

private class HCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes {
    var backgroundColor: UIColor? //背景色
}

private class HCollectionReusableView : UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attr = layoutAttributes as? HCollectionViewLayoutAttributes,
              let backgroundColor = attr.backgroundColor,
              self.backgroundColor != backgroundColor else { return }
        self.backgroundColor = backgroundColor
    }
}

/// 扩展section的背景色
@objc protocol HCollectionViewDelegateFlowLayout : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, colorForSectionAt section: NSInteger) -> UIColor
}

class HCollectionViewFlowLayout : UICollectionViewFlowLayout {
    
    private var decorationViewAttrs: NSMutableArray = NSMutableArray()

    override func prepare() {
        super.prepare()

        guard let collectionView = self.collectionView else { return }
        let sections: Int = collectionView.numberOfSections
        guard let delegate = collectionView.delegate as? HCollectionViewDelegateFlowLayout else { return }
        let selector = #selector(delegate.collectionView(_:layout:colorForSectionAt:))
        guard delegate.responds(to: selector) else { return }

        //1.初始化
        self.register(HCollectionReusableView.self, forDecorationViewOfKind: HCollectionViewSectionColor)
        self.decorationViewAttrs.removeAllObjects()

        for section in 0..<sections {
            let numberOfItems: Int = collectionView.numberOfItems(inSection: section)
            guard numberOfItems > 0 else { continue }
            guard let firstAttr = self.layoutAttributesForItem(at: IndexPath(row: 0, section: section)),
                  let lastAttr = self.layoutAttributesForItem(at: IndexPath(row: numberOfItems - 1, section: section)) else { continue }

            var sectionInset = self.sectionInset
            if delegate.responds(to: selector) {
                let inset: UIEdgeInsets = delegate.collectionView!(collectionView, layout: self, insetForSectionAt: section)
                if inset != sectionInset {
                    sectionInset = inset
                }
            }

            var sectionFrame: CGRect = firstAttr.frame.union(lastAttr.frame)
            sectionFrame.origin.x -= sectionInset.left
            sectionFrame.origin.y -= sectionInset.top

            if (self.scrollDirection == .horizontal) {
                sectionFrame.size.width += sectionInset.left + sectionInset.right
                sectionFrame.size.height = collectionView.frame.size.height
            }else {
                sectionFrame.size.width = collectionView.frame.size.width
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom
            }

            //2. 定义
            let attr: HCollectionViewLayoutAttributes = HCollectionViewLayoutAttributes(forDecorationViewOfKind: HCollectionViewSectionColor, with: IndexPath(row: 0, section: section))
            attr.frame = sectionFrame
            attr.zIndex = -1
            attr.backgroundColor = delegate.collectionView(collectionView, layout: self, colorForSectionAt: section)
            self.decorationViewAttrs.add(attr)
        }
    }

    //此类原有方法 并加上 去掉Cell之间的间隔线
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let tmpAttrs = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        let attrs = NSMutableArray(array: tmpAttrs)
        self.decorationViewAttrs.forEach { item in
            if let attr = item as? UICollectionViewLayoutAttributes, rect == attr.frame {
                attrs.add(attr)
            }
        }
        return attrs as? [UICollectionViewLayoutAttributes]
    }
    
}
