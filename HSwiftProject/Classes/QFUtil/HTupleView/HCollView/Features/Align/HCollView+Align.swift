//
//  HCollView+Align.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/6.
//  Copyright © 2025 wind. All rights reserved.
//
//  通过 contentInset 把内容在可视区域内对齐。
//

import UIKit

/// 通过改 `contentInset` 让内容在可视区域内对齐。内容高于 bounds 时不会再额外加 inset。
enum HCollAlign: Equatable {
    case `default` // 垂直居上，水平居左
    case center    // 垂直居中，水平居中
    case top(CGFloat)    // 距顶固定距离，水平居中
    case ratio(CGFloat)  // 距顶比例 0...1，水平居中
    case bottom(CGFloat) // 距底固定距离，水平居中
}

private final class HCollAlignBox {
    var value: HCollAlign
    init(_ value: HCollAlign) { self.value = value }
}

private var hcollAlignKey: UInt8 = 0
private var hcollDidApplyAlignInsetKey: UInt8 = 0

extension HCollView {

    var collAlign: HCollAlign {
        get { (objc_getAssociatedObject(self, &hcollAlignKey) as? HCollAlignBox)?.value ?? .default }
        set {
            objc_setAssociatedObject(self, &hcollAlignKey, HCollAlignBox(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateAlign()
        }
    }

    private var didApplyAlignInset: Bool {
        get { (objc_getAssociatedObject(self, &hcollDidApplyAlignInsetKey) as? NSNumber)?.boolValue ?? false }
        set {
            objc_setAssociatedObject(self, &hcollDidApplyAlignInsetKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    internal func updateAlign() {
        currentContentSize = contentSize
        if collAlign == .default {
            if didApplyAlignInset {
                if contentInset != .zero {
                    contentInset = .zero
                }
                didApplyAlignInset = false
            }
            return
        }
        // MJRefresh 会改 contentInset，再叠对齐会把 header / footer 顶没。
        if hasMJRefreshChrome {
            return
        }
        let inset = alignInset(for: collAlign, contentSize: contentSize)
        if contentInset != inset {
            contentInset = inset
        }
        didApplyAlignInset = true
    }

    /// 不直接 import MJRefresh，Refresh 未加入工程时这里为 false。
    private var hasMJRefreshChrome: Bool {
        let headerSel = NSSelectorFromString("mj_header")
        let footerSel = NSSelectorFromString("mj_footer")
        if responds(to: headerSel), perform(headerSel) != nil { return true }
        if responds(to: footerSel), perform(footerSel) != nil { return true }
        return false
    }

    private func alignInset(for align: HCollAlign, contentSize: CGSize) -> UIEdgeInsets {
        let centerX = max((bounds.width - contentSize.width) / 2, 0)
        switch align {
        case .default:
            return .zero
        case .center:
            return UIEdgeInsets(top: max((bounds.height - contentSize.height) / 2, 0), left: centerX, bottom: 0, right: 0)
        case .top(let top):
            return UIEdgeInsets(top: max(top, 0), left: centerX, bottom: 0, right: 0)
        case .ratio(let ratio):
            let clamped = min(max(ratio, 0), 1)
            return UIEdgeInsets(top: max((bounds.height - contentSize.height) * clamped, 0), left: centerX, bottom: 0, right: 0)
        case .bottom(let bottom):
            return UIEdgeInsets(top: max(bounds.height - contentSize.height - max(bottom, 0), 0), left: centerX, bottom: 0, right: 0)
        }
    }

    /// Core `layoutSubviews` 钩子，选择器名勿改。
    @objc func hcoll_align_layoutSubviews() {
        updateAlign()
    }
}
