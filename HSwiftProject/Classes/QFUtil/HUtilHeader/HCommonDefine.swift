//
//  HCommonDefine.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/16.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import Foundation

#if DEBUG

public func NSLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
    let fileName: String
    if file.contains(".") {
        fileName = file.components(separatedBy: "/").last ?? ""
    }else {
        fileName = file
    }
    print("\(fileName)->\(method)->\(line)->\(message)")
}

#endif
