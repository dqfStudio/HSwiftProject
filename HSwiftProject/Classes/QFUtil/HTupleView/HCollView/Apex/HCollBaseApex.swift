//
//  HCollBaseApex.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import RxSwift

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

/// 带 ViewModel 绑定的 `HCollBaseApex`。
///
/// UIKit 复用时无法在 `init` 里注入 VM，需在配置 header / footer 时调用 `bindViewModel(_:)`。
/// 只重置自身订阅，不要在这里 `viewModel.destroy()`。
class HCollBindableApex<VM: HBaseViewModel>: HCollBaseApex {

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
