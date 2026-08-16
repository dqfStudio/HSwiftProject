//
//  HCollView+Delegate.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  把点击、滚动、尺寸回调转给 collDelegate。
//

import UIKit

// MARK: - UICollectionViewDelegate

extension HCollView: UICollectionViewDelegate, HCollViewLayoutDelegate {

    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HCollBaseCell {
            cell.willDisplayBlock?()
            collDelegate?.willDisplayCell?(cell, atIndexPath: indexPath)
        }
        invokeFeature(HCollFeatureSelector.imageSizeWillDisplay, with: indexPath)
    }

    internal func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if let apex = view as? HCollBaseApex {
            apex.willDisplayBlock?()
            if elementKind == UICollectionView.elementKindSectionHeader {
                collDelegate?.willDisplayHeader?(apex, atIndexPath: indexPath)
            } else if elementKind == UICollectionView.elementKindSectionFooter {
                collDelegate?.willDisplayFooter?(apex, atIndexPath: indexPath)
            }
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = cellForItem(at: indexPath) as? HCollBaseCell {
            cell.selectBlock?()
            collDelegate?.didSelectCell?(cell, atIndexPath: indexPath)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return collDelegate?.shouldSelectItemAtIndexPath?(indexPath) ?? true
    }

    internal func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return collDelegate?.shouldDeselectItemAtIndexPath?(indexPath) ?? true
    }

    internal func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collDelegate?.didDeselectItemAtIndexPath?(indexPath)
    }

    // MARK: - UIScrollViewDelegate

    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collDelegate?.collViewDidScroll?(scrollView)
        invokeFeature(HCollFeatureSelector.refreshDidScroll)
    }

    internal func scrollViewDidZoom(_ scrollView: UIScrollView) {
        collDelegate?.collViewDidZoom?(scrollView)
    }

    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        collDelegate?.collViewWillBeginDragging?(scrollView)
    }

    internal func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        collDelegate?.collViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        collDelegate?.collViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    internal func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        collDelegate?.collViewWillBeginDecelerating?(scrollView)
    }

    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collDelegate?.collViewDidEndDecelerating?(scrollView)
    }

    // MARK: - HCollViewLayoutDelegate

    internal func collectionView(_ collectionView: UICollectionView, numberOfColumnsInSection section: Int) -> Int {
        let columns = self.collDelegate?.numberOfColumnsInSection?(section) ?? 2
        return max(columns, 1)
    }

    internal func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, colorForSectionAt section: NSInteger) -> UIColor {
        return self.collDelegate?.colorForSection?(section) ?? .clear
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.collDelegate?.minimumLineSpacingForSectionAt?(section) ?? 0.0
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.collDelegate?.minimumInteritemSpacingForSectionAt?(section) ?? 0.0
    }

    /// 每次向代理要 insets，并写入缓存供 `width(for:)` / `height(for:)` 使用。
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let insets = collDelegate?.insetForSection?(section) {
            allSectionInsets[section] = insets
            return insets
        }
        allSectionInsets[section] = .zero
        return .zero
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        calculateSupplementaryViewSize(
            spacing: self.collDelegate?.minimumHeaderSpacingForSectionAt?(section),
            customSize: self.collDelegate?.sizeForHeaderInSection?(section)
        )
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        calculateSupplementaryViewSize(
            spacing: self.collDelegate?.minimumFooterSpacingForSectionAt?(section),
            customSize: self.collDelegate?.sizeForFooterInSection?(section)
        )
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = self.collDelegate?.sizeForItemAtIndexPath?(indexPath) ?? CGSize(width: HCollView.Constants.minCellDimension, height: HCollView.Constants.minCellDimension)

        size.width = max(size.width, HCollView.Constants.minCellDimension)
        size.height = max(size.height, HCollView.Constants.minCellDimension)

        return HCollSizeIntegral(size)
    }

    /// `spacing` 一旦有值就优先：竖滑用全宽 × spacing，横滑用 spacing × 全高。
    private func calculateSupplementaryViewSize(spacing: CGFloat?, customSize: CGSize?) -> CGSize {
        var size: CGSize

        if let spacing = spacing {
            let isVertical = self.flowLayout?.scrollDirection == .vertical
            size = isVertical ?
                CGSize(width: bounds.width, height: spacing) :
                CGSize(width: spacing, height: bounds.height)
        } else {
            size = customSize ?? .zero
        }

        size.width = max(size.width, 0.0)
        size.height = max(size.height, 0.0)

        return HCollSizeIntegral(size)
    }
}
