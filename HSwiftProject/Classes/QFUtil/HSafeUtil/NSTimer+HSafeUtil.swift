//
//  NSTimer+HSafeUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

typealias HBlockInvoke = (_ timer: Timer) -> Void

extension Timer {

    static func safe_scheduledTimerWithTimeInterval(_ interval: TimeInterval, repeats: Bool, block: @escaping (_ timer: Timer) -> Void) -> Timer {
        return self.scheduledTimer(timeInterval: interval,
                                   target: self,
                                   selector: #selector(safe_blockInvoke(_:)),
                                   userInfo: block,
                                   repeats: repeats)
    }

    @objc
    private static func safe_blockInvoke(_ timer: Timer) {
        let block: HBlockInvoke = timer.userInfo as! HBlockInvoke
        block(timer)
    }

    ///恢复
    func safe_resume() {
        if self.isValid == false { return }
        if #available(iOS 13.0, *) {
            self.fireDate = NSDate.now
        } else {
            self.fireDate = NSDate() as Date
        }
    }
    
    ///暂停
    func safe_pause() {
        if self.isValid == false { return }
        self.fireDate = NSDate.distantFuture
    }
    
}
