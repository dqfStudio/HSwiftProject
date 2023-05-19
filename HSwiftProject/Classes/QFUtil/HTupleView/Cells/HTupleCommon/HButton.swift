//
//  HButton.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/14.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

enum HButtonDirection: Int {
    case horizontal = 0 // Horizontal design
    case vertical = 1 // Vertical design
}

class HButton: UIControl {
    
    var direction: HButtonDirection = .horizontal {
        didSet {
            if direction != oldValue {
                setup()
            }
        }
    }
    
    var spacing: CGFloat = 5.0 {
        didSet {
            stackView.spacing = spacing
        }
    }
    
    private var _imageView: UIImageView?
    var imageView: UIImageView {
        get {
            if _imageView == nil {
                _imageView = UIImageView()
                setup()
            }
            return _imageView!
        }
        set {
            _imageView = newValue
        }
    }
    
    private var _titleLabel: HLabel?
    var titleLabel: HLabel {
        get {
            if _titleLabel == nil {
                _titleLabel = HLabel()
                setup()
            }
            return _titleLabel!
        }
        set {
            _titleLabel = newValue
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: self.bounds)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        self.addSubview(stackView)
        return stackView
    }()
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override var frame: CGRect {
        didSet {
            guard frame != oldValue else { return }
            var _frame = frame
            _frame.origin = .zero
            stackView.frame = _frame
        }
    }
    
    private func setup() {
        
        if direction == .horizontal {
            
            if let imageView = _imageView {
                imageView.contentMode = (_titleLabel != nil) ? .right : .center
                let width = imageView.image?.size.width ?? 0
                imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
                stackView.addArrangedSubview(imageView)
            }
            
            if let titleLabel = _titleLabel {
                titleLabel.numberOfLines = 0
                titleLabel.textAlignment = (_imageView != nil) ? .left : .center
                titleLabel.verticalAlignment = .middle
                stackView.addArrangedSubview(titleLabel)
            }
            
            stackView.axis = .horizontal
            
        } else {

            if let imageView = _imageView {
                imageView.contentMode = (_titleLabel != nil) ? .bottom : .center
                stackView.addArrangedSubview(imageView)
            }
            
            if let titleLabel = _titleLabel {
                titleLabel.numberOfLines = 0
                titleLabel.textAlignment = .center
                titleLabel.verticalAlignment = (_imageView != nil) ? .top : .middle
                titleLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
                stackView.addArrangedSubview(titleLabel)
            }
            
            stackView.axis = .vertical
            
        }
        
    }
    
}
