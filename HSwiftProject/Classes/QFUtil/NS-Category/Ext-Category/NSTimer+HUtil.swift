//
//  NSTimer+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension Timer {

    static func scheduledTimerWithTimeInterval(_ interval: TimeInterval, times: TimeInterval, block: @escaping (Timer) -> Void) {
        var count: TimeInterval = 0
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            count += interval
            if count < interval * times {
                block(timer)
            }else if count >= interval * times {
                timer.invalidate()
                block(timer)
            }
        }
    }
    
    static func scheduledTimerWithTimeInterval(_ interval: TimeInterval, times: TimeInterval, block: @escaping (Timer) -> Void, completion: @escaping () -> Void) {
        var count: TimeInterval = 0
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            count += interval
            if count <= interval * times {
                block(timer)
            }else if count > interval * times {
                timer.invalidate()
                completion()
            }
        }
    }

    static func scheduledTimerImmediatelyWithTimeInterval(_ interval: TimeInterval, times: TimeInterval, block: @escaping (Timer) -> Void) {
        var count: TimeInterval = 0
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            count += interval
            if count < interval * times {
                block(timer)
            }else if count == interval * times {
                timer.invalidate()
                block(timer)
            }else if count > interval * times {
                timer.invalidate()
            }
        }
        //先调用一次
        count += interval
        block(timer)
    }

    static func scheduledTimerImmediatelyWithTimeInterval(_ interval: TimeInterval, times: TimeInterval, block: @escaping (Timer) -> Void, completion: @escaping () -> Void) {
        var count: TimeInterval = 0
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            count += interval
            if count <= interval * times {
                block(timer)
            }else if count > interval * times {
                timer.invalidate()
                completion()
            }
        }
        //先调用一次
        count += interval
        block(timer)
    }
    
}
