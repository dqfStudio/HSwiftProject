//
//  HTupleSeparator.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/9.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HCellApexSeparator: UIView {
    
    /// The margin of the cell separator line
    var separatorInset: UILREdgeInsets = .zero {
        didSet {
            guard separatorInset != oldValue else { return }
            self.frame = self.separatorFrame
        }
    }
    
    private var separatorFrame: CGRect {
        let width = self.width - separatorInset.left - separatorInset.right
        let origin = CGPoint(x: separatorInset.left, y: self.height - 1)
        return CGRect(origin: origin, size: CGSize(width: width, height: 1))
    }
    
    required override init(frame: CGRect) {
        let frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex: "#E9E9E9")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
