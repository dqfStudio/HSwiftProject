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
        let frame = bounds
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
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes
    }
}
