//
//  HTableBaseCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/3.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HTableCellBlock = (_ idxPath: IndexPath) -> Void
typealias HTableDidSelectCell = (_ target: HTableBaseCell, _ indexPath: IndexPath) -> Void

class HTableBaseCell : UITableViewCell {
    
    ///cell所在的table view
    weak var table: UITableView?
    
    ///选中item的block
    var didSelectCell: HTableDidSelectCell?
    
    ///cell所在的indexPath
    var indexPath: IndexPath?
    
    ///cell点击block，用户用户点击事件
    var cellBlock: HTableCellBlock?
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
    
    private var _edgeInsets: UIEdgeInsets = .zero
    ///cell的边距
    @objc override var edgeInsets: UIEdgeInsets {
        get { _edgeInsets }
        set {
            guard _edgeInsets != newValue else { return }
            _edgeInsets = newValue
            //更新layoutView的frame
            if layoutView.frame != layoutViewFrame {
                layoutView.frame = layoutViewFrame
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
    
    ///用于加载在contentView上的布局视图
    lazy var layoutView: UIView = {
        let view = UIView()
        self.addSubview(view)
        return view
    }()


    ///用于加载在contentView上的布局视图
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor(hex: "#E9E9E9")
        return view
    }()
    
    private var _isShowSeparator: Bool = false
    ///cell是否显示间隔线
    var isShowSeparator: Bool {
        get {
            return _isShowSeparator
        }
        set {
            if _isShowSeparator != newValue {
               _isShowSeparator = newValue
                if _isShowSeparator {
                    if self.separatorView.superview == nil {
                        self.addSubview(self.separatorView)
                    }
                    self.bringSubviewToFront(self.separatorView)
                }
                self.separatorView.isHidden = !_isShowSeparator
            }
            //重设frame
            if _isShowSeparator {
                let separatorFrame = self.separatorFrame
                if self.separatorView.frame != separatorFrame {
                   self.separatorView.frame = separatorFrame
                }
            }
        }
    }

    ///cell间隔线的边距
    override var separatorInset: UIEdgeInsets {
        didSet {
            guard separatorInset != oldValue else { return }
            separatorView.frame = self.separatorFrame
        }
    }
    
    ///cell间隔线的颜色
    private var separatorColor: UIColor? {
        didSet {
            guard let color = separatorColor, !color.isKind(of: NSClassFromString("UIDynamicSystemColor")!) else {
                return
            }
            separatorView.backgroundColor = color
        }
    }
    
    private var separatorFrame: CGRect {
        let separatorInset = self.separatorInset
        let frame = CGRect(x: separatorInset.left, y: self.bounds.height - 1, width: self.bounds.width - separatorInset.left - separatorInset.right, height: 1)
        return frame
    }
    
    ///刷新当前cell
    func reloadData() {
        guard let indexPath = self.indexPath else { return }
        self.table?.reloadRows(at: [indexPath], with: .fade)
    }

    ///layoutView的frame和bounds
    var layoutViewFrame: CGRect {
        return self.bounds.inset(by: edgeInsets)
    }

    var layoutViewBounds: CGRect {
        var frame = self.layoutViewFrame
        frame.origin = CGPoint.zero
        return frame
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
