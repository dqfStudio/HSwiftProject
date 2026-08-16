//
//  HFlowBaseCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/3.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HTableCellSelectBlock = () -> Void

class HFlowBaseCell: UITableViewCell {
    
    ///cell所在的flow view
    weak var flow: UITableView?
    
    ///cell所在的indexPath
    var indexPath: IndexPath?
    
    /// Callback when a cell is clicked
    var willDisplayBlock: HTableCellSelectBlock?
    
    ///选中item的block
    var selectBlock: HTableCellSelectBlock?
    
    ///信号block
    var signalBlock: HFlowCellSignalBlock?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
        self.initUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.style = style
        // 关闭离屏渲染开关
        self.layer.shouldRasterize = false
        self.layer.drawsAsynchronously = true
        // 关闭不透明合成优化
        self.contentView.layer.shouldRasterize = false
        self.contentView.layer.drawsAsynchronously = true
        self.initUI()
    }
    
    /// 内容边距。会同步缩小 `layoutView` 的 frame。
    @objc var edgeInsets: UIEdgeInsets = .zero {
        didSet {
            if edgeInsets != oldValue {
                setNeedsLayout()
            }
        }
    }
    
    ///cell的style
    var style: UITableViewCell.CellStyle = .default
    
    ///cell accessory type
    override var accessoryType: UITableViewCell.AccessoryType {
        get {
            return super.accessoryType
        }
        set {
            if #available(iOS 13.0, *) {
                switch newValue {
                case .none:
                    self.accessoryView = nil
                case .disclosureIndicator:
                    let arrowView = UIImageView(frame: CGRect(x: 0, y: 0, width: 7, height: 13))
                    arrowView.image = UIImage(named: "icon_tuple_arrow_right")
                    self.accessoryView = arrowView
                default: break
                }
            }else {
                super.accessoryType = newValue
            }
        }
    }
    
    /// The layout view loaded on the content view
    lazy var layoutView: UIStackView = {
        let stackView = UIStackView(frame: self.bounds)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        self.contentView.addSubview(stackView)
        return stackView
    }()

    /// The separator view loaded on the content view
    lazy var separatorView: HCollSeparator = {
        let separator = HCollSeparator(frame: self.bounds)
        self.contentView.addSubview(separator)
        return separator
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indexPath = nil
    }

    ///刷新当前cell
    func reloadData() {
        guard let indexPath = self.indexPath else { return }
        self.flow?.reloadRows(at: [indexPath], with: .fade)
    }

    /// 移除视图上已有的宽高约束（避免 relayoutSubviews 重复创建约束导致泄漏）
    func deactivateSizeConstraints(for view: UIView) {
        view.constraints.filter {
            $0.firstAttribute == .width || $0.firstAttribute == .height
        }.forEach { $0.isActive = false }
    }
    
    /// The frame and bounds of the layout view
    var layoutViewFrame: CGRect {
        contentView.bounds.inset(by: edgeInsets)
    }

    var layoutViewBounds: CGRect {
        let inset = contentView.bounds.inset(by: edgeInsets)
        return CGRect(origin: .zero, size: inset.size)
    }
    
    func HLayoutTableCell(_ v: UIView) {
        let frame = self.layoutViewBounds
        if !v.frame.equalTo(frame) {
            v.frame = frame
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutView.frame = contentView.bounds.inset(by: edgeInsets)
    }
    
    ///cell初始化是调用的方法
    func initUI() { }
    
    ///用于子类更新子视图布局
    @objc
    func relayoutSubviews() { }
    
}
