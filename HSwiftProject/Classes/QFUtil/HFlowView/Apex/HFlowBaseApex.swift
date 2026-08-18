//
//  HFlowBaseApex.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/3.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import RxSwift

/// UITableViewHeaderFooterView 基类。子视图加在 contentView；坐标系相对 contentView 再叠加 `edgeInsets`。
class HFlowBaseApex: UITableViewHeaderFooterView {

    weak var flow: UITableView?
    var isHeader: Bool = false
    var indexPath: IndexPath?
    /// 业务可挂 section 模型；复用时清空，需在 `reuseHeader` / `reuseFooter` 后自行赋值。
    var section: Any?
    var willDisplayBlock: (() -> Void)?

    /// 内容区内边距。复用时会清零。
    @objc var edgeInsets: UIEdgeInsets = .zero {
        didSet {
            if edgeInsets != oldValue {
                setNeedsLayout()
            }
        }
    }

    /// 子视图加在 `contentView` 上，坐标系相对 contentView；再叠加 `edgeInsets`。
    var contentBounds: CGRect {
        let contentSize = contentView.bounds.size
        let selfSize = bounds.size
        let size: CGSize
        if contentSize.width > 0, contentSize.height > 0 {
            size = contentSize
        } else if selfSize.width > 0, selfSize.height > 0 {
            size = selfSize
        } else {
            size = contentSize
        }
        return CGRect(origin: .zero, size: size).inset(by: edgeInsets)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        clearBackground()
        initUI()
    }

    required override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        clearBackground()
        initUI()
    }

    private func clearBackground() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        backgroundView = UIView()
        backgroundView?.backgroundColor = .clear
        if #available(iOS 14.0, *) {
            backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
    }

    func initUI() {}

    /// 子类在这里排子视图。
    func relayoutSubviews() {}

    /// Stack 等子类在调用 `relayoutSubviews` 之前先摆好容器。
    func prepareLayout() {}

    /// 完整排一次：先容器，再子视图。配完 header/footer 后也应走这里。
    func applyLayout() {
        prepareLayout()
        relayoutSubviews()
    }

    /// 把 `view` 铺满内容区（已含 `edgeInsets`）。
    func fillContent(_ view: UIView) {
        let frame = contentBounds
        if view.frame != frame {
            view.frame = frame
        }
    }

    func reloadSupplementaryData() {
        guard let table = flow ?? (superview as? UITableView),
              let section = indexPath?.section else { return }
        table.reloadSections(IndexSet(integer: section), with: .none)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        willDisplayBlock = nil
        indexPath = nil
        isHeader = false
        section = nil
        edgeInsets = .zero
    }
}

/// 带 ViewModel 绑定的 `HFlowBaseApex`。
///
/// UIKit 复用时无法在 `init` 里注入 VM，需在 `flowHeader` / `flowFooter` 里调用 `bindViewModel(_:)`。
/// 只重置自身订阅，不要在这里 `viewModel.destroy()`。
class HFlowBindableApex<VM: HBaseViewModel>: HFlowBaseApex {

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
