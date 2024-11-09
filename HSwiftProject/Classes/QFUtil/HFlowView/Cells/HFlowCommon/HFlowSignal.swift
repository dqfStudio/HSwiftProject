//
//  HFlowSignal.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/3.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

var kFlowSkinNotify = "flowSkinNotify"

typealias HFlowCellSignalBlock = (_ target: AnyObject, _ signal: HFlowSignal?) -> Void

class HFlowSignal: NSObject {
    var signal: AnyObject?
    var tag: Int = 0
    var name: String?
}
