//
//  HCollView+Memory.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  监听内存警告，清理 identifier 登记、防抖任务和图片内存缓存。
//

import UIKit
import Kingfisher

extension HCollView {

    /// Core `setup` 钩子，选择器名勿改。
    @objc func hcoll_memory_setup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }

    /// Observer / 手动释放钩子，选择器名勿改。
    @objc func hcoll_memory_release() {
        releaseCollBlock()
    }

    /// 内存警告：清 identifier 登记和图片内存缓存。identifier 清掉后下次会重新 register。
    @objc func handleMemoryWarning() {
        invokeFeature(HCollFeatureSelector.imageSizeClearCache)
        KingfisherManager.shared.cache.clearMemoryCache()
        clearCollState()
    }

    @objc
    func releaseCollBlock() {
        clearCollState()
        collDelegate = nil
        invokeFeature(HCollFeatureSelector.refreshClearBlocks)
    }

    private func clearCollState() {
        pendingReuseCell = nil
        pendingReuseHeader = nil
        pendingReuseFooter = nil
        allHeaderIdentifiers.removeAll()
        allFooterIdentifiers.removeAll()
        allCellIdentifiers.removeAll()
        allSectionInsets.removeAll()

        reloadWorkItem?.cancel()
        itemReloadWorkItem?.cancel()
        reloadWorkItem = nil
        itemReloadWorkItem = nil
        pendingItemReloads.removeAll()
    }
}
