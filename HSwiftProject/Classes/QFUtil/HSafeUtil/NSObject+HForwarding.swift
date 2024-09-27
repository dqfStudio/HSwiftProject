//
//  NSObject+HForwarding.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension NSObjectProtocol {

    @discardableResult
    func performWithRetainedValue(_ aSelector: Selector, withPre pre: String) -> AnyObject? {
        let selector = NSSelectorFromString(pre + NSStringFromSelector(aSelector))
        return self.perform(selector).takeRetainedValue()
    }
    @discardableResult
    func performWithUnretainedValue(_ aSelector: Selector, withPre pre: String) -> AnyObject? {
        let selector = NSSelectorFromString(pre + NSStringFromSelector(aSelector))
        return self.perform(selector).takeUnretainedValue()
    }
    @discardableResult
    func performWithUnretainedValue(_ aSelector: Selector) -> AnyObject? {
        return self.perform(aSelector).takeUnretainedValue()
    }

    
    @discardableResult
    func performWithRetainedValue(_ aSelector: Selector, with object: Any, withPre pre: String) -> AnyObject? {
        let selector = NSSelectorFromString(pre + NSStringFromSelector(aSelector))
        return self.perform(selector, with: object).takeRetainedValue()
    }
    @discardableResult
    func performWithUnretainedValue(_ aSelector: Selector, with object: Any, withPre pre: String) -> AnyObject? {
        let selector = NSSelectorFromString(pre + NSStringFromSelector(aSelector))
        return self.perform(selector, with: object).takeUnretainedValue()
    }
    @discardableResult
    func performWithUnretainedValue(_ aSelector: Selector, with object: Any) -> AnyObject? {
        return self.perform(aSelector, with: object).takeUnretainedValue()
    }

    
    @discardableResult
    func performWithRetainedValue(_ aSelector: Selector, with object1: Any, with object2: Any, withPre pre: String) -> AnyObject? {
        let selector = NSSelectorFromString(pre + NSStringFromSelector(aSelector))
        return self.perform(selector, with: object1, with: object2).takeRetainedValue()
    }
    @discardableResult
    func performWithRetainedValue(_ aSelector: Selector, with object1: Any, with object2: Any) -> AnyObject? {
        return self.perform(aSelector, with: object1, with: object2).takeRetainedValue()
    }
    
    @discardableResult
    func performWithUnretainedValue(_ aSelector: Selector, with object1: Any, with object2: Any, withPre pre: String) -> AnyObject? {
        let selector = NSSelectorFromString(pre + NSStringFromSelector(aSelector))
        return self.perform(selector, with: object1, with: object2).takeUnretainedValue()
    }
    @discardableResult
    func performWithUnretainedValue(_ aSelector: Selector, with object1: Any, with object2: Any) -> AnyObject? {
        return self.perform(aSelector, with: object1, with: object2).takeUnretainedValue()
    }
    
    
    func perform(_ aSelector: Selector, withPre pre: String) {
        let selector = NSSelectorFromString(pre + NSStringFromSelector(aSelector))
        self.perform(selector)
    }
    func perform(_ aSelector: Selector, with object: Any, withPre pre: String) {
        let selector = NSSelectorFromString(pre + NSStringFromSelector(aSelector))
        self.perform(selector, with: object)
    }
    func perform(_ aSelector: Selector, with object1: Any, with object2: Any, withPre pre: String) {
        let selector = NSSelectorFromString(pre + NSStringFromSelector(aSelector))
        self.perform(selector, with: object1, with: object2)
    }
}
