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

    /// cell 内容边距。只参与子视图布局，不会改 cell 自身 frame。
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

    /// 复用后 `contentView.bounds` 可能仍是上一格的尺寸，和当前 `bounds` 对不上时用 cell 自己的 bounds。
    var contentBounds: CGRect {
        let content = contentView.bounds
        let cell = bounds
        if content.size.width > 0 && content.size.height > 0
            && abs(content.size.width - cell.size.width) <= 1
            && abs(content.size.height - cell.size.height) <= 1 {
            return content
        }
        if cell.size.width > 0 && cell.size.height > 0 {
            return cell
        }
        return content
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

    /// 把 `view` 铺满内容区（已扣除 `contentInsets`）。
    func fillContent(_ view: UIView) {
        let frame = contentBounds.inset(by: contentInsets)
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
        contentInsets = .zero
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
