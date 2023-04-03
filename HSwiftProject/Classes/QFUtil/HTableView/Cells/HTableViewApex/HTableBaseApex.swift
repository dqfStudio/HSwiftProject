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
    
    private var _edgeInsets: UIEdgeInsets = UIEdgeInsetsZero
    ///cell的边距
    @objc var edgeInsets: UIEdgeInsets {
        get {
            return _edgeInsets
        }
        set {
            _edgeInsets = newValue
            //更新layoutView的frame
            let frame: CGRect = self.layoutViewFrame
            if self.layoutView.frame != frame {
                self.layoutView.frame = frame
            }
        }
    }

    private var _layoutView: UIView?
    ///用于加载在contentView上的布局视图
    var layoutView: UIView {
        if _layoutView == nil {
            _layoutView = UIView()
            self.addSubview(_layoutView!)
        }
        return _layoutView!
    }

    private var _separatorView: UIView?
    ///用于加载在contentView上的布局视图
    private var separatorView: UIView {
        if _separatorView == nil {
            _separatorView = UIView()
            _separatorView!.isHidden = true
            let color = UIColor(red: 233 / 255.0, green: 233 / 255.0, blue: 233 / 255.0, alpha: 1.0)
            _separatorView!.backgroundColor = color
        }
        return _separatorView!
    }
    
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
                let frame: CGRect = self.getSeparatorFrame
                if self.separatorView.frame != frame {
                   self.separatorView.frame = frame
                }
            }
        }
    }

    private var _separatorInset: UILREdgeInsets = UILREdgeInsetsZero
    ///cell间隔线的边距
    var separatorInset: UILREdgeInsets {
        get {
            return _separatorInset
        }
        set {
            if _separatorInset != newValue {
                _separatorInset = newValue
                self.separatorView.frame = self.getSeparatorFrame
            }
        }
    }
    
    private var _separatorColor: UIColor?
    ///cell间隔线的颜色
    var separatorColor: UIColor? {
        get {
            return _separatorColor
        }
        set {
            if _separatorColor != newValue {
                _separatorColor = nil
                _separatorColor = newValue
                self.separatorView.backgroundColor = _separatorColor
            }
        }
    }
    
    private var getSeparatorFrame: CGRect {
        var frame: CGRect = CGRect(x: 0, y: self.height - 1, width: self.width, height: 1)
        frame.x += self.separatorInset.left
        frame.width -= self.separatorInset.left + self.separatorInset.right
        return frame
    }

    ///layoutView的frame和bounds
    var layoutViewFrame: CGRect {
        var frame: CGRect = self.bounds
        frame.x += _edgeInsets.left
        frame.y += _edgeInsets.top
        frame.width -= _edgeInsets.left + _edgeInsets.right
        frame.height -= _edgeInsets.top + _edgeInsets.bottom
        return frame
    }

    var layoutViewBounds: CGRect {
        var frame: CGRect = self.layoutViewFrame
        frame.x = 0
        frame.y = 0
        return frame
    }

    func HLayoutTableApex(_ v: UIView) {
        let frame: CGRect = self.layoutViewBounds
        if v.frame != frame {
            v.frame = frame
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    ///cell初始化是调用的方法
    func initUI() { }
    ///用于子类更新子视图布局
    @objc
    func relayoutSubviews() { }

}
