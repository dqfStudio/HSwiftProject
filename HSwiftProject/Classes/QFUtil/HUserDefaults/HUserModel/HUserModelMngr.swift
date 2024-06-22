//
//  HUserModelMngr.swift
//  HSwiftProject
//
//  Created by owner on 2024/6/22.
//  Copyright © 2024 wind. All rights reserved.
//

import Foundation

class HUserModelMngr: HModelManager {
    var operateUser: GetOperateUser? {
        didSet {
            operateUser?.valueChange = { [weak self] in
                self?.perform(key: "modelChangeAction")
            }
        }
    }
}

struct GetOperateUser {
    var total: Int? {
        didSet {
            if oldValue != nil && total != oldValue {
                valueChange?()
            }
        }
    }
    var dayActive: Int?
    var monthActive: Int?
    var weekActive: Int?
    
    var valueChange: (() -> Void)?
}
