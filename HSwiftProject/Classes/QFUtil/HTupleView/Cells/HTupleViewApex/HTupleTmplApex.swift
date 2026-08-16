//
//  HTupleTmplApex.swift
//  HSwiftProject
//
//  Created by owner on 2024/9/27.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HTupleTmplApex: HTupleBaseApex {

    /// The layout view loaded on the content view
    lazy var layoutView: UIStackView = {
        let stackView = UIStackView(frame: self.bounds)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        self.addSubview(stackView)
        return stackView
    }()

    /// The separator view loaded on the content view
    lazy var separatorView: HCollSeparator = {
        let separator = HCollSeparator(frame: self.bounds)
        self.addSubview(separator)
        return separator
    }()

    /// 扣除边距后的排版区域。不读 `layoutView.frame`，避免 layout 之前拿到旧尺寸。
    override var layoutViewFrame: CGRect {
        bounds.inset(by: edgeInsets)
    }

    override var layoutViewBounds: CGRect {
        let inset = bounds.inset(by: edgeInsets)
        return CGRect(origin: .zero, size: inset.size)
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
            let centerX = self.bounds.width / 2
            let centerY = self.bounds.height / 2
            _activity!.center = CGPoint(x: centerX, y: centerY)
            self.addSubview(_activity!)
            return _activity!
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutView.frame = bounds.inset(by: edgeInsets)
    }

    override func HLayoutTupleApex(_ v: UIView) {
        let frame = self.layoutViewBounds
        if !v.frame.equalTo(frame) {
            v.frame = frame
        }
        if let activity = _activity {
            let centerX = self.bounds.width / 2
            let centerY = self.bounds.height / 2
            activity.center = CGPoint(x: centerX, y: centerY)
        }
    }
}
