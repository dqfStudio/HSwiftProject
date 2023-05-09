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
    @objc var edgeInsets: UIEdgeInsets = .zero {
         didSet {
              guard layoutView.frame != layoutViewFrame else { return }
              layoutView.frame = layoutViewFrame
         }
    }

    /// The layout view loaded on the content view
    lazy var layoutView: UIView = {
        let view = UIView()
        view.frame = layoutViewFrame
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
        let frame = CGRect(x: separatorInset.left, y: self.bounds.height - 1, width: self.bounds.width - separatorInset.left - separatorInset.right, height: 1)
        return frame
    }
    
    /// Refresh the current cell
    func reloadData() {
        guard let indexPath = self.indexPath else { return }
        self.tuple?.reloadItems(at: [indexPath])
    }

    /// The frame and bounds of layoutView
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
