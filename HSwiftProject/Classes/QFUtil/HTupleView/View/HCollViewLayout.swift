//
//  HCollViewLayout.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var HCollViewSectionColor = "com.dqf.HCollElementKindSectionColor"

private class HCollViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var backgroundColor: UIColor?
}

private class HCollReusableView: UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attr = layoutAttributes as? HCollViewLayoutAttributes,
              let backgroundColor = attr.backgroundColor,
              self.backgroundColor != backgroundColor else { return }
        self.backgroundColor = backgroundColor
    }
}

/// Extend the background color of the section
@objc protocol HCollViewLayoutDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, colorForSectionAt section: NSInteger) -> UIColor
}

class HCollViewLayout: UICollectionViewFlowLayout {
    
    private var decorationViewAttrs: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    convenience init(_ direction: HCollDirection = .vertical, _ itemLayout: HCollItemLayout = .manual) {
        self.init()
        if direction == .horizontal {
            self.scrollDirection = .horizontal
        }else {
            self.scrollDirection = .vertical
        }
        if itemLayout == .manual {
            self.estimatedItemSize = CGSize.zero
        }else {
            self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = self.collectionView else { return }
        let sections = collectionView.numberOfSections
        guard let delegate = collectionView.delegate as? HCollViewLayoutDelegate else { return }

        // 1. Initialization
        self.register(HCollReusableView.self, forDecorationViewOfKind: HCollViewSectionColor)
        self.decorationViewAttrs.removeAll()

        for section in 0..<sections {
            let numberOfItems: Int = collectionView.numberOfItems(inSection: section)
            guard numberOfItems > 0 else { continue }
            guard let firstAttr = self.layoutAttributesForItem(at: IndexPath(row: 0, section: section)),
                  let lastAttr = self.layoutAttributesForItem(at: IndexPath(row: numberOfItems - 1, section: section)) else { continue }

            var sectionInset = self.sectionInset
            let inset = delegate.collectionView!(collectionView, layout: self, insetForSectionAt: section)
            if inset != sectionInset { sectionInset = inset }

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

            // 2. Definition
            let attr: HCollViewLayoutAttributes = HCollViewLayoutAttributes(forDecorationViewOfKind: HCollViewSectionColor, with: IndexPath(row: 0, section: section))
            attr.frame = sectionFrame
            attr.zIndex = -1
            attr.backgroundColor = delegate.collectionView(collectionView, layout: self, colorForSectionAt: section)
            self.decorationViewAttrs.append(attr)
        }
    }

    // The original method with the addition of removing the spacing line between cells
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attrs = super.layoutAttributesForElements(in: rect) else { return nil }
        let decorationViewAttrsInRect = decorationViewAttrs.filter { $0.frame == rect }
        return attrs + decorationViewAttrsInRect
    }
    
}
