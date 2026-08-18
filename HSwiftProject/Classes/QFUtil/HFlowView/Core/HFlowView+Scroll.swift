//
//  HFlowView+Scroll.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  滚动定位、bounce。
//

import UIKit

extension HFlowView {

    func enableHorizontalBounce() {
        bounces = true
        alwaysBounceHorizontal = true
        alwaysBounceVertical = false
    }

    func enableVerticalBounce() {
        bounces = true
        alwaysBounceHorizontal = false
        alwaysBounceVertical = true
    }

    func enableBounce() {
        bounces = true
        alwaysBounceHorizontal = true
        alwaysBounceVertical = true
    }

    func disableBounce() {
        bounces = false
    }

    func scrollToTop(animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
            self.scrollRectToVisible(rect, animated: animated)
        }
    }

    func scrollToTop(_ animated: Bool) {
        scrollToTop(animated: animated)
    }

    /// section 越界或该 section 无 row 则忽略。
    func scrollToSection(_ section: Int, animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let sections = self.numberOfSections
            guard section >= 0 && section < sections else { return }
            guard self.numberOfRows(inSection: section) > 0 else { return }
            self.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: animated)
        }
    }

    /// indexPath 越界则忽略。真正滚动前再校验一次，避免排队期间数据已变。
    func scrollToRowSafely(at indexPath: IndexPath, at position: UITableView.ScrollPosition, animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let sections = self.numberOfSections
            guard indexPath.section >= 0 && indexPath.section < sections else { return }
            let rows = self.numberOfRows(inSection: indexPath.section)
            guard indexPath.row >= 0 && indexPath.row < rows else { return }
            self.scrollToRow(at: indexPath, at: position, animated: animated)
        }
    }

    func smoothScroll(to contentOffset: CGPoint, duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.contentOffset = contentOffset
        }
    }

    /// 没有 section / row 时忽略。
    func scrollToBottom(animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let sections = self.numberOfSections
            guard sections > 0 else { return }
            let lastSection = sections - 1
            let rows = self.numberOfRows(inSection: lastSection)
            guard rows > 0 else { return }
            self.scrollToRow(at: IndexPath(row: rows - 1, section: lastSection), at: .bottom, animated: animated)
        }
    }

    func scrollToBottom(_ animated: Bool) {
        scrollToBottom(animated: animated)
    }
}
