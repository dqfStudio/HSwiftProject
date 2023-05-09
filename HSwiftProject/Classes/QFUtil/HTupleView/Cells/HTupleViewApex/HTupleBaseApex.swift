//
//  HTupleBaseApex.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HTupleApexSizeBlock = () -> CGSize
typealias HTupleApexEdgeInsetsBlock = () -> UIEdgeInsets
typealias HTupleApexBlock = () -> Void

class HTupleBaseApex : UICollectionReusableView {
    
    /// Tuple view where the cell is located
    weak var tuple: UICollectionView?
    /// Whether the cell is a section header
    var isHeader: Bool = false
    /// The indexPath where the cell is located
    var indexPath: IndexPath?
    
    /// Callback for getting size.
    var sizeBlock: HTupleApexSizeBlock?
    
    /// Callback for obtaining edgeInsets
    var edgeInsetsBlock: HTupleApexEdgeInsetsBlock?
    
    /// Callback for getting a apex
    var cellBlock: HTupleApexBlock?

    /// Signal block
    var signalBlock: HTupleCellSignalBlock?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor.clear
        self.initUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.initUI()
    }
    
    /// The edge insets of the cell.
    @objc var edgeInsets: UIEdgeInsets = .zero {
         didSet {
              layoutView.frame = layoutViewFrame
         }
    }

    /// The layout view loaded on the content view.
    lazy var layoutView: UIView = {
        let view = UIView()
        view.frame = layoutViewFrame
        self.addSubview(view)
        return view
    }()


    /// The separator view loaded on the content view.
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor(hex: "#E9E9E9")
        return view
    }()
    
    /// Whether the cell should display a separator line
    var isShouldShowSeparator: Bool = false {
        didSet {
            separatorView.isHidden = !isShouldShowSeparator
            if isShouldShowSeparator {
                if separatorView.superview == nil {
                    addSubview(separatorView)
                }
                separatorView.frame = separatorFrame
                bringSubviewToFront(separatorView)
            }
        }
    }

    /// The margin of the cell separator line
    var separatorInset: UILREdgeInsets = UILREdgeInsets.zero {
        didSet {
            guard separatorInset != oldValue else { return }
            separatorView.frame = self.separatorFrame
        }
    }

    /// The color of the cell separator line
    var separatorColor: UIColor? {
        didSet {
            self.separatorView.backgroundColor = separatorColor
        }
    }
    
    private var separatorFrame: CGRect {
        let width = bounds.width - separatorInset.left - separatorInset.right
        let origin = CGPoint(x: separatorInset.left, y: bounds.height - 1)
        return CGRect(origin: origin, size: CGSize(width: width, height: 1))
    }

    /// The frame and bounds of the layout view
    var layoutViewFrame: CGRect {
        return self.bounds.inset(by: edgeInsets)
    }

    var layoutViewBounds: CGRect {
        var frame = self.layoutViewFrame
        frame.origin = CGPoint.zero
        return frame
    }

    private var _activity: UIActivityIndicatorView?
    var activity: UIActivityIndicatorView {
        if let activity = _activity {
            return activity
        } else {
            if #available(iOS 13.0, *) {
                _activity = UIActivityIndicatorView(style: .medium)
            } else {
                _activity = UIActivityIndicatorView(style: .gray)
            }
            _activity!.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
            self.addSubview(_activity!)
            return _activity!
        }
    }

    func HLayoutTupleApex(_ v: UIView) {
        let frame = self.layoutViewBounds
        if !v.frame.equalTo(frame) {
            v.frame = frame
        }
        _activity?.center = CGPoint(x: self.width / 2, y: self.height / 2)
    }

    /// Method called during cell initialization
    func initUI() { }
    
    /// Used by subclasses to update subview layout
    @objc
    func relayoutSubviews() { }

}
