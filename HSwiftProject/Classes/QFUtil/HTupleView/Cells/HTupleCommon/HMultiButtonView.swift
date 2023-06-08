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
            _button = HWebButtonView()
        }
        return _button!
    }
    
    private var _detailButton: HWebButtonView?
    var detailButton: HWebButtonView {
        if _detailButton == nil {
            _detailButton = HWebButtonView()
        }
        return _detailButton!
    }
    
    private var _accessoryButton: HWebButtonView?
    var accessoryButton: HWebButtonView {
        if _accessoryButton == nil {
            _accessoryButton = HWebButtonView()
        }
        return _accessoryButton!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
         
        if let button = _button {
            self.addArrangedSubview(button)
        }
        
        if let detailButton = _detailButton {
            self.addArrangedSubview(detailButton)
        }
        
        if let accessoryButton = _accessoryButton {
            self.addArrangedSubview(accessoryButton)
        }
        
    }
    
}
