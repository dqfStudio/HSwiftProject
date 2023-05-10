//
//  HTableBaseCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/3.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HTableCellBlock = (_ idxPath: IndexPath) -> Void
typealias HTableCellSelectBlock = (_ target: HTableBaseCell, _ indexPath: IndexPath) -> Void

class HTableBaseCell : UITableViewCell {
    
    ///cell所在的table view
    weak var table: UITableView?
    
    ///cell所在的indexPath
    var indexPath: IndexPath?
    
    ///cell点击block，用户用户点击事件
    var cellBlock: HTableCellBlock?
    
    ///选中item的block
    var selectBlock: HTableCellSelectBlock?
    
    ///信号block
    var signalBlock: HTableCellSignalBlock?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor.clear
        self.initUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        self.style = style
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
        let stackView = UIStackView(frame: self.frame)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        self.contentView.addSubview(stackView)
        return stackView
    }()

    /// The separator view loaded on the content view
    lazy var separatorView: HCellApexSeparator = {
        let separator = HCellApexSeparator(frame: self.frame)
        self.contentView.addSubview(separator)
        return separator
    }()
    
    ///刷新当前cell
    func reloadData() {
        guard let indexPath = self.indexPath else { return }
        self.table?.reloadRows(at: [indexPath], with: .fade)
    }
    
    /// The frame and bounds of the layout view
    var layoutViewFrame: CGRect {
        return layoutView.frame
    }

    var layoutViewBounds: CGRect {
        return layoutView.bounds
    }
    
    func HLayoutTableCell(_ v: UIView) {
        let frame = self.layoutViewBounds
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
