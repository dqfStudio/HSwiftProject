//
//  HFlowReuseIdentifier.swift
//  HSwiftProject
//
//  Created by owner on 2024/1/24.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

typealias HFlowReuseCellBlock = (_ flow: HFlowView, _ cell: HFlowBaseCell) -> Void

class HFlowAttributes: NSObject {
    var cellBlock: HFlowReuseCellBlock?
    var edgeInsets: UIEdgeInsets = .zero
    var identifier: String = ""
    var size: CGSize = .zero

    // Use default initializer in combination with default values
    init(_ identifier: String = "") {
        self.identifier = identifier
    }
}
