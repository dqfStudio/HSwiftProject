//
//  HCollectionViewFlowLayout.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/22.
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
        let attr = layoutAttributes as! HCollectionViewLayoutAttributes
        self.backgroundColor = attr.backgroundColor
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

        let sections: Int = self.collectionView!.numberOfSections
        let delegate = self.collectionView!.delegate as! HCollectionViewDelegateFlowLayout
        let selector = #selector(delegate.collectionView(_:layout:colorForSectionAt:))
        if delegate.responds(to: selector) == false {
            return
        }

        //1.初始化
        self.register(HCollectionReusableView.self, forDecorationViewOfKind: HCollectionViewSectionColor)
        self.decorationViewAttrs.removeAllObjects()

        for section in 0..<sections {
            let numberOfItems: Int = (self.collectionView?.numberOfItems(inSection: section))!
            if numberOfItems > 0 {
                let firstAttr: UICollectionViewLayoutAttributes = self.layoutAttributesForItem(at: IndexPath(row: 0, section: section))!
                let lastAttr: UICollectionViewLayoutAttributes = self.layoutAttributesForItem(at: IndexPath(row: numberOfItems - 1, section: section))!

                var sectionInset = self.sectionInset
                if delegate.responds(to: selector) {
                    let inset: UIEdgeInsets = delegate.collectionView!(self.collectionView!, layout: self, insetForSectionAt: section)
                    if inset != sectionInset {
                        sectionInset = inset
                    }
                }

                var sectionFrame: CGRect = firstAttr.frame.union(lastAttr.frame)
                sectionFrame.origin.x -= sectionInset.left
                sectionFrame.origin.y -= sectionInset.top

                if (self.scrollDirection == .horizontal) {
                    sectionFrame.size.width += sectionInset.left + sectionInset.right
                    sectionFrame.size.height = (self.collectionView?.frame.size.height)!
                }else {
                    sectionFrame.size.width = (self.collectionView?.frame.size.width)!
                    sectionFrame.size.height += sectionInset.top + sectionInset.bottom
                }

                //2. 定义
                let attr: HCollectionViewLayoutAttributes = HCollectionViewLayoutAttributes(forDecorationViewOfKind: HCollectionViewSectionColor, with: IndexPath(row: 0, section: section))
                attr.frame = sectionFrame
                attr.zIndex = -1
                attr.backgroundColor = delegate.collectionView(self.collectionView!, layout: self, colorForSectionAt: section)
                self.decorationViewAttrs.add(attr)
            }else {
                continue
            }
        }

    }

    //此类原有方法 并加上 去掉Cell之间的间隔线
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let tmpAAttrs: NSArray? = super.layoutAttributesForElements(in: rect) as NSArray?
        if tmpAAttrs != nil {
            let attrs: NSMutableArray = NSMutableArray(array: tmpAAttrs!)
            for item in self.decorationViewAttrs {
                let attr = item as! UICollectionViewLayoutAttributes
                if rect == attr.frame {
                    attrs.add(attr)
                }
            }
            return attrs as? [UICollectionViewLayoutAttributes]
        }
        return nil
    }
    
}
