//
//  HTupleTmplCell.swift
//  HSwiftProject
//
//  Created by owner on 2024/9/27.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HTupleTmplCell: HTupleBaseCell {
    
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
        stackView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.addSubview(stackView)
        return stackView
    }()
    
    /// The separator view loaded on the content view
    lazy var separatorView: HCellApexSeparator = {
        let separator = HCellApexSeparator(frame: self.bounds)
        self.contentView.addSubview(separator)
        return separator
    }()

    /// The frame and bounds of layoutView
    var layoutViewFrame: CGRect {
        return layoutView.frame
    }

    var layoutViewBounds: CGRect {
        return layoutView.bounds
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
            let centerX = self.contentView.bounds.width / 2
            let centerY = self.contentView.bounds.height / 2
            _activity!.center = CGPoint(x: centerX, y: centerY)
            self.contentView.addSubview(_activity!)
            return _activity!
        }
    }
    
    func HLayoutTupleCell(_ v: UIView) {
        let frame = self.layoutViewBounds
        if !v.frame.equalTo(frame) {
            v.frame = frame
        }
        if let activity = _activity {
            let centerX = self.contentView.bounds.width / 2
            let centerY = self.contentView.bounds.height / 2
            activity.center = CGPoint(x: centerX, y: centerY)
        }
    }
    
}
