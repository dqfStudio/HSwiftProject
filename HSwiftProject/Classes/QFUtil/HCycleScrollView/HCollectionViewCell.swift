//
//  HCollectionViewCell.swift
//  HSwiftProject
//
//  Created by Wind on 2020/2/21.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

class HCollectionViewCell: UICollectionViewCell {
    
    var titleLabel: UILabel!

    var imageView: HWebImageView!
    
    var title: String? {
        didSet {
            if title != oldValue {
                titleLabel.text = String(format: "   %@", title!)
                if titleLabel.isHidden {
                    titleLabel.isHidden = false
                }
            }
        }
    }

    var titleLabelTextColor: UIColor? {
        didSet {
            titleLabel.textColor = titleLabelTextColor
        }
    }
    
    var titleLabelTextFont: UIFont? {
        didSet {
            titleLabel.font = titleLabelTextFont
        }
    }
    
    var titleLabelBackgroundColor: UIColor? {
        didSet {
            titleLabel.backgroundColor = titleLabelBackgroundColor
        }
    }
    
    var titleLabelHeight: CGFloat = 0.0
    
    var titleLabelTextAlignment: NSTextAlignment = .center {
        didSet {
            titleLabel.textAlignment = titleLabelTextAlignment
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
            let titleLabelW = self.width
            let titleLabelH = titleLabelHeight
            let titleLabelX = 0.0
            let titleLabelY = self.height - titleLabelH
            titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
        }
    }

}
