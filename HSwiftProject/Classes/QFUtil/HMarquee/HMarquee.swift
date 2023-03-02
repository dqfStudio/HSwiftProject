//
//  HMarquee.swift
//  HSwiftProject
//
//  Created by wind on 2020/2/8.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

enum HMarqueeSpeedLevel: Int {
    case Fast = 2
    case MediumFast = 4
    case MediumSlow = 6
    case Slow = 8
}

typealias HWonderfulAction = () -> Void

private enum HMarqueeTapMode: Int {
    case Move   = 1
    case Action = 2
}

class HMarquee: UIView {
    
    private var _bgBtn: UIButton?
    private var bgBtn: UIButton {
        if _bgBtn == nil {
            _bgBtn = UIButton(frame: self.bounds)
            _bgBtn!.addTarget(self, action: #selector(bgButtonClick), for: .touchUpInside)
        }
        return _bgBtn!
    }
    private var _marqueeLbl: UILabel?
    private var marqueeLbl: UILabel {
        get {
            if _marqueeLbl == nil {
                self.tapMode = .Move
                let h: CGFloat = self.frame.size.height
                _marqueeLbl = UILabel()
                _marqueeLbl!.text = self.msg
                
                let fnt = UIFont(name: "HelveticaNeue", size: 14.0)
                _marqueeLbl!.font = fnt
                
                let text: NSString = _marqueeLbl!.text! as NSString
                let msgSize = text.size(withAttributes: [NSAttributedString.Key.font: fnt!])
                
                _marqueeLbl!.frame = CGRect(x: 0, y: 0, width: msgSize.width, height: h)
                if self.marqueeLabelFont != nil {
                    _marqueeLbl!.font = self.marqueeLabelFont
                }
                _marqueeLbl!.textColor = self.txtColor
            }
            return _marqueeLbl!
        }
    }
    private var tapAction: HWonderfulAction?
    private var tapMode: HMarqueeTapMode = .Move
    private var speedLevel: HMarqueeSpeedLevel = .MediumFast
    private var middleView: UIView?
    private var marqueeLabelFont: UIFont?
    
    
    /// 滚动文字 修改源码，防止出来可以在接口调用完成后动态设置显示文案
    private var _msg: String?
    var msg: String? {
        get {
            return _msg
        }
        set {
            _msg = newValue
            self.marqueeLbl.text = newValue
            self.doSometingBeginning()
        }
    }
    /// 背景颜色
    private var _bgColor: UIColor?
    var bgColor: UIColor? {
        get {
            return _bgColor
        }
        set {
            _bgColor = newValue
            self.backgroundColor = newValue
        }
    }
    /// 字体颜色
    private var _txtColor: UIColor?
    var txtColor: UIColor? {
        get {
            return _txtColor
        }
        set {
            _txtColor = newValue
            marqueeLbl.textColor = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /**
    *  style is default, backgroundColor is white,textColor is black
    *
    *  @param speed you can set 2,4,6,8.  smaller is faster
    *
    *  @return self
    */
    init(frame: CGRect, speed: HMarqueeSpeedLevel?, msg: String?) {
        super.init(frame: frame)
        self.layer.cornerRadius = 2
        self.msg = msg
        if speed != nil {
            self.speedLevel = speed!
        }else {
            self.speedLevel = .MediumFast
        }
        self.bgColor = UIColor.white
        self.txtColor = UIColor.darkGray
    }

    /**
    *  style is diy, backgroundColor and textColor can config
    *
    *  @param speed  you can set 2,4,6,8.  smaller is faster
    *  @param bgColor  backgroundColor
    *  @param txtColor textColor
    *
    *  @return self
    */
    init(frame: CGRect, speed: HMarqueeSpeedLevel?, msg: String?, bgColor: UIColor?, txtColor: UIColor?) {
        super.init(frame: frame)
        self.layer.cornerRadius = 2
        self.msg = msg
        if bgColor != nil {
            self.bgColor = bgColor!
        }else {
            self.bgColor = UIColor.white
        }
        
        if txtColor != nil {
            self.txtColor = txtColor!
        }else {
            self.txtColor = UIColor.darkGray
        }
        
        if speed != nil {
            self.speedLevel = speed!
        }else {
            self.speedLevel = .MediumFast
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override
    var frame: CGRect {
        get {
            return super.frame
        }
        set {
            if super.frame != newValue {
                super.frame = newValue
                middleView?.frame = self.bounds
                
                self.bgBtn.frame = self.bounds
                
                var tmpFrame: CGRect = marqueeLbl.frame
                tmpFrame.size.height = self.frame.size.height
                marqueeLbl.frame = tmpFrame
            }
        }
    }

    private func doSometingBeginning() {
        self.layer.masksToBounds = true
        self.backgroundColor = self.bgColor
        NotificationCenter.default.addObserver(self, selector: #selector(backAndRestart), name: UIApplication.didBecomeActiveNotification, object: nil)
        self.middleView = nil
        middleView = UIView(frame: self.bounds)
        middleView!.addSubview(self.marqueeLbl)
        self.addSubview(middleView!)
        
        self.bgBtn.frame = self.bounds
        self.bringSubviewToFront(self.bgBtn)
    }

    /**
    *  you can change the tapAction show or jump, without this method default is tap to stop
    *
    *  @param action tapAction block code
    */
    func changeTapMarqueeAction(action: @escaping HWonderfulAction) {
        self.addSubview(self.bgBtn)
        self.tapAction = action
        self.tapMode = .Action
        self.bringSubviewToFront(self.bgBtn)
    }

    /**
    *  you can change marqueeLabel 's font before start
    *
    */
    func changeMarqueeLabelFont(_ font: UIFont) {

        self.marqueeLbl.font = font
        self.marqueeLabelFont = font
        
        let text: NSString = marqueeLbl.text! as NSString
        let msgSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
        
        var fr: CGRect = self.marqueeLbl.frame
        fr.size.width = msgSize.width
        self.marqueeLbl.frame = fr
    }

    @objc
    private func bgButtonClick() {
        if self.tapAction != nil {
            self.tapAction!()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.tapMode == .Move {
            self.stop()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.tapMode == .Move {
            self.restart()
        }
    }

    /**
    *  when you set everything what you want,you can use this method to begin animate
    */
    func start() {
        self.moveAction()
    }

    @objc
    private func backAndRestart () {
        self.marqueeLbl.layer.removeAllAnimations()
        self.marqueeLbl.removeFromSuperview()
        _marqueeLbl = nil
        self.middleView?.addSubview(self.marqueeLbl)
        self.moveAction()
    }

    /**
    *  pause
    */
    func stop() {
        
        self.pauseLayer(self.marqueeLbl.layer)
    }

    /**
    *  will start with the point we stoped.
    */
    func restart() {
        self.resumeLayer(self.marqueeLbl.layer)
    }

    private func moveAction() {
        var fr: CGRect = self.marqueeLbl.frame
        fr.origin.x = self.frame.size.width
        self.marqueeLbl.frame = fr
        
        let fromPoint = CGPoint(x: self.frame.size.width + self.marqueeLbl.frame.size.width / 2, y: self.frame.size.height / 2)
        
        let movePath = UIBezierPath()
        movePath.move(to: fromPoint)
        movePath.addLine(to: CGPoint(x: -self.marqueeLbl.frame.size.width / 2, y: self.frame.size.height / 2))

        let moveAnim: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        moveAnim.path = movePath.cgPath
        moveAnim.isRemovedOnCompletion = true
        
        let width = self.marqueeLbl.frame.size.width
        
        moveAnim.duration = CFTimeInterval(width * CGFloat(self.speedLevel.rawValue) * 0.01)
        moveAnim.delegate = self as? CAAnimationDelegate
        
        self.marqueeLbl.layer.add(moveAnim, forKey: nil)
    }

    private func pauseLayer(_ layer: CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    private func resumeLayer(_ layer: CALayer) {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }

    private func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.moveAction()
        }
    }
    
}
