//
//  HFlowView+Utils.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  分页常量和像素取整。
//

import UIKit

let kFlowDefaultTag = 1213141516

typealias HFlowOutsideCntBlock = () -> Void
typealias HFlowCntSizeBlock = (_ cntSize: CGSize) -> Void

struct HFlowPageConfig {
    static let defaultPageNo = 1
    static let defaultPageSize = 20
    /// 未设置总数时的占位值，不表示「总数不能小于 10000」。
    static let maxTotalPages = 10000
}

/// 原点向下取整，宽高按右/下边界再取整，避免亚像素布局。
func HFlowRectIntegral(_ rect: CGRect) -> CGRect {
    let x: CGFloat = rect.origin.x.rounded(.down)
    let y: CGFloat = rect.origin.y.rounded(.down)
    let width: CGFloat = (rect.origin.x + rect.width - x).rounded(.down)
    let height: CGFloat = (rect.origin.y + rect.height - y).rounded(.down)
    return CGRect(x: x, y: y, width: width, height: height)
}

func HFlowSizeIntegral(_ size: CGSize) -> CGSize {
    CGSize(width: floor(size.width), height: floor(size.height))
}

extension HFlowView {
    /// 仍指向当前数据源的 row。section / row 越界的会丢掉。
    internal func validRowIndexPaths(from indexPaths: [IndexPath]) -> [IndexPath] {
        let sections = numberOfSections
        return indexPaths.filter { path in
            path.section >= 0
                && path.section < sections
                && path.row >= 0
                && path.row < numberOfRows(inSection: path.section)
        }
    }
}

extension IndexPath {
    /// `section-row`，给业务 identifier 用。
    var stringValue: String {
        "\(section)-\(row)"
    }
}
