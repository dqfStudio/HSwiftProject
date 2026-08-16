//
//  HFlowBaseApex.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/3.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HFlowBaseApex: UITableViewHeaderFooterView {
    
    ///cell所在的table view
    weak var flow: UITableView?
    
    ///cell是否为section header
    var isHeader: Bool = false
    
    ///cell所在的section
    var section: Any?
    
    ///信号block
    var signalBlock: HFlowCellSignalBlock?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
        self.initUI()
        
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
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
    
    /// The frame and bounds of the layout view
    var layoutViewFrame: CGRect {
        contentView.bounds.inset(by: edgeInsets)
    }

    var layoutViewBounds: CGRect {
        let inset = contentView.bounds.inset(by: edgeInsets)
        return CGRect(origin: .zero, size: inset.size)
    }

    func HLayoutTableApex(_ v: UIView) {
        let frame: CGRect = self.layoutViewBounds
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

    /// 移除视图上已有的宽高约束（避免 relayoutSubviews 重复创建约束导致泄漏）
    func deactivateSizeConstraints(for view: UIView) {
        view.constraints.filter {
            $0.firstAttribute == .width || $0.firstAttribute == .height
        }.forEach { $0.isActive = false }
    }
}
