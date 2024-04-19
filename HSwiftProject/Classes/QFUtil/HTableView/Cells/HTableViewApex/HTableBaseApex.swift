//
//  HTableBaseApex.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/3.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HTableBaseApex: UITableViewHeaderFooterView {
    
    ///cell所在的table view
    weak var table: UITableView?
    
    ///cell是否为section header
    var isHeader: Bool = false
    
    ///cell所在的section
    var section: Any?
    
    ///信号block
    var signalBlock: HTableCellSignalBlock?
    
    
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
    
    /// The edge insets of the cell.
    @objc override var edgeInsets: UIEdgeInsets {
        get {
            let edgeInsetsString = self.getAssociatedValueForKey(&kViewEdgeInsetsKey) as? String ?? NSCoder.string(for: UIEdgeInsets.zero)
            return NSCoder.uiEdgeInsets(for: edgeInsetsString)
        }
        set {
            if edgeInsets != newValue {
                layoutView.frame = self.bounds.inset(by: newValue)
                self.setAssociateValue(NSCoder.string(for: newValue), key: &kViewEdgeInsetsKey)
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
    lazy var separatorView: HCellApexSeparator = {
        let separator = HCellApexSeparator(frame: self.bounds)
        self.contentView.addSubview(separator)
        return separator
    }()
    
    /// The frame and bounds of the layout view
    var layoutViewFrame: CGRect {
        return layoutView.frame
    }

    var layoutViewBounds: CGRect {
        return layoutView.bounds
    }

    func HLayoutTableApex(_ v: UIView) {
        let frame: CGRect = self.layoutViewBounds
        if !v.frame.equalTo(frame) {
            v.frame = frame
        }
    }
    
    ///cell初始化是调用的方法
    func initUI() { }
    
    ///用于子类更新子视图布局
    @objc
    func relayoutSubviews() { }

}
