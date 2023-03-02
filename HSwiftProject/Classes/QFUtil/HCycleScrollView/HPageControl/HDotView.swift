//
//  HDotView.swift
//  HSwiftProject
//
//  Created by wind on 2020/2/20.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

class HDotView: HAbstractDotView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialization()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialization()
    }
    private func initialization() {
        self.backgroundColor   = UIColor.clear
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
    }
    @objc
    override func changeActivityState(_ active: Bool) {
        if active {
            self.backgroundColor = UIColor.white
        } else {
            self.backgroundColor = UIColor.clear
        }
    }
}
