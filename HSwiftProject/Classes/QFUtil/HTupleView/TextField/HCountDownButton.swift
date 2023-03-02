//
//  HCountDownButton.swift
//  HSwiftProject
//
//  Created by wind on 2020/2/5.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

typealias HCountDownChanging = (_ countDownButton: HCountDownButton, _ second: Int) -> NSString
typealias HCountDownFinished = (_ countDownButton: HCountDownButton, _ second: Int) -> NSString
typealias HTouchedCountDownButtonHandler = (_ countDownButton: HCountDownButton, _ tag: Int) -> Void

class HCountDownButton: UIButton {

    private var _second: Int = 0
    private var _totalSecond: Int = 0
    
    private var _timer: Timer?
    private var _startDate: NSDate?
    
    private var _countDownChanging: HCountDownChanging?
    private var _countDownFinished: HCountDownFinished?
    private var _touchedCountDownButtonHandler: HTouchedCountDownButtonHandler?
    
    ///倒计时按钮点击回调
    func countDownButtonHandler(_ touchedCountDownButtonHandler: @escaping HTouchedCountDownButtonHandler) {
        _touchedCountDownButtonHandler = touchedCountDownButtonHandler
        self.addTarget(self, action: #selector(touched(_:)))
    }

    @objc
    private func touched(_ sender: HCountDownButton) {
        if _touchedCountDownButtonHandler != nil && (_second <= 0 || _second == _totalSecond) {
            DispatchQueue.main.async { [weak self] in
                self!._touchedCountDownButtonHandler!(sender, sender.tag)
            }
        }
    }

    ///开始倒计时
    func startCountDownWithSecond(_ totalSecond: Int) {
        _totalSecond = totalSecond
        _second = totalSecond
        
        _timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerStart(_:)), userInfo: nil, repeats: true)
        _startDate = NSDate() as NSDate
        _timer!.fireDate = NSDate.distantPast
        RunLoop.current.add(_timer!, forMode: .common)
    }
    @objc
    private func timerStart(_ theTimer: Timer) {

        let deltaTime: Double = NSDate().timeIntervalSince(_startDate! as Date)
         _second = _totalSecond - NSInteger(deltaTime + 0.5)
        
        if (_second <= 0) {
            self.stopCountDown()
        }else {
            if _countDownChanging != nil {
                DispatchQueue.main.async { [weak self] in
                    let title: String = self!._countDownChanging!(self!, self!._second) as String
                    self!.setTitle(title, for: .normal)
                    self!.setTitle(title, for: .disabled)
                }
            }else {
                DispatchQueue.main.async { [weak self] in
                    let title = NSString(format: "%zd秒", self!._second) as String
                    self!.setTitle(title, for: .normal)
                    self!.setTitle(title, for: .disabled)
                }
            }
        }
    }
    
    ///停止倒计时
    func stopCountDown() {
        if _timer != nil {
            if _timer!.isValid {
                _timer!.invalidate()
                _second = _totalSecond
                if _countDownFinished != nil {
                    DispatchQueue.main.async { [weak self] in
                        let title = self!._countDownFinished!(self!, self!._totalSecond) as String
                        self!.setTitle(title, for: .normal)
                        self!.setTitle(title, for: .disabled)
                    }
                }else {
                    DispatchQueue.main.async { [weak self] in
                        self!.setTitle("重新获取", for: .normal)
                        self!.setTitle("重新获取", for: .disabled)
                    }
                }
            }
        }
    }

    ///倒计时时间改变回调
    func countDownChanging(_ countDownChanging: @escaping HCountDownChanging) {
        _countDownChanging = countDownChanging
    }
    ///倒计时结束回调
    func countDownFinished(_ countDownFinished: @escaping HCountDownFinished) {
        _countDownFinished = countDownFinished
    }

}
