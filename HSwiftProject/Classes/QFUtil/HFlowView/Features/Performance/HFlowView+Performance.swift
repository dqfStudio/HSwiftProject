//
//  HFlowView+Performance.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//
//  用 performBatchUpdates 做增量增删改，避免整表 reloadData。
//

import UIKit

extension HFlowView {

    /// 用 `performBatchUpdates` 做增量增删改，避免整表 `reloadData`。
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

        performBatchUpdates {
            if !indexPathsToInsert.isEmpty {
                insertRows(at: indexPathsToInsert, with: .none)
            }
            if !indexPathsToDelete.isEmpty {
                deleteRows(at: indexPathsToDelete, with: .none)
            }
            if !indexPathsToReload.isEmpty {
                reloadRows(at: indexPathsToReload, with: .none)
            }
        } completion: {
            completion?($0)
        }
    }
}
