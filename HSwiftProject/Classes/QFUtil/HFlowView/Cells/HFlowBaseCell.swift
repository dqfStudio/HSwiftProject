//
//  HFlowBaseCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/3.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import RxSwift

typealias HTableCellSelectBlock = () -> Void

/// UITableViewCell 基类。子视图加在 contentView；用 `contentBounds` / `applyLayout` 排版，不要依赖 Auto Dimension。
class HFlowBaseCell: UITableViewCell {

    weak var flow: UITableView?
    var indexPath: IndexPath?

    var willDisplayBlock: HTableCellSelectBlock?
    var selectBlock: HTableCellSelectBlock?

    /// 业务在配置 cell 时写入，框架在 willDisplay 时预取尺寸。
    var prefetchImageURLs: [String] = []

    /// 内容区内边距。复用时会清零，配置侧需每行重设。
    @objc var edgeInsets: UIEdgeInsets = .zero {
        didSet {
            if edgeInsets != oldValue {
                setNeedsLayout()
            }
        }
    }

    var style: UITableViewCell.CellStyle = .default

    /// 复用后 `contentView.bounds` 可能仍是上一格尺寸。子视图加在 contentView 上，原点归零；
    /// 尺寸与 cell 对得上才用 contentView，再叠加 `edgeInsets`。
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
        return CGRect(origin: .zero, size: size).inset(by: edgeInsets)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        initUI()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        self.style = style
        initUI()
    }

    /// `.disclosureIndicator` 换成工程箭头图；其余类型交给系统。
    override var accessoryType: UITableViewCell.AccessoryType {
        get {
            return super.accessoryType
        }
        set {
            switch newValue {
            case .none:
                accessoryView = nil
                super.accessoryType = .none
            case .disclosureIndicator:
                let arrowView = UIImageView(frame: CGRect(x: 0, y: 0, width: 7, height: 13))
                arrowView.image = UIImage(named: "icon_tuple_arrow_right")
                accessoryView = arrowView
                super.accessoryType = .none
            default:
                accessoryView = nil
                super.accessoryType = newValue
            }
        }
    }

    func initUI() {}

    /// 子类在这里排子视图。由 `layoutSubviews` / `applyLayout` 调用。
    func relayoutSubviews() {}

    /// Stack 等子类在调用 `relayoutSubviews` 之前先摆好容器。
    func prepareLayout() {}

    /// 完整排一次：先容器，再子视图。`cellForRow` 配完后也应走这里，不要只调 `relayoutSubviews`。
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

    func reloadItemData() {
        let table = flow ?? (superview as? UITableView)
        guard let table, let indexPath = table.indexPath(for: self) else { return }
        table.reloadRows(at: [indexPath], with: .none)
    }

    func reloadData() {
        reloadItemData()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        willDisplayBlock = nil
        selectBlock = nil
        prefetchImageURLs = []
        indexPath = nil
        edgeInsets = .zero
        accessoryView = nil
        super.accessoryType = .none
    }
}

/// 带 ViewModel 绑定的 `HFlowBaseCell`。
///
/// UIKit 复用时无法在 `init` 里注入 VM，需在 `flowRow` 里调用 `bindViewModel(_:)`。
/// 只重置 cell 自己的订阅，不要在这里 `viewModel.destroy()`。
class HFlowBindableCell<VM: HBaseViewModel>: HFlowBaseCell {

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
