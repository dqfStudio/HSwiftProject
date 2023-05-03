//
//  HAlertAction.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/3.
//  Copyright © 2023 wind. All rights reserved.
//

//import UIKit
//
//enum HAlertActionStyle: Int {
//    case cancel = 0
//    case confirm = 1
//}
//
//typealias HAlertActionBlock = (_ action: HAlertActionStyle ) -> Void
//
//class HAlertAction: NSObject {
//
//    // 标题
//    private var _title: String = ""
//    var title: String {
//        return _title
//    }
//
//    // 类型
//    private var _style: HAlertActionStyle = .cancel
//    var style: HAlertActionStyle {
//        return _style
//    }
//
//    // 选择的类型
//    private var _handler: HAlertActionBlock?
//    var handler: HAlertActionBlock? {
//        return _handler
//    }
//
//    required init(title: String, style: HAlertActionStyle, handler: @escaping (HAlertActionStyle) -> Void) {
//        super.init()
//        _title = title
//        _style = style
//        _handler = handler
//    }
//}
