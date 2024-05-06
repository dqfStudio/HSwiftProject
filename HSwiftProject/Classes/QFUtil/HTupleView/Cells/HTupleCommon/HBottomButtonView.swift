//
//  HBottomButtonView.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/6.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HBottomButtonView: UIStackView {
    
    var layoutInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    lazy var button: HWebButtonView = {
        let button = HWebButtonView(frame: .zero)
        button.backgroundColor = UIColor.red
        button.cornerRadius = 24.0
        self.addArrangedSubview(button)
        return button
    }()
    
    required init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        self.layoutMargins = self.layoutInsets
        self.button.layoutMargins = self.layoutInsets
        self.isLayoutMarginsRelativeArrangement = true
    }
    
}
