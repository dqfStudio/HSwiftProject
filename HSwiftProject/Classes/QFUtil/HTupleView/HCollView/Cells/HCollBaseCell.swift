//
//  HCollBaseCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import RxSwift

class HCollBaseCell: UICollectionViewCell {

    weak var coll: HCollView?
    var indexPath: IndexPath?

    var willDisplayBlock: (() -> Void)?
    var selectBlock: (() -> Void)?

    override var isSelected: Bool {
        get { super.isSelected }
        set {
            super.isSelected = newValue
            if newValue {
                setSelectedStyle()
            } else {
                setDeSelectedStyle()
            }
        }
    }

    /// 系统选中时调用。默认空，子类改外观。
    func setSelectedStyle() {}

    /// 系统取消选中时调用。默认空，子类改外观。
    func setDeSelectedStyle() {}

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
        if isSelected {
            isSelected = false
        }
    }

    /// HCollView 用 `sizeForItem` 定高，默认不在这里改尺寸。
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes
    }
}

/// 带 ViewModel 绑定的 `HCollBaseCell`。
///
/// UIKit 复用时无法在 `init` 里注入 VM，需在配置 cell 时调用 `bindViewModel(_:)`。
/// 只重置 cell 自己的订阅，不要在这里 `viewModel.destroy()`。
class HCollBindableCell<VM: HBaseViewModel>: HCollBaseCell {

    private(set) var viewModel: VM?

    var disposeBag: DisposeBag? = DisposeBag()

    /// 先换 bag 再赋值，避免同一次配置被调两次时叠订阅。
    func bindViewModel(_ viewModel: VM) {
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        bindViewModel()
    }

    /// 子类订阅 Relays。子视图仍走 `initUI()`。
    func bindViewModel() {}

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        viewModel = nil
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

func HCollResetTextField(_ field: HTextFieldView?) {
    field?.resetForReuse()
}
