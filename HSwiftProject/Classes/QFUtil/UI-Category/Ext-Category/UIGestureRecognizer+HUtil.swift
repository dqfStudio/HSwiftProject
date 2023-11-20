//
//  UIGestureRecognizer+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/19.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var gesture_block_key: Void?

private typealias HGestureBlock = (_ sender: AnyObject) -> Void

class UIGestureRecognizerBlockTarget: NSObject {

    private var block: HGestureBlock?
    
    @objc
    private func invoke(_ sender: AnyObject) {
        self.block?(sender)
    }

    convenience init(block: @escaping (_ sender: AnyObject) -> Void) {
        self.init()
        self.block = block
    }
    
    override init() {
        super.init()
    }
}

extension UIGestureRecognizer {
    
    convenience init(block: @escaping (_ sender: AnyObject) -> Void) {
        self.init()
        self.addActionBlock(block)
    }

    private func addActionBlock(_ block: @escaping (_ sender: AnyObject) -> Void) {
        let target: UIGestureRecognizerBlockTarget = UIGestureRecognizerBlockTarget(block: block)
        self.addTarget(target, action: NSSelectorFromString("invoke:"))
        let targets = self.allGestureRecognizerBlockTargets()
        targets.add(target)
    }
    
    func removeAllActionBlocks() {
        let targets = self.allGestureRecognizerBlockTargets()
        targets.enumerateObjects { (target, idx, stop) in
            self.removeTarget(targets, action: NSSelectorFromString("invoke:"))
        }
        targets.removeAllObjects()
    }

    func allGestureRecognizerBlockTargets() -> NSMutableArray {
        var targets = objc_getAssociatedObject(self, &gesture_block_key) as? NSMutableArray
        if targets == nil {
            targets = NSMutableArray()
            objc_setAssociatedObject(self, &gesture_block_key, targets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return targets!
    }

}
