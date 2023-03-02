//
//  HCollectionViewCell.swift
//  HSwiftProject
//
//  Created by wind on 2020/2/21.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

class HCollectionViewCell: UICollectionViewCell {
    
    var titleLabel: UILabel!

    var imageView: HWebImageView!
    
    private var _title: String?
    var title: String? {
        get {
            return _title
        }
        set {
            _title = newValue
            if newValue != nil {
                titleLabel.text = String(format: "   %@", newValue!)
                if titleLabel.isHidden {
                    titleLabel.isHidden = false
                }
            }
        }
    }

    private var _titleLabelTextColor: UIColor?
    var titleLabelTextColor: UIColor? {
        get {
            return _titleLabelTextColor
        }
        set {
            _titleLabelTextColor = newValue
            titleLabel.textColor = newValue
        }
    }
    
    private var _titleLabelTextFont: UIFont?
    var titleLabelTextFont: UIFont? {
        get {
            return _titleLabelTextFont
        }
        set {
            _titleLabelTextFont = newValue
            titleLabel.font = newValue
        }
    }
    
    private var _titleLabelBackgroundColor: UIColor?
    var titleLabelBackgroundColor: UIColor? {
        get {
            return _titleLabelBackgroundColor
        }
        set {
            _titleLabelBackgroundColor = newValue
            titleLabel.backgroundColor = newValue
        }
    }
    
    var titleLabelHeight: CGFloat = 0.0
    
    private var _titleLabelTextAlignment: NSTextAlignment = .center
    var titleLabelTextAlignment: NSTextAlignment {
        get {
            return _titleLabelTextAlignment
        }
        set {
            _titleLabelTextAlignment = newValue
            titleLabel.textAlignment = newValue
        }
    }

    var hasConfigured: Bool = false

    /** 只展示文字轮播 */
    var onlyDisplayText: Bool = false


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupImageView()
        self.setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupImageView()
        self.setupTitleLabel()
    }

    func setupImageView() {
        imageView = HWebImageView()
        self.contentView.addSubview(imageView)
    }

    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.isHidden = true
        self.contentView.addSubview(titleLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if (self.onlyDisplayText) {
            titleLabel.frame = self.bounds
        }else {
            imageView.frame = self.bounds
            let titleLabelW = self.hc_width
            let titleLabelH = titleLabelHeight
            let titleLabelX: CGFloat = 0.0
            let titleLabelY = self.hc_height - titleLabelH
            titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
        }
    }

}
