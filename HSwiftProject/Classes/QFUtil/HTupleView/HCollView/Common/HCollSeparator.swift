//
//  HCollSeparator.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/9.
//  Copyright © 2023 wind. All rights reserved.
//
//  cell / header / footer 底部分隔线。默认隐藏，设 isShow 后显示。
//

import UIKit

/// 列表底部分隔线。默认 1pt 高、浅灰，由 Stack Cell / Apex 在底部铺开。
class HCollSeparator: UIView {

    /// 线色。用 RGB 字面量，不依赖 `UIColor(hex:)`。
    var lineColor: UIColor = UIColor(red: 233.0 / 255.0, green: 233.0 / 255.0, blue: 233.0 / 255.0, alpha: 1) {
        didSet {
            backgroundColor = lineColor
        }
    }

    var isShow: Bool = false {
        didSet {
            isHidden = !isShow
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = lineColor
        isHidden = true
        isUserInteractionEnabled = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
