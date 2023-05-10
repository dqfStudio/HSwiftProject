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
        let stackView = UIStackView(frame: self.frame)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        self.addSubview(stackView)
        return stackView
    }()


    /// The separator view loaded on the content view
    lazy var separatorView: HCellApexSeparator = {
        let view = HCellApexSeparator(frame: self.frame)
        self.addSubview(view)
        return view
    }()

    /// The frame and bounds of the layout view
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
            _activity!.center = self.center
            self.addSubview(_activity!)
            return _activity!
        }
    }

    func HLayoutTupleApex(_ v: UIView) {
        let frame = self.layoutViewBounds
        if !v.frame.equalTo(frame) {
            v.frame = frame
        }
        _activity?.center = self.center
    }

    /// Method called during cell initialization
    func initUI() { }
    
    /// Used by subclasses to update subview layout
    @objc
    func relayoutSubviews() { }

}
