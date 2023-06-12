//
//  HMultiButtonView.swift
//  HSwiftProject
//
//  Created by owner on 2023/6/8.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HMultiButtonView: UIStackView {
    
    private var _button: HWebButtonView?
    var button: HWebButtonView {
        if _button == nil {
            _button = HWebButtonView(frame: .zero)
            self.addArrangedSubview(_button!)
        }
        return _button!
    }
    
    private var _detailButton: HWebButtonView?
    var detailButton: HWebButtonView {
        if _detailButton == nil {
            _detailButton = HWebButtonView(frame: .zero)
            self.addArrangedSubview(_detailButton!)
        }
        return _detailButton!
    }
    
    private var _accessoryButton: HWebButtonView?
    var accessoryButton: HWebButtonView {
        if _accessoryButton == nil {
            _accessoryButton = HWebButtonView(frame: .zero)
            self.addArrangedSubview(_accessoryButton!)
        }
        return _accessoryButton!
    }
    
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
        self.distribution = .fillEqually
    }
    
}
