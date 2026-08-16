//
//  HCollBaseCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HCollBaseCell: UICollectionViewCell {

    weak var coll: HCollView?
    var indexPath: IndexPath?

    var willDisplayBlock: (() -> Void)?
    var selectBlock: (() -> Void)?

    /// 业务在配置 cell 时写入，框架在 willDisplay 时预取尺寸。
    var prefetchImageURLs: [String] = []

    /// 复用后 `contentView.bounds` 可能仍是上一格的尺寸。子视图加在 contentView 上，原点归零；尺寸与 cell 对得上才用 contentView。
    var contentBounds: CGRect {
        let cellSize = bounds.size
        let contentSize = contentView.bounds.size
        let size: CGSize
        if contentSize.width > 0, contentSize.height > 0,
           abs(contentSize.width - cellSize.width) <= 1,
           abs(contentSize.height - cellSize.height) <= 1 {
            size = contentSize
        } else if cellSize.width > 0, cellSize.height > 0 {
            size = cellSize
        } else {
            size = contentSize
        }
        return CGRect(origin: .zero, size: size)
    }

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

    /// 子类在这里排子视图。由 `layoutSubviews` 调用，不依赖列表是否记得调。
    func relayoutSubviews() {}

    /// 把 `view` 铺满内容区。
    func fillContent(_ view: UIView) {
        let frame = contentBounds
        if view.frame != frame {
            view.frame = frame
        }
    }

    func reloadItemData() {
        let collection = coll ?? (superview as? UICollectionView)
        guard let collection, let indexPath = collection.indexPath(for: self) else { return }
        collection.reloadItems(at: [indexPath])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyLayout()
    }

    /// Stack 等子类在调用 `relayoutSubviews` 之前先摆好容器。
    func prepareLayout() {}

    /// 完整排一次：先容器，再子视图。`cellForItem` 配完后也应走这里，不要只调 `relayoutSubviews`。
    func applyLayout() {
        prepareLayout()
        relayoutSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        willDisplayBlock = nil
        selectBlock = nil
        prefetchImageURLs = []
        indexPath = nil
    }

    /// HCollView 用 `sizeForItem` 定高，默认不在这里改尺寸。
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes
    }
}

func HCollMakeLabel() -> UILabel {
    let label = UILabel()
    HCollResetLabel(label)
    return label
}

func HCollResetLabel(_ label: UILabel?) {
    guard let label else { return }
    label.text = nil
    label.attributedText = nil
    label.font = .systemFont(ofSize: 14)
    label.textColor = .label
    label.textAlignment = .natural
    label.numberOfLines = 1
}

func HCollResetTextView(_ textView: HTextView?) {
    textView?.resignFirstResponder()
    textView?.text = nil
}

func HCollResetTextField(_ field: HTextField?) {
    field?.resignFirstResponder()
    field?.text = nil
}
