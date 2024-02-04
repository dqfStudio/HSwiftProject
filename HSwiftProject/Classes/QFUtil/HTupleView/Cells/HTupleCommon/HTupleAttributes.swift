//
//  HTupleReuseIdentifier.swift
//  HSwiftProject
//
//  Created by owner on 2024/1/24.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

typealias HTupleReuseCellBlock = (_ tuple: HTupleView, _ cell: HTupleBaseCell) -> Void

class HTupleAttributes: NSObject {
    var cellBlock: HTupleReuseCellBlock?
    var edgeInsets: UIEdgeInsets = .zero
    var identifier: String = ""
    var size: CGSize = .zero

    // Use default initializer in combination with default values
    init(_ identifier: String = "") {
        self.identifier = identifier
    }
}
