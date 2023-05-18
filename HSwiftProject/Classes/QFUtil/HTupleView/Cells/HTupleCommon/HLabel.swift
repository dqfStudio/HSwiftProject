//
//  HLabel.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/18.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

enum HVerticalAlignment {
    case top
    case middle
    case bottom
}

class HLabel: UILabel {
    var verticalAlignment: HVerticalAlignment = .middle {
        didSet {
            setNeedsDisplay()
        }
    }

    override func drawText(in rect: CGRect) {
        guard let text = text else {
            super.drawText(in: rect)
            return
        }

        let size = text.size(withAttributes: [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 14)])
        var newRect = rect

        switch verticalAlignment {
        case .top:
            newRect.size.height = size.height
        case .middle:
            newRect.origin.y += (newRect.size.height - size.height) / 2
            newRect.size.height = size.height
        case .bottom:
            newRect.origin.y += newRect.size.height - size.height
            newRect.size.height = size.height
        }

        super.drawText(in: newRect)
    }
}


