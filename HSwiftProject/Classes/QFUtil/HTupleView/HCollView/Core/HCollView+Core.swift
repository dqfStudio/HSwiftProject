//
//  HCollView+Core.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  初始化、reuseCell / Header / Footer，以及空白区域点击。
//

import UIKit

// MARK: - 初始化与复用

extension HCollView {

    override var frame: CGRect {
        get { super.frame }
        set {
            let adjustedFrame = HCollRectIntegral(newValue)
            let oldWidth = super.frame.width
            super.frame = adjustedFrame
            // 只在宽度变化（如旋转）时 invalidate，避免 Auto Layout 每次都重算
            if abs(adjustedFrame.width - oldWidth) > 0.5 {
                collectionViewLayout.invalidateLayout()
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        invokeFeatures([
            HCollFeatureSelector.alignLayout,
            HCollFeatureSelector.emptyLayout
        ])
    }

    /// 默认外观，并把 UIKit 的 delegate / dataSource 指回自身。
    internal func setup() {
        invokeFeature(HCollFeatureSelector.observerSetup)
        invokeFeature(HCollFeatureSelector.memorySetup)

        self.tag = kCollDefaultTag

        if self.flowLayout?.scrollDirection == .vertical {
            self.enableVerticalBounce()
        } else {
            self.enableHorizontalBounce()
        }

        self.backgroundColor = .clear
        self.keyboardDismissMode = .onDrag
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.contentInsetAdjustmentBehavior = .never

        super.delegate = self
        super.dataSource = self
    }

    /// `idx == true` 时 identifier 带上 indexPath，每个位置单独注册。
    internal func generateIdentifier(_ cls: AnyClass, _ idx: Bool, _ indexPath: IndexPath) -> String {
        var identifier = NSStringFromClass(cls)
        identifier += idx ? "\(indexPath.section)-\(indexPath.item)" : ""
        return identifier
    }

    /// 在 `collHeader` 里调用。未注册过则当场 register。
    @discardableResult
    func reuseHeader<T: HCollBaseApex>(_ cls: T.Type, _ idx: Bool, _ indexPath: IndexPath) -> T {
        let identifier = generateIdentifier(cls, idx, indexPath)

        if !allHeaderIdentifiers.contains(identifier) {
            allHeaderIdentifiers.insert(identifier)
            register(cls, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
        }

        let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as! T
        view.indexPath = indexPath
        view.isHeader = true
        view.coll = self
        pendingReuseHeader = view
        return view
    }

    /// 在 `collFooter` 里调用。未注册过则当场 register。
    @discardableResult
    func reuseFooter<T: HCollBaseApex>(_ cls: T.Type, _ idx: Bool, _ indexPath: IndexPath) -> T {
        let identifier = generateIdentifier(cls, idx, indexPath)

        if !allFooterIdentifiers.contains(identifier) {
            allFooterIdentifiers.insert(identifier)
            register(cls, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
        }

        let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath) as! T
        view.indexPath = indexPath
        view.isHeader = false
        view.coll = self
        pendingReuseFooter = view
        return view
    }

    /// 在 `collItem` 里调用。DataSource 随后把本次取出的实例返回给 UIKit。
    @discardableResult
    func reuseCell<T: HCollBaseCell>(_ cls: T.Type, _ idx: Bool, _ indexPath: IndexPath) -> T {
        let identifier = generateIdentifier(cls, idx, indexPath)

        if !allCellIdentifiers.contains(identifier) {
            allCellIdentifiers.insert(identifier)
            register(cls, forCellWithReuseIdentifier: identifier)
        }

        let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
        cell.indexPath = indexPath
        cell.coll = self
        pendingReuseCell = cell
        return cell
    }

    /// 当前屏上的 cell。滑出屏幕后为 nil，应改数据源等它再次出现。
    func cell(item: Int, section: Int) -> AnyObject? {
        cell(for: IndexPath(item: item, section: section))
    }

    func cell(for indexPath: IndexPath) -> AnyObject? {
        cellForItem(at: indexPath)
    }

    func header(for section: Int) -> AnyObject? {
        supplementaryView(
            forElementKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: section)
        )
    }

    func footer(for section: Int) -> AnyObject? {
        supplementaryView(
            forElementKind: UICollectionView.elementKindSectionFooter,
            at: IndexPath(item: 0, section: section)
        )
    }

    func width(for section: Int) -> CGFloat {
        let inset = allSectionInsets[section] ?? collDelegate?.insetForSection?(section) ?? .zero
        return max(bounds.width - inset.left - inset.right, 0)
    }

    func height(for section: Int) -> CGFloat {
        let inset = allSectionInsets[section] ?? collDelegate?.insetForSection?(section) ?? .zero
        return max(bounds.height - inset.top - inset.bottom, 0)
    }

    /// 设置了 `outsideContentBlock` 时：点在 cell / header / footer 上走默认命中；点空白处仍返回 true 并回调。
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let outsideContentBlock = self.outsideContentBlock else {
            return super.point(inside: point, with: event)
        }

        guard let layoutAttributes = collectionViewLayout.layoutAttributesForElements(in: bounds) else {
            return true
        }

        for attribute in layoutAttributes {
            if attribute.frame.contains(point) {
                switch attribute.representedElementCategory {
                case .cell, .supplementaryView:
                    return true
                default:
                    break
                }
            }
        }

        outsideContentBlock()
        return true
    }

}
