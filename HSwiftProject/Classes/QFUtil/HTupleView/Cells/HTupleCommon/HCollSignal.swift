//
//  HCollSignal.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/20.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

var kCollSkinNotify = "collSkinNotify"

typealias HCollCellSignalBlock = (_ target: AnyObject, _ signal: HCollSignal?) -> Void

class HCollSignal: NSObject {
    var signal: AnyObject?
    var tag: Int = 0
    var name: String?
}
