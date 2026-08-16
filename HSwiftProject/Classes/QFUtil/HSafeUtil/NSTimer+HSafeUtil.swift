//
//  NSTimer+HSafeUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension Timer {

    static func safe_scheduledTimerWithTimeInterval(_ interval: TimeInterval, repeats: Bool, block: @escaping (_ timer: Timer) -> Void) -> Timer {
        Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
    }

    ///恢复
    func safe_resume() {
        guard isValid else { return }
        fireDate = Date()
    }
    
    ///暂停
    func safe_pause() {
        guard isValid else { return }
        fireDate = Date.distantFuture
    }
    
}
