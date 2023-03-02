//
//  CGRect.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/19.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension CGRect {
    
    var x: CGFloat {
        get { return self.origin.x }
        set { self.origin.x = newValue }
    }
    
    var y: CGFloat {
        get { return self.origin.y }
        set { self.origin.y = newValue }
    }
    
    public var width: CGFloat {
        get { return self.size.width }
        set { self.size.width = newValue }
    }
    
    public var height: CGFloat {
        get { return self.size.height }
        set { self.size.height = newValue }
    }
    
}
