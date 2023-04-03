//
//  NSObject+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/16.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation

extension NSObject {
 
    //返回className
    var className: String {
        let name = type(of: self).description()
        if name.contains(".") {
            return name.components(separatedBy: ".")[1]
        }else {
            return name
        }
    }
    
    public func isSystemClass(_ aClass: AnyClass ) -> Bool {
        let bundle: Bundle = Bundle(for: aClass)
        if bundle == Bundle.main {
            return false
        }else {
            return true
        }
    }
    
}
