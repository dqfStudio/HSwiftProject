//
//  HCollView+Delegate.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

// MARK: - Delegate
extension HCollView: UICollectionViewDelegate, HCollViewLayoutDelegate {
    // MARK: - UICollectionViewDelegate
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HCollBaseCell {
            collDelegate?.willDisplayCell?(cell, atIndexPath: indexPath)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = cellForItem(at: indexPath) as? HCollBaseCell {
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
        
        // 检查是否需要预加载
        if preloadEnabled {
            checkPreload()
        }
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
    
    /// layout == HCollViewLayout
    internal func collectionView(_ collectionView: UICollectionView, numberOfColumnsInSection section: Int) -> Int {
        let columns = self.collDelegate?.numberOfColumnsInSection?(section) ?? 2
        return max(columns, 2)
    }

    /// layout == HCollViewLayout
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

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let insetsString = self.allSectionInsets["\(section)"],
              !insetsString.isEmpty else {
            return .zero
        }
        return UIEdgeInsetsFromString(insetsString)
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
        // 默认最小尺寸以防止崩溃
        var size = self.collDelegate?.sizeForItemAtIndexPath?(indexPath) ?? CGSize(width: HCollView.Constants.minCellDimension, height: HCollView.Constants.minCellDimension)
        
        // 确保尺寸为正值
        size.width = max(size.width, HCollView.Constants.minCellDimension)
        size.height = max(size.height, HCollView.Constants.minCellDimension)
        
        return UISizeIntegral(size)
    }
    
    /// 计算 header 或 footer 的尺寸
    /// - Parameters:
    ///   - spacing: 间距值，如果提供则使用基于间距的尺寸
    ///   - customSize: 自定义尺寸，如果没有提供 spacing 则使用此值
    /// - Returns: 计算后的 header 或 footer 尺寸
    private func calculateSupplementaryViewSize(spacing: CGFloat?, customSize: CGSize?) -> CGSize {
        var size: CGSize
        
        if let spacing = spacing {
            // 使用基于间距的尺寸
            let isVertical = self.flowLayout?.scrollDirection == .vertical
            size = isVertical ?
                CGSize(width: self.width, height: spacing) :
                CGSize(width: spacing, height: self.height)
        } else {
            // 使用自定义尺寸或零尺寸
            size = customSize ?? .zero
        }
        
        // 确保尺寸为非负值
        size.width = max(size.width, 0.0)
        size.height = max(size.height, 0.0)
        
        return UISizeIntegral(size)
    }
}
