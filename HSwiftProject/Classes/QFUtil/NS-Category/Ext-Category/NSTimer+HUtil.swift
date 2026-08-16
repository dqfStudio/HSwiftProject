//
//  NSTimer+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension Timer {

    static func scheduledTimerWithTimeInterval(_ interval: TimeInterval, times: TimeInterval, block: @escaping (Timer) -> Void) {
        scheduleRepeating(interval: interval, times: times, fireImmediately: false, block: block, completion: nil)
    }
    
    static func scheduledTimerWithTimeInterval(_ interval: TimeInterval, times: TimeInterval, block: @escaping (Timer) -> Void, completion: @escaping () -> Void) {
        scheduleRepeating(interval: interval, times: times, fireImmediately: false, block: block, completion: completion)
    }

    static func scheduledTimerImmediatelyWithTimeInterval(_ interval: TimeInterval, times: TimeInterval, block: @escaping (Timer) -> Void) {
        scheduleRepeating(interval: interval, times: times, fireImmediately: true, block: block, completion: nil)
    }

    static func scheduledTimerImmediatelyWithTimeInterval(_ interval: TimeInterval, times: TimeInterval, block: @escaping (Timer) -> Void, completion: @escaping () -> Void) {
        scheduleRepeating(interval: interval, times: times, fireImmediately: true, block: block, completion: completion)
    }

    private static func scheduleRepeating(interval: TimeInterval, times: TimeInterval, fireImmediately: Bool, block: @escaping (Timer) -> Void, completion: (() -> Void)?) {
        let total = max(Int(times), 0)
        guard interval > 0, total > 0 else {
            completion?()
            return
        }
        var count = 0
        var finished = false
        let finish: (Timer) -> Void = { timer in
            guard !finished else { return }
            finished = true
            timer.invalidate()
            completion?()
        }
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            guard !finished else {
                timer.invalidate()
                return
            }
            count += 1
            block(timer)
            if count >= total {
                finish(timer)
            }
        }
        if fireImmediately {
            count += 1
            block(timer)
            if count >= total {
                finish(timer)
            }
        }
    }
    
}
