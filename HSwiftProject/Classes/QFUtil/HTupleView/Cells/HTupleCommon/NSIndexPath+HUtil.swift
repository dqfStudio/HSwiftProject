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
        return "\(self.section)-\(self.row)"
    }
    var nsStringValue: NSString {
        return "\(self.section)-\(self.row)" as NSString
    }

    static func stringValue(_ row: Int, _ section: Int) -> String {
        return "\(section)-\(row)"
    }
    static func nsStringValue(_ row: Int, _ section: Int) -> NSString {
        return "\(section)-\(row)" as NSString
    }
}

extension IndexPath {
    var nsStringValue: NSString {
        return "\(self.section)-\(self.row)" as NSString
    }

    static func stringValue(_ row: Int, _ section: Int) -> String {
        return "\(section)-\(row)"
    }
    static func nsStringValue(_ row: Int, _ section: Int) -> NSString {
        return "\(section)-\(row)" as NSString
    }
}
