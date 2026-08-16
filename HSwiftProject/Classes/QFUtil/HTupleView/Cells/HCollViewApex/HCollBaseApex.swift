//
//  HCollBaseApex.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HCollBaseApex: UICollectionReusableView {

    weak var coll: HCollView?
    var isHeader: Bool = false
    var indexPath: IndexPath?

    var willDisplayBlock: (() -> Void)?

    /// 内容边距。只参与子视图布局，不会改自身 frame。
    var contentInsets: UIEdgeInsets = .zero {
        didSet {
            if contentInsets != oldValue {
                setNeedsLayout()
            }
        }
    }

    /// 兼容旧调用。语义与 `contentInsets` 相同，不会 inset 自身 frame。
    @objc override var edgeInsets: UIEdgeInsets {
        get { contentInsets }
        set { contentInsets = newValue }
    }

    var layoutViewFrame: CGRect {
        contentBounds.inset(by: contentInsets)
    }

    var layoutViewBounds: CGRect {
        CGRect(origin: .zero, size: layoutViewFrame.size)
    }

    var contentBounds: CGRect { bounds }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        initUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        initUI()
    }

    func initUI() {}

    func relayoutSubviews() {}

    func fillContent(_ view: UIView) {
        let frame = contentBounds.inset(by: contentInsets)
        if view.frame != frame {
            view.frame = frame
        }
    }

    func reloadSupplementaryData() {
        guard let collection = coll ?? (superview as? UICollectionView),
              let section = indexPath?.section else { return }
        collection.reloadSections(IndexSet(integer: section))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyLayout()
    }

    func prepareLayout() {}

    func applyLayout() {
        prepareLayout()
        relayoutSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        willDisplayBlock = nil
        indexPath = nil
        isHeader = false
        contentInsets = .zero
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes
    }
}
