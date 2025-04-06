//
//  HCollView+Align.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/6.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

// 策略模式：对齐策略协议
protocol HCollAlignStrategy {
    func calculateCntInset(for view: HCollView, cntSize: CGSize, cntInset: UIEdgeInsets) -> UIEdgeInsets
}

// 策略模式：默认对齐策略
struct HCollDefaultAlignStrategy: HCollAlignStrategy {
    func calculateCntInset(for view: HCollView, cntSize: CGSize, cntInset: UIEdgeInsets) -> UIEdgeInsets {
        return .zero
    }
}

// 策略模式：居中对齐策略
struct HCollCenterAlignStrategy: HCollAlignStrategy {
    func calculateCntInset(for view: HCollView, cntSize: CGSize, cntInset: UIEdgeInsets) -> UIEdgeInsets {
        let originX = (view.width - cntSize.width) / 2
        let originY = (view.height - cntSize.height) / 2
        return UIEdgeInsets(top: max(originY, 0),
                            left: max(originX, 0),
                            bottom: cntInset.bottom,
                            right: cntInset.right)
    }
}

// 策略模式：顶部对齐策略
struct HCollTopAlignStrategy: HCollAlignStrategy {
    let top: CGFloat
    
    init(top: CGFloat) {
        self.top = top
    }
    func calculateCntInset(for view: HCollView, cntSize: CGSize, cntInset: UIEdgeInsets) -> UIEdgeInsets {
        let originX = (view.width - cntSize.width) / 2
        return UIEdgeInsets(top: top,
                            left: max(originX, 0),
                            bottom: cntInset.bottom,
                            right: cntInset.right)
    }
}

// 策略模式：比例对齐策略
struct HCollRatioAlignStrategy: HCollAlignStrategy {
    let ratio: CGFloat
    
    init(ratio: CGFloat) {
        self.ratio = ratio
    }
    func calculateCntInset(for view: HCollView, cntSize: CGSize, cntInset: UIEdgeInsets) -> UIEdgeInsets {
        let originX = (view.width - cntSize.width) / 2
        let originY = (view.height - cntSize.height) * ratio
        return UIEdgeInsets(top: max(originY, 0),
                            left: max(originX, 0),
                            bottom: cntInset.bottom,
                            right: cntInset.right)
    }
}

// 策略模式：底部对齐策略
struct HCollBottomAlignStrategy: HCollAlignStrategy {
    let bottom: CGFloat
    
    init(bottom: CGFloat) {
        self.bottom = bottom
    }
    func calculateCntInset(for view: HCollView, cntSize: CGSize, cntInset: UIEdgeInsets) -> UIEdgeInsets {
        let originX = (view.width - cntSize.width) / 2
        let originY = view.height - cntSize.height - bottom
        return UIEdgeInsets(top: max(originY, 0),
                            left: max(originX, 0),
                            bottom: cntInset.bottom,
                            right: cntInset.right)
    }
}

// 对齐策略工厂类
class HCollAlignStrategyFactory {
    static func createStrategy(for align: HCollAlign) -> HCollAlignStrategy {
        switch align {
        case .default:
            return HCollDefaultAlignStrategy()
        case .center:
            return HCollCenterAlignStrategy()
        case .top(let top):
            return HCollTopAlignStrategy(top: top)
        case .ratio(let ratio):
            return HCollRatioAlignStrategy(ratio: ratio)
        case .bottom(let bottom):
            return HCollBottomAlignStrategy(bottom: bottom)
        }
    }
}
