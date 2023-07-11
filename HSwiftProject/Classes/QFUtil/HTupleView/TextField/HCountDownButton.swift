//
//  HCountDownButton.swift
//  HSwiftProject
//
//  Created by Wind on 2020/2/5.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

typealias HCountDownChanging = (_ countDownButton: HCountDownButton, _ second: Int) -> String
typealias HCountDownFinished = (_ countDownButton: HCountDownButton, _ second: Int) -> String
typealias HCountDownHandler = (_ countDownButton: HCountDownButton, _ tag: Int) -> Void

class HCountDownButton: UIButton {

    private var currentSecond: Int = 0
    private var totalSecond: Int = 0
    
    private var countDownTimer: Timer?
    private var countDownDate: Date?
    
    private var countDownChanging: HCountDownChanging?
    private var countDownFinished: HCountDownFinished?
    private var countDownHandler: HCountDownHandler?
    
    ///倒计时按钮点击回调
    func countDownButtonHandler(_ countDownHandler: @escaping HCountDownHandler) {
        self.countDownHandler = countDownHandler
        self.addTarget(self, action: #selector(touchAction(_:)))
    }

    @objc
    private func touchAction(_ sender: HCountDownButton) {
        guard let countDownHandler = self.countDownHandler, (currentSecond <= 0 || currentSecond == totalSecond) else { return }
        countDownHandler(sender, sender.tag)
    }

    ///开始倒计时
    func startCountDownWithSecond(_ totalSecond: Int) {
        self.totalSecond = totalSecond
        currentSecond = totalSecond
        countDownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(timerStart(_:)),
                                              userInfo: nil,
                                              repeats: true)
        countDownDate = Date()
        countDownTimer!.fireDate = Date.distantPast
        RunLoop.current.add(countDownTimer!, forMode: .common)
    }
    
    @objc
    private func timerStart(_ theTimer: Timer) {

        guard let countDownDate = self.countDownDate else { return }
        let deltaTime: Double = Date().timeIntervalSince(countDownDate)
        currentSecond = self.totalSecond - NSInteger(deltaTime + 0.5)
        
        if currentSecond <= 0 {
            self.stopCountDown()
        } else {
            let title: String
            if let countDownChanging = self.countDownChanging {
                title = countDownChanging(self, self.currentSecond)
            } else {
                title = String(format: "%zd秒", self.currentSecond)
            }
            self.setTitle(title, for: .normal)
            self.adjustsImageWhenHighlighted = false
        }
    }
    
    ///停止倒计时
    func stopCountDown() {
        guard let timer = countDownTimer, timer.isValid else { return }
        timer.invalidate()
        currentSecond = self.totalSecond
        let title = countDownFinished?(self, self.totalSecond) ?? "重新获取"
        self.setTitle(title, for: .normal)
        self.adjustsImageWhenHighlighted = false
    }

    ///倒计时时间改变回调
    func countDownChanging(_ countDownChanging: @escaping HCountDownChanging) {
        self.countDownChanging = countDownChanging
    }
    
    ///倒计时结束回调
    func countDownFinished(_ countDownFinished: @escaping HCountDownFinished) {
        self.countDownFinished = countDownFinished
    }

}
