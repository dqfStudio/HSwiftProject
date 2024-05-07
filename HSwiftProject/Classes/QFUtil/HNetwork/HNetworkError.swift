//
//  HNetworkError.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/7.
//  Copyright © 2024 wind. All rights reserved.
//

import Foundation
import Alamofire

struct HNetworkError: Error {
    
    var code: Int?
    var err: Error?
    var msg: String?
    
    /// 网络错误的信息打印
    static func requestError(with error: Error) -> HNetworkError {
        print("This error message is \(error)")
        return HNetworkError(code: -1, err: error, msg: error.localizedDescription)
    }
}
