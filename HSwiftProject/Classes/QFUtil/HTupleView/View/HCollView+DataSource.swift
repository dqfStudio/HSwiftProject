//
//  HCollView+DataSource.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

// MARK: - DataSource
extension HCollView: UICollectionViewDataSource {
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sections = collDelegate?.numberOfSectionsInCollView?() ?? 1
        return max(sections, 1)
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = collDelegate?.numberOfItemsInSection?(section) ?? 0
        
        // 缓存 section insets 以供后续使用
        if let edgeInsets = collDelegate?.insetForSection?(section) {
            allSectionInsets["\(section)"] = NSCoder.string(for: edgeInsets)
        }
        
        return max(items, 0)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collDelegate?.collItem?(self, atIndexPath: indexPath)

        let cellIdentifier = HCollBaseCell.className
        registerIfNeeded(cellIdentifier, forCell: true)

        guard let cell = dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? HCollBaseCell else {
            #if DEBUG
            assertionFailure("[HCollView] Failed to dequeue HCollBaseCell at \(indexPath)")
            #else
            print("⚠️ [HCollView] Failed to dequeue HCollBaseCell at \(indexPath)")
            #endif
            return HCollBaseCell(frame: .zero)
        }

        cell.indexPath = indexPath
        cell.coll = self

        trackCellVisit(at: indexPath)

        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let isHeader = kind == UICollectionView.elementKindSectionHeader
        
        // 检查代理是否提供自定义间距
        let spacing = isHeader ?
            collDelegate?.minimumHeaderSpacingForSectionAt?(indexPath.section) :
            collDelegate?.minimumFooterSpacingForSectionAt?(indexPath.section)
        
        if let spacing = spacing {
            // 使用基于间距的标识符
            let identifier = "\(indexPath.section)-\(indexPath.row)"
            
            // 使用统一的注册方法
            registerIfNeeded(identifier, forCell: false, forKind: kind)
            
            return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
        } else {
            // 通知代理自定义 header/footer
            if isHeader {
                collDelegate?.collHeader?(self, atIndexPath: indexPath)
            } else {
                collDelegate?.collFooter?(self, atIndexPath: indexPath)
            }
        }
        
        // 回退到默认 supplementary view
        let apexIdentifier = HCollBaseApex.className
        registerIfNeeded(apexIdentifier, forCell: false, forKind: kind)
        
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: apexIdentifier, for: indexPath)
    }
    
    /// Register cell or supplementary view if not already registered
    private func registerIfNeeded(_ identifier: String, forCell: Bool, forKind: String? = nil) {
        if forCell {
            if !allCellIdentifiers.contains(identifier) {
                allCellIdentifiers.insert(identifier)
                register(HCollBaseCell.self, forCellWithReuseIdentifier: identifier)
            }
        } else if let kind = forKind {
            // 处理 supplementary view 注册
            if kind == UICollectionView.elementKindSectionHeader {
                if !allHeaderIdentifiers.contains(identifier) {
                    allHeaderIdentifiers.insert(identifier)
                    register(HCollBaseApex.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
                }
            } else if kind == UICollectionView.elementKindSectionFooter {
                if !allFooterIdentifiers.contains(identifier) {
                    allFooterIdentifiers.insert(identifier)
                    register(HCollBaseApex.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
                }
            }
        }
    }
    
    /// Track cell visit and periodically clean up stale weak references.
    /// Does NOT clear image caches — Kingfisher manages its own memory.
    private func trackCellVisit(at indexPath: IndexPath) {
        allPassedCells.insert("\(indexPath.section)-\(indexPath.row)")
        if allPassedCells.count > Constants.maxTrackedCells {
            allPassedCells.removeAll()
        }
    }
}
