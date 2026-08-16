//
//  HCollView+DataSource.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  把 collItem / collHeader / collFooter 接到 UIKit DataSource。
//

import UIKit

// MARK: - UICollectionViewDataSource

extension HCollView: UICollectionViewDataSource {
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sections = collDelegate?.numberOfSectionsInCollView?() ?? 1
        return max(sections, 1)
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = collDelegate?.numberOfItemsInSection?(section) ?? 0
        allSectionInsets[section] = collDelegate?.insetForSection?(section) ?? .zero
        return max(items, 0)
    }

    /// 先调 `collItem`（内部 `reuseCell` 写入本次待返回实例），再把同一实例返回给 UIKit。
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        pendingReuseCell = nil
        collDelegate?.collItem?(self, atIndexPath: indexPath)

        if let cell = pendingReuseCell {
            pendingReuseCell = nil
            return cell
        }

        let cellIdentifier = NSStringFromClass(HCollBaseCell.self)
        registerIfNeeded(cellIdentifier, forCell: true)

        guard let cell = dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? HCollBaseCell else {
            #if DEBUG
            assertionFailure("[HCollView] Failed to dequeue HCollBaseCell at \(indexPath)")
            #endif
            return HCollBaseCell(frame: .zero)
        }

        cell.indexPath = indexPath
        cell.coll = self
        return cell
    }

    internal func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let isHeader = kind == UICollectionView.elementKindSectionHeader
        if isHeader {
            pendingReuseHeader = nil
            collDelegate?.collHeader?(self, atIndexPath: indexPath)
            if let header = pendingReuseHeader {
                pendingReuseHeader = nil
                return header
            }
        } else {
            pendingReuseFooter = nil
            collDelegate?.collFooter?(self, atIndexPath: indexPath)
            if let footer = pendingReuseFooter {
                pendingReuseFooter = nil
                return footer
            }
        }

        let apexIdentifier = NSStringFromClass(HCollBaseApex.self)
        registerIfNeeded(apexIdentifier, forCell: false, forKind: kind)
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: apexIdentifier, for: indexPath)
    }

    private func registerIfNeeded(_ identifier: String, forCell: Bool, forKind: String? = nil) {
        if forCell {
            if !allCellIdentifiers.contains(identifier) {
                allCellIdentifiers.insert(identifier)
                register(HCollBaseCell.self, forCellWithReuseIdentifier: identifier)
            }
        } else if let kind = forKind {
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
}
