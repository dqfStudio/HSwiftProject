//
//  HTupleBaseCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HTupleCellSizeBlock = () -> CGSize
typealias HTupleCellEdgeInsetsBlock = () -> UIEdgeInsets
typealias HTupleCellBlock = () -> Void
typealias HTupleCellDidSelectBlock = () -> Void

class HTupleBaseCell : UICollectionViewCell {
    
    /// Tuple view where the cell is located
    weak var tuple: UICollectionView?

    /// IndexPath where the cell is located
    var indexPath: IndexPath?

    /// Callback for getting size.
    var sizeBlock: HTupleCellSizeBlock?
    
    /// Callback for obtaining edgeInsets
    var edgeInsetsBlock: HTupleCellEdgeInsetsBlock?
    
    /// Callback for getting a cell
    var cellBlock: HTupleCellBlock?
    
    /// Callback when a cell is clicked
    var didSelectCell: HTupleCellDidSelectBlock?

    /// Signal callback
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
    lazy var layoutView: UIView = {
        let view = UIView()
        view.frame = self.frame
        self.addSubview(view)
        return view
    }()


    /// The separator view loaded on the content view
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor(hex: "#E9E9E9")
        return view
    }()
    
    /// Whether the cell should display a separator line
    var isShowSeparator: Bool = false {
        didSet {
            separatorView.isHidden = !isShowSeparator
            if isShowSeparator {
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
    
    /// Refresh the current cell
    func reloadData() {
        guard let indexPath = self.indexPath else { return }
        self.tuple?.reloadItems(at: [indexPath])
    }

    /// The frame and bounds of layoutView
    var layoutViewFrame: CGRect {
        return self.layoutView.frame
    }

    var layoutViewBounds: CGRect {
        return self.layoutView.bounds
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
    
    func HLayoutTupleCell(_ v: UIView) {
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
