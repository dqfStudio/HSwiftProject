//
//  HPostHeader.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/8.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HPostHeader: UIView {
    
    lazy var avatarButton: HWebButtonView = {
        let frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        let button = HWebButtonView(frame: frame)
        button.cornerRadius = 8
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let x = avatarButton.maxX + 12
        let w = self.width - x
        let h = 24.0
        let frame = CGRect(x: x, y: 0, width: w, height: h)
        let label = UILabel(frame: frame)
        label.textColor = UIColor(hex: "#17191E")
        label.font = UIFont.font(ofSize: 17.0, weight: .medium)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let x = avatarButton.maxX + 12
        let y = nameLabel.maxY + 4
        let w = self.width - x
        let h = 20.0
        let frame = CGRect(x: x, y: y, width: w, height: h)
        let label = UILabel(frame: frame)
        label.textColor = UIColor(hex: "#9B9FA8")
        label.font = UIFont.font(ofSize: 14.0, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(avatarButton)
        self.addSubview(nameLabel)
        self.addSubview(dateLabel)
    }
    
}

