//
//  HFlowView+Core.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  初始化、reuseCell / Header / Footer，以及空白区域点击。
//

import UIKit

// MARK: - 初始化与复用

extension HFlowView {

    override var frame: CGRect {
        get { super.frame }
        set {
            let adjustedFrame = HFlowRectIntegral(newValue)
            super.frame = adjustedFrame
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        currentContentSize = contentSize
        invokeFeature(HFlowFeatureSelector.emptyLayout)
    }

    /// 默认外观，并把 UIKit 的 delegate / dataSource 指回自身。
    internal func setup() {
        invokeFeature(HFlowFeatureSelector.observerSetup)
        invokeFeature(HFlowFeatureSelector.memorySetup)
        invokeFeature(HFlowFeatureSelector.prerenderSetup)

        tag = kFlowDefaultTag
        enableVerticalBounce()

        backgroundColor = .clear
        keyboardDismissMode = .onDrag
        estimatedSectionHeaderHeight = 0
        estimatedSectionFooterHeight = 0
        estimatedRowHeight = Constants.defaultEstimatedHeight
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
        separatorStyle = .none
        tableFooterView = UIView()
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }

        super.delegate = self
        super.dataSource = self
    }

    /// `idx == true` 时 identifier 带上 indexPath，每个位置单独注册。
    internal func generateIdentifier(_ cls: AnyClass, _ idx: Bool, _ indexPath: IndexPath) -> String {
        var identifier = NSStringFromClass(cls)
        identifier += idx ? "\(indexPath.section)-\(indexPath.row)" : ""
        return identifier
    }

    /// 在 `flowHeader` 里调用。未注册过则当场 register。
    @discardableResult
    func reuseHeader<T: HFlowBaseApex>(_ cls: T.Type, _ idx: Bool, _ indexPath: IndexPath) -> T {
        let identifier = generateIdentifier(cls, idx, indexPath)
        if !allHeaderIdentifiers.contains(identifier) {
            allHeaderIdentifiers.insert(identifier)
            register(cls, forHeaderFooterViewReuseIdentifier: identifier)
        }
        let view = (dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T) ?? T(reuseIdentifier: identifier)
        view.indexPath = indexPath
        view.isHeader = true
        view.flow = self
        pendingReuseHeader = view
        return view
    }

    /// 在 `flowFooter` 里调用。未注册过则当场 register。
    @discardableResult
    func reuseFooter<T: HFlowBaseApex>(_ cls: T.Type, _ idx: Bool, _ indexPath: IndexPath) -> T {
        let identifier = generateIdentifier(cls, idx, indexPath)
        if !allFooterIdentifiers.contains(identifier) {
            allFooterIdentifiers.insert(identifier)
            register(cls, forHeaderFooterViewReuseIdentifier: identifier)
        }
        let view = (dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T) ?? T(reuseIdentifier: identifier)
        view.indexPath = indexPath
        view.isHeader = false
        view.flow = self
        pendingReuseFooter = view
        return view
    }

    @discardableResult
    func reuseHeader<T: HFlowBaseApex>(_ cls: T.Type, _ idx: Bool, _ section: Int) -> T {
        reuseHeader(cls, idx, IndexPath(row: 0, section: section))
    }

    @discardableResult
    func reuseFooter<T: HFlowBaseApex>(_ cls: T.Type, _ idx: Bool, _ section: Int) -> T {
        reuseFooter(cls, idx, IndexPath(row: 0, section: section))
    }

    /// 在 `flowRow` 里调用。DataSource 随后把本次取出的实例返回给 UIKit。
    @discardableResult
    func reuseCell<T: HFlowBaseCell>(_ cls: T.Type, _ idx: Bool, _ indexPath: IndexPath) -> T {
        let identifier = generateIdentifier(cls, idx, indexPath)
        if !allCellIdentifiers.contains(identifier) {
            allCellIdentifiers.insert(identifier)
            register(cls, forCellReuseIdentifier: identifier)
        }
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
        cell.indexPath = indexPath
        cell.flow = self
        pendingReuseCell = cell
        return cell
    }

    /// 当前屏上的 cell。滑出屏幕后为 nil，应改数据源等它再次出现。
    func cell(row: Int, section: Int) -> AnyObject? {
        cell(for: IndexPath(row: row, section: section))
    }

    func cell(for indexPath: IndexPath) -> AnyObject? {
        cellForRow(at: indexPath)
    }

    func header(for section: Int) -> AnyObject? {
        headerView(forSection: section)
    }

    func footer(for section: Int) -> AnyObject? {
        footerView(forSection: section)
    }

    func width(for section: Int) -> CGFloat {
        max(bounds.width, 0)
    }

    func height(for section: Int) -> CGFloat {
        max(bounds.height, 0)
    }

    /// 设置了 `outsideContentBlock` 时：点在可见 cell / header / footer 上走默认命中；点空白处仍返回 true 并回调。
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let outsideContentBlock else {
            return super.point(inside: point, with: event)
        }
        if indexPathsForVisibleRows?.contains(where: { rectForRow(at: $0).contains(point) }) == true {
            return true
        }
        for section in 0..<numberOfSections {
            if rectForHeader(inSection: section).contains(point)
                || rectForFooter(inSection: section).contains(point) {
                return true
            }
        }
        outsideContentBlock()
        return true
    }

    /// HFlowView 自身没实现的 `UITableViewDelegate` 方法转给 `flowDelegate`（如 swipe / edit / context menu）。
    override func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) {
            return true
        }
        return flowDelegate?.responds(to: aSelector) ?? false
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let flowDelegate, flowDelegate.responds(to: aSelector) {
            return flowDelegate
        }
        return super.forwardingTarget(for: aSelector)
    }
}
