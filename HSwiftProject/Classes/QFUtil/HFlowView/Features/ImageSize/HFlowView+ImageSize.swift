//
//  HFlowView+ImageSize.swift
//  HSwiftProject
//
//  Created by owner on 2025/5/17.
//  Copyright © 2025 wind. All rights reserved.
//
//  用 Kingfisher 预取图片尺寸，避免 cell 先按占位高度再闪缩。尺寸缓存在 LRU 里。
//

import UIKit
import Kingfisher

/// 用 Kingfisher 下载完整图片后记下尺寸。图片本身进 Kingfisher 缓存，cell 显示时直接命中。
class HFlowImageSizeCache {

    static let shared = HFlowImageSizeCache()

    private var cache = HFlowLRUCache<String, CGSize>(capacity: 256)
    private var pendingCompletions: [String: [(CGSize?) -> Void]] = [:]
    private let lock = NSLock()

    func size(for urlString: String) -> CGSize? {
        lock.lock(); defer { lock.unlock() }
        return cache.get(urlString)
    }

    func hasSize(for urlString: String) -> Bool {
        size(for: urlString) != nil
    }

    /// 同一 URL 只下载一次，所有等待方都会收到回调。完成回调在主线程。
    func fetchSize(for urlString: String, completion: @escaping (CGSize?) -> Void) {
        lock.lock()
        if let cached = cache.get(urlString) {
            lock.unlock()
            DispatchQueue.main.async { completion(cached) }
            return
        }
        pendingCompletions[urlString, default: []].append(completion)
        let shouldStart = pendingCompletions[urlString]?.count == 1
        lock.unlock()

        guard shouldStart else { return }

        guard let url = URL(string: urlString) else {
            finish(urlString, size: nil)
            return
        }

        KingfisherManager.shared.retrieveImage(
            with: url,
            options: [
                .callbackQueue(.dispatch(.global(qos: .utility))),
                .memoryCacheExpiration(.seconds(TimeInterval(60 * 5))),
                .diskCacheExpiration(.days(7))
            ]
        ) { [weak self] result in
            switch result {
            case .success(let imageResult):
                self?.finish(urlString, size: imageResult.image.size)
            case .failure:
                self?.finish(urlString, size: nil)
            }
        }
    }

    private func finish(_ urlString: String, size: CGSize?) {
        lock.lock()
        if let size { cache.set(size, for: urlString) }
        let callbacks = pendingCompletions.removeValue(forKey: urlString) ?? []
        lock.unlock()
        DispatchQueue.main.async {
            callbacks.forEach { $0(size) }
        }
    }

    /// 全部就绪后在主线程回调。
    func prefetchSizes(for urlStrings: [String], completion: @escaping () -> Void) {
        guard !urlStrings.isEmpty else { completion(); return }
        let group = DispatchGroup()
        for urlString in urlStrings {
            group.enter()
            fetchSize(for: urlString) { _ in group.leave() }
        }
        group.notify(queue: .main) { completion() }
    }

    func clear() {
        lock.lock()
        cache.removeAll()
        let pending = pendingCompletions
        pendingCompletions.removeAll()
        lock.unlock()
        DispatchQueue.main.async {
            pending.values.flatMap { $0 }.forEach { $0(nil) }
        }
    }
}

extension HFlowView {

    /// Core `willDisplay` 钩子，选择器名勿改。
    @objc func hflow_imagesize_willDisplay(_ indexPath: IndexPath) {
        prefetchVisibleImageSizes()
    }

    /// Memory 警告钩子，选择器名勿改。
    @objc func hflow_imagesize_clearCache() {
        HFlowImageSizeCache.shared.clear()
    }

    func cachedImageHeight(url: String, availableWidth: CGFloat) -> CGFloat? {
        guard let size = HFlowImageSizeCache.shared.size(for: url),
              size.width > 0, size.height > 0 else { return nil }
        return availableWidth * (size.height / size.width)
    }

    func cachedImageSize(for url: String) -> CGSize? {
        HFlowImageSizeCache.shared.size(for: url)
    }

    func prefetchImageSizes(urls: [String], completion: @escaping () -> Void) {
        HFlowImageSizeCache.shared.prefetchSizes(for: urls, completion: completion)
    }

    /// 等尺寸就绪再 `reloadData`，避免首屏闪缩。超时仍会刷新一次。
    func prefetchAndReloadData(allImageURLs: [[String]], timeout: TimeInterval = 3.0) {
        let allURLs = Array(Set(allImageURLs.flatMap { $0 }))
        guard !allURLs.isEmpty else {
            reloadData()
            return
        }

        final class ReloadFlag {
            var didFinish = false
        }
        let flag = ReloadFlag()
        let timeoutWork = DispatchWorkItem { [weak self] in
            guard !flag.didFinish else { return }
            flag.didFinish = true
            self?.reloadData()
        }

        prefetchImageSizes(urls: allURLs) { [weak self] in
            timeoutWork.cancel()
            guard !flag.didFinish else { return }
            flag.didFinish = true
            self?.reloadData()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: timeoutWork)
    }

    /// 指定 row 的图片尺寸就绪后只刷新该 row。
    func prefetchImageSizesAndReloadItem(urls: [String], at indexPath: IndexPath) {
        prefetchImageSizes(urls: urls) { [weak self] in
            guard let self else { return }
            let valid = self.validRowIndexPaths(from: [indexPath])
            guard valid.count == 1 else { return }
            UIView.performWithoutAnimation {
                self.reloadRows(at: valid, with: .none)
            }
        }
    }

    /// 预取当前可见 cell 上的 `prefetchImageURLs`。未显示的 cell 还没有 URL，无法提前取。
    func prefetchVisibleImageSizes() {
        var urls = Set<String>()
        for indexPath in indexPathsForVisibleRows ?? [] {
            guard let cell = cellForRow(at: indexPath) as? HFlowBaseCell else { continue }
            for url in cell.prefetchImageURLs where !HFlowImageSizeCache.shared.hasSize(for: url) {
                urls.insert(url)
            }
        }
        guard !urls.isEmpty else { return }
        prefetchImageSizes(urls: Array(urls)) {}
    }
}
