//
//  HMultiButtonView.swift
//  HSwiftProject
//
//  Created by owner on 2023/6/8.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HMultiButtonView: UIStackView {
    
    private var viewCount: CGFloat = 0.0
    
    private var _button: HWebButtonView?
    var button: HWebButtonView {
        if _button == nil {
            _button = HWebButtonView()
            viewCount += 1
        }
        return _button!
    }
    
    private var _detailButton: HWebButtonView?
    var detailButton: HWebButtonView {
        if _detailButton == nil {
            _detailButton = HWebButtonView()
            viewCount += 1
        }
        return _detailButton!
    }
    
    private var _accessoryButton: HWebButtonView?
    var accessoryButton: HWebButtonView {
        if _accessoryButton == nil {
            _accessoryButton = HWebButtonView()
            viewCount += 1
        }
        return _accessoryButton!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        
        let width = (self.width - self.spacing) / viewCount
        
        guard width > 0 else { return }
        
        if let button = _button {
            button.widthAnchor.constraint(equalToConstant: width).isActive = true
            button.heightAnchor.constraint(equalToConstant: self.height).isActive = true
            self.addArrangedSubview(button)
        }
        
        if let detailButton = _detailButton {
            detailButton.widthAnchor.constraint(equalToConstant: width).isActive = true
            detailButton.heightAnchor.constraint(equalToConstant: self.height).isActive = true
            self.addArrangedSubview(detailButton)
        }
        
        if let accessoryButton = _accessoryButton {
            accessoryButton.widthAnchor.constraint(equalToConstant: width).isActive = true
            accessoryButton.heightAnchor.constraint(equalToConstant: self.height).isActive = true
            self.addArrangedSubview(accessoryButton)
        }
        
    }
    
}
