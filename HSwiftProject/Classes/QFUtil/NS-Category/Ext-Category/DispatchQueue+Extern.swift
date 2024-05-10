//
//  DispatchQueue+Extern.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/10.
//  Copyright © 2024 wind. All rights reserved.
//

import Foundation
import Dispatch

extension DispatchQueue {
    static func mainAsync(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
