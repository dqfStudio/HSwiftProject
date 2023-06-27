//
//  HVerifyCodeView.swift
//  HSwiftProject
//
//  Created by Wind on 2020/2/6.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

private func HRGBColor(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}
private func HRandColor(_ a: CGFloat) -> UIColor {
    return HRGBColor(CGFloat.random(in: 1.0 ... 255.0), CGFloat.random(in: 1.0 ... 255.0), CGFloat.random(in: 1.0 ... 255.0), a)
}

class HVerifyCodeView: UIControl {

    /**
    VerifyCodeView:1.随机内容(默认由0~9与26个大小写字母随机组合)2.文本颜色(默认黑色)3.字体大小(默认20)4.获取当前验证码等
    */
    /// 文本颜色
    var textColor: UIColor = UIColor.black
    /// 字体大小
    var textSize: CGFloat = 20.0
    
    private var _charsArray: NSArray = NSArray(objects: "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z")
    ///随机内容, 字符数组如:@[@"a",@"F",@"A",@"1",@"0"]
    /// 随机内容
    var charsArray: NSArray {
        get {
            return _charsArray
        }
        set {
            if newValue != _charsArray {
                _charsArray = newValue
                self.refreshVerifyCode()
            }
        }
    }
    
    private var _verifyCodeString: NSString?
    /// 验证码
    var verifyCodeString: NSString? {
        return _verifyCodeString
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = HRandColor(0.2)
        self.addTarget(self, action: #selector(verifyCodeAction), for: .touchUpInside)
        self.loadCode()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = HRandColor(0.2)
        self.addTarget(self, action: #selector(verifyCodeAction), for: .touchUpInside)
        self.loadCode()
    }
    
    @objc
    private func verifyCodeAction() {
        self.refreshVerifyCode()
    }

    ///刷新随机验证码
    func refreshVerifyCode() {
        self.loadCode()
        self.setNeedsDisplay()
    }
    private func loadCode() {
        let mutableString = NSMutableString()
        for _ in 0..<4 {
            let index = Int.random(in: 1..._charsArray.count - 1)
            let string = _charsArray.object(at: Int(index))
            mutableString.append(string as! String)
        }
        _verifyCodeString = mutableString
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        var color: UIColor = HRandColor(0.5)
        self.backgroundColor = color

        if _verifyCodeString == nil {
            return
        }
        let text: NSString = _verifyCodeString!
        let cSize = NSString(string: "S").size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: textSize), NSAttributedString.Key.foregroundColor: textColor])
        let width = rect.size.width / CGFloat(text.length) - cSize.width
        let height = rect.size.height - cSize.height
        var point: CGPoint = CGPoint.zero

        var pX: CGFloat = 0.0
        var pY: CGFloat = 0.0
        
        for i in 0..<text.length {
            pX = CGFloat.random(in: 1...width) + rect.size.width / CGFloat(text.length) * CGFloat(i)
            pY = CGFloat.random(in: 1...height)
            point = CGPoint(x: pX, y: pY)
            let c = text.character(at: i)
            let textC = NSString(format: "%C", c)
            textC.draw(at: point, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: textSize), NSAttributedString.Key.foregroundColor: textColor])
        }

        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(1.0)
            
            for _ in 0..<10 {
                
                color = HRandColor(0.2)
                context.setStrokeColor(color.cgColor)
                let path = CGMutablePath()
                
                pX = CGFloat.random(in: 1...rect.size.width)
                pY = CGFloat.random(in: 1...rect.size.height)
                path.move(to: CGPoint(x: pX, y: pY))
                
                pX = CGFloat.random(in: 1...rect.size.width)
                pY = CGFloat.random(in: 1...rect.size.height)
                path.addLine(to: CGPoint(x: pX, y: pY))
                
                context.strokePath()
            }
        }
        
    }

}
