//
//  HCollView+Performance.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 的性能优化扩展
///
/// 提供预计算布局、批量更新等性能优化功能
extension HCollView {
    
    /// 增量更新
    /// - Parameters:
    ///   - indexPathsToInsert: 需要插入的 indexPath
    ///   - indexPathsToDelete: 需要删除的 indexPath
    ///   - indexPathsToReload: 需要重新加载的 indexPath
    ///   - completion: 完成回调
    func incrementalUpdate(
        inserting indexPathsToInsert: [IndexPath] = [],
        deleting indexPathsToDelete: [IndexPath] = [],
        reloading indexPathsToReload: [IndexPath] = [],
        completion: ((Bool) -> Void)? = nil
    ) {
        guard !indexPathsToInsert.isEmpty || !indexPathsToDelete.isEmpty || !indexPathsToReload.isEmpty else {
            completion?(true)
            return
        }
        
        performBatchUpdates { [self] in
            if !indexPathsToInsert.isEmpty {
                (self as UICollectionView).insertItems(at: indexPathsToInsert)
            }
            
            if !indexPathsToDelete.isEmpty {
                (self as UICollectionView).deleteItems(at: indexPathsToDelete)
            }
            
            if !indexPathsToReload.isEmpty {
                (self as UICollectionView).reloadItems(at: indexPathsToReload)
            }
        } completion: {
            completion?($0)
        }
    }
    
}
