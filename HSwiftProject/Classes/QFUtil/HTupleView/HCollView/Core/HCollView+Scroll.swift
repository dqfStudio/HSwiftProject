//
//  HCollView+Scroll.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  滚动定位、bounce、header / footer 吸顶开关。
//

import UIKit

// MARK: - 滚动

extension HCollView {

    var sectionHeadersPinToVisibleBounds: Bool {
        get { return flowLayout?.sectionHeadersPinToVisibleBounds ?? false }
        set { flowLayout?.sectionHeadersPinToVisibleBounds = newValue }
    }

    var sectionFootersPinToVisibleBounds: Bool {
        get { return flowLayout?.sectionFootersPinToVisibleBounds ?? false }
        set { flowLayout?.sectionFootersPinToVisibleBounds = newValue }
    }

    func enableHorizontalBounce() {
        self.bounces = true
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = false
    }

    func enableVerticalBounce() {
        self.bounces = true
        self.alwaysBounceHorizontal = false
        self.alwaysBounceVertical = true
    }

    func enableBounce() {
        self.bounces = true
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = true
    }

    func disableBounce() {
        self.bounces = false
    }

    func scrollToTop(_ animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
            self.scrollRectToVisible(rect, animated: animated)
        }
    }

    /// section 越界则忽略。
    func scrollToSection(_ section: Int, animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let sections = self.numberOfSections
            guard section >= 0 && section < sections else { return }

            guard self.numberOfItems(inSection: section) > 0 else { return }
            self.scrollToItem(at: IndexPath(item: 0, section: section), at: .top, animated: animated)
        }
    }

    /// indexPath 越界则忽略。真正滚动前再校验一次，避免排队期间数据已变。
    func scrollToItemSafely(at indexPath: IndexPath, at position: UICollectionView.ScrollPosition, animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let sections = self.numberOfSections
            guard indexPath.section >= 0 && indexPath.section < sections else { return }

            let items = self.numberOfItems(inSection: indexPath.section)
            guard indexPath.item >= 0 && indexPath.item < items else { return }

            self.scrollToItem(at: indexPath, at: position, animated: animated)
        }
    }

    func smoothScroll(to contentOffset: CGPoint, duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.contentOffset = contentOffset
        }
    }

    /// 没有 section / item 时忽略。
    func scrollToBottom(_ animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let sections = self.numberOfSections
            guard sections > 0 else { return }

            let lastSection = sections - 1
            let items = self.numberOfItems(inSection: lastSection)
            guard items > 0 else { return }

            self.scrollToItem(at: IndexPath(item: items - 1, section: lastSection), at: .bottom, animated: animated)
        }
    }
}
