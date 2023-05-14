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
            if direction == .horizontal {
                stackView.axis = .horizontal
            } else {
                stackView.axis = .vertical
            }
        }
    }
    
    var imageView: UIImageView?
    
    var titleLabel: UILabel?
    
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
        
    }
    
    override var frame: CGRect {
        didSet {
            guard frame != oldValue else { return }
            var _frame = frame
            _frame.origin = .zero
            stackView.frame = _frame
        }
    }
    
    func setLayoutFirstSpacing(_ spacing: CGFloat) {
//        if let imageView = _imageView {
//            stackView.setCustomSpacing(spacing, after: imageView)
//        }
    }
    
    private func setup() {
        
//        UINavigationBar
        
//        UIBarButtonItem
//        UIBarItem
//        UITabBar
//        UITabBarItem
        
        if let imageView = imageView {
//            imageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
            stackView.addArrangedSubview(imageView)
        }
        
//        titleLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
//        stackView.addArrangedSubview(titleLabel)

        // accessoryView
//        if isShowAccessoryArrow {
//            accessoryView.widthAnchor.constraint(equalToConstant: 7).isActive = true
//            accessoryView.heightAnchor.constraint(equalToConstant: 13).isActive = true
//            arrowLayoutView.addArrangedSubview(accessoryView)
//        }
    }
    
}
