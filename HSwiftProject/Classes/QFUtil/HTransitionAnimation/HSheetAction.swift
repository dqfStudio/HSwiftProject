//
//  HSheetAction.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/3.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

typealias HSheetActionBlock = (_ action: Int ) -> Void

class HSheetAction: NSObject {
    
    // 标题
    private var _title: String = ""
    var title: String {
        return _title
    }
    
    // 图标
    private var _image: String?
    var image: String? {
        return _image
    }
    
    // 选择的类型
    private var _handler: HSheetActionBlock?
    var handler: HSheetActionBlock? {
        return _handler
    }
    
    required init(title: String, image: String? = nil, handler: @escaping (Int) -> Void) {
        super.init()
        _title = title
        _image = image
        _handler = handler
    }
    
}
