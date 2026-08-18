//
//  HReactiveViewProtocol.swift
//  HSwiftProject
//
//  Created by windy on 2025/11/13.
//  Copyright © 2025 wind. All rights reserved.
//

import Foundation

@objc protocol HReactiveViewProtocol: NSObjectProtocol {
    /// 添加控件 最好最后加上[self.view setNeedsUpdateConstraints]和[self.view updateConstraintsIfNeeded]，以防不调用updateViewConstraints
    func dm_setupViews()
    /// 绑定VM
    func dm_bindViewModel(_ viewModel: Any?)
}
