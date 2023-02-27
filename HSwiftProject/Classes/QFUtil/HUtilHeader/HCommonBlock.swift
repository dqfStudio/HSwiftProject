//
//  HCommonBlock.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/18.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation

// universal block define

typealias Min_callback = () -> Void

typealias Callback = (_ sender: Any?, _ data: Any?) -> Void

typealias Callback2 = (_ sender: Any?, _ data: Any?, _ data2: Any?) -> Void

typealias Simple_callback = (_ sender: Any?) -> Void

typealias Fail_callback = (_ sender: Any?, _ error: Error) -> Void

typealias Returnback = (_ sender: Any?, _ data: Any?) -> Any?

typealias Finish_callback = (_ sender: Any?, _ data: Any?, _ error: Error) -> Void
