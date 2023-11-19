//
//  NSIndexPath+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension NSIndexPath {
    var stringValue: String {
        return "\(self.row)" + "\(self.section)"
    }
    var nsStringValue: NSString {
        return "\(self.row)" + "\(self.section)" as NSString
    }
    
    static func stringValue(_ row: Int, _ section: Int) -> String {
        return "\(row)" + "\(section)"
    }
    static func nsStringValue(_ row: Int, _ section: Int) -> NSString {
        return "\(row)" + "\(section)" as NSString
    }
}

extension IndexPath {
    var stringValue: String {
        return "\(self.row)" + "\(self.section)"
    }
    var nsStringValue: NSString {
        return "\(self.row)" + "\(self.section)" as NSString
    }
    
    static func stringValue(_ row: Int, _ section: Int) -> String {
        return "\(row)" + "\(section)"
    }
    static func nsStringValue(_ row: Int, _ section: Int) -> NSString {
        return "\(row)" + "\(section)" as NSString
    }
}
