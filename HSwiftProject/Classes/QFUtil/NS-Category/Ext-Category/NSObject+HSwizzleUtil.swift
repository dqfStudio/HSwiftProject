//
//  NSObject+HSwizzleUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

func HSwizzleClassMethod(_ cls: AnyClass, _ origSEL: Selector, _ overrideSEL: Selector) {
    let originalMethod: Method = class_getClassMethod(cls, origSEL)!
    let swizzledMethod: Method = class_getClassMethod(cls, overrideSEL)!
    
    let metacls: AnyClass = objc_getMetaClass(NSStringFromClass(cls).cString(using: .utf8)!) as! AnyClass
    if (class_addMethod(metacls,
                        origSEL,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod))) {
        /* swizzing super class method, added if not exist */
        class_replaceMethod(metacls,
                            overrideSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod))
        
    }else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(metacls,
                            overrideSEL,
                            class_replaceMethod(metacls,
                                                origSEL,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod))!,
                            method_getTypeEncoding(originalMethod))
    }
}

func HSwizzleInstanceMethod(_ cls: AnyClass, _ origSEL: Selector, _ overrideSEL: Selector) {
    /* if current class not exist selector, then get super*/
    let originalMethod: Method = class_getClassMethod(cls, origSEL)!
    let swizzledMethod: Method = class_getClassMethod(cls, overrideSEL)!
    
    /* add selector if not exist, implement append with method */
    if (class_addMethod(cls,
                        origSEL,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod))) {
        /* replace class instance method, added if selector not exist */
        /* for class cluster , it always add new selector here */
        class_replaceMethod(cls,
                            overrideSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod))
        
    }else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(cls,
                            overrideSEL,
                            class_replaceMethod(cls,
                                                origSEL,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod))!,
                            method_getTypeEncoding(originalMethod))
    }
}

func HSwizzleClassMethodNames(_ classNames: NSArray, _ origSEL: Selector, _ overrideSEL: Selector) {
    if classNames.count == 0 { return }
    for className in classNames {
        HSwizzleClassMethod(NSClassFromString(className as! String)!, origSEL, overrideSEL)
    }
}

func HSwizzleInstanceMethodNames(_ classNames: NSArray, _ origSEL: Selector, _ overrideSEL: Selector) {
    if classNames.count == 0 { return }
    for className in classNames {
        HSwizzleClassMethod(NSClassFromString(className as! String)!, origSEL, overrideSEL)
    }
}

extension NSObject {
    static func methodSwizzleWithOrigSEL(_ origSEL: Selector, _ overrideSEL: Selector) {
        HSwizzleInstanceMethod(self.classForCoder(), origSEL, overrideSEL)
    }
    static func classMethodSwizzleWithOrigSEL(_ origSEL: Selector, _ overrideSEL: Selector) {
        HSwizzleClassMethod(self.classForCoder(), origSEL, overrideSEL)
    }
}
