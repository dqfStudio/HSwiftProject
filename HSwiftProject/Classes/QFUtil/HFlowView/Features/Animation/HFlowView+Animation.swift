//
//  HFlowView+Animation.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//
//  cell 入场动画，建议在 willDisplayCell 里调用。
//

import UIKit

extension HFlowView {

    enum CellAppearAnimation {
        case fade
        case slideUp
        case scale
        case bounce
    }

    /// 入场动画。delay 按 row 递增，上限 0.24s。建议在 `willDisplayCell` 里调用。
    func playAppearAnimation(_ animation: CellAppearAnimation, on cell: UITableViewCell, at indexPath: IndexPath) {
        let delay = min(TimeInterval(indexPath.row) * 0.04, 0.24)
        cell.layer.removeAllAnimations()

        switch animation {
        case .fade:
            cell.alpha = 0
            cell.transform = .identity
            UIView.animate(withDuration: 0.28, delay: delay, options: .curveEaseOut) {
                cell.alpha = 1
            }
        case .slideUp:
            cell.alpha = 0
            cell.transform = CGAffineTransform(translationX: 0, y: 20)
            UIView.animate(withDuration: 0.32, delay: delay, options: .curveEaseOut) {
                cell.alpha = 1
                cell.transform = .identity
            }
        case .scale:
            cell.alpha = 0
            cell.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseOut) {
                cell.alpha = 1
                cell.transform = .identity
            }
        case .bounce:
            cell.alpha = 0
            cell.transform = CGAffineTransform(scaleX: 0.82, y: 0.82)
            UIView.animate(
                withDuration: 0.45,
                delay: delay,
                usingSpringWithDamping: 0.68,
                initialSpringVelocity: 0.6,
                options: .curveEaseOut
            ) {
                cell.alpha = 1
                cell.transform = .identity
            }
        }
    }

    func playAppearAnimation(_ animation: CellAppearAnimation, on cells: [UITableViewCell]) {
        for (index, cell) in cells.enumerated() {
            playAppearAnimation(animation, on: cell, at: IndexPath(row: index, section: 0))
        }
    }
}
