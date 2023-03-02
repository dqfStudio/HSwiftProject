//
//  NSIndexPath+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/23.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension NSIndexPath {
    var stringValue: NSString {
        return "\(self.row)" + "\(self.section)" as NSString
    }
    
    static func stringValue(_ row: Int, _ section: Int) -> NSString {
        return "\(row)" + "\(section)" as NSString
    }
    static func instanceValue(_ row: Int, _ section: Int) -> NSIndexPath {
        return NSIndexPath(row: row, section: section)
    }
}

extension IndexPath {
    var stringValue: String {
        return "\(self.row)" + "\(self.section)"
    }
    
    static func stringValue(_ row: Int, _ section: Int) -> String {
        return "\(row)" + "\(section)"
    }
    static func instanceValue(_ row: Int, _ section: Int) -> IndexPath {
        return IndexPath(row: row, section: section)
    }
}
