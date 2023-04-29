//
//  HTableBaseApex.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/3.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HTableApexBlock = (_ idxPath: IndexPath) -> Void

class HTableBaseApex : UITableViewHeaderFooterView {
    
    ///cell所在的table view
    weak var table: UITableView?
    ///cell是否为section header
    var isHeader: Bool = false
    ///cell所在的section
    var section: Int?
    
    ///cell点击block，用户用户点击事件
    var cellBlock: HTableApexBlock?
    ///信号block
    var signalBlock: HTableCellSignalBlock?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor.clear
        self.initUI()
        
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.initUI()
    }
    
    private var _edgeInsets: UIEdgeInsets = .zero
    ///cell的边距
    @objc var edgeInsets: UIEdgeInsets {
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
    
    private var _shouldShowSeparator: Bool = false
    ///cell是否显示间隔线
    var shouldShowSeparator: Bool {
        get {
            return _shouldShowSeparator
        }
        set {
            if _shouldShowSeparator != newValue {
               _shouldShowSeparator = newValue
                if _shouldShowSeparator {
                    if self.separatorView.superview == nil {
                        self.addSubview(self.separatorView)
                    }
                    self.bringSubviewToFront(self.separatorView)
                }
                self.separatorView.isHidden = !_shouldShowSeparator
            }
            //重设frame
            if _shouldShowSeparator {
                let separatorFrame = self.separatorFrame
                if self.separatorView.frame != separatorFrame {
                   self.separatorView.frame = separatorFrame
                }
            }
        }
    }

    //cell间隔线的边距
    var separatorInset: UILREdgeInsets = UILREdgeInsetsZero {
        didSet {
            guard separatorInset != oldValue else { return }
            separatorView.frame = self.separatorFrame
        }
    }
    
    ///cell间隔线的颜色
    var separatorColor: UIColor? {
        didSet {
            self.separatorView.backgroundColor = separatorColor
        }
    }
    
    private var separatorFrame: CGRect {
        let separatorInset = self.separatorInset
        let frame = CGRect(x: separatorInset.left, y: self.bounds.height - 1, width: self.bounds.width - separatorInset.left - separatorInset.right, height: 1)
        return frame
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
