//
//  NSObject+HSwizzleUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

func HSwizzleClassMethod(_ cls: AnyClass, _ origSEL: Selector, _ overrideSEL: Selector) {
    guard let originalMethod = class_getClassMethod(cls, origSEL),
          let swizzledMethod = class_getClassMethod(cls, overrideSEL),
          let metacls = object_getClass(cls) else { return }
    if class_addMethod(metacls,
                       origSEL,
                       method_getImplementation(swizzledMethod),
                       method_getTypeEncoding(swizzledMethod)) {
        class_replaceMethod(metacls,
                            overrideSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod))
    } else if let classMethod = class_replaceMethod(metacls,
                                                    origSEL,
                                                    method_getImplementation(swizzledMethod),
                                                    method_getTypeEncoding(swizzledMethod)) {
        class_replaceMethod(metacls,
                            overrideSEL,
                            classMethod,
                            method_getTypeEncoding(originalMethod))
    }
}

func HSwizzleInstanceMethod(_ cls: AnyClass, _ origSEL: Selector, _ overrideSEL: Selector) {
    /* if current class not exist selector, then get super*/
    if let originalMethod = class_getInstanceMethod(cls, origSEL),
        let swizzledMethod = class_getInstanceMethod(cls, overrideSEL) {
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
            if let classMethod = class_replaceMethod(cls,
                                                     origSEL,
                                                     method_getImplementation(swizzledMethod),
                                                     method_getTypeEncoding(swizzledMethod)) {
                class_replaceMethod(cls,
                                    overrideSEL,
                                    classMethod,
                                    method_getTypeEncoding(originalMethod))
            }
        }
    }
}

func HSwizzleClassMethodNames(_ classNames: NSArray, _ origSEL: Selector, _ overrideSEL: Selector) {
    classNames.forEach { className in
        if let name = className as? String, let cls = NSClassFromString(name) {
            HSwizzleClassMethod(cls, origSEL, overrideSEL)
        }
    }
}

func HSwizzleInstanceMethodNames(_ classNames: NSArray, _ origSEL: Selector, _ overrideSEL: Selector) {
    classNames.forEach { className in
        if let name = className as? String, let cls = NSClassFromString(name) {
            HSwizzleInstanceMethod(cls, origSEL, overrideSEL)
        }
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
