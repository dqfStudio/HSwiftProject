//
//  HTupleSeparator.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/9.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HCellApexSeparator: UIView {
    
    var isShow: Bool = false {
        didSet {
            isHidden = !isShow
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex: "#E9E9E9")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
