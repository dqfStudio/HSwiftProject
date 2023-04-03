//
//  NSMutableAttributedString+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 17/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

public extension NSMutableAttributedString {
    func appendAttributedText(_ attribute: NSMutableAttributedString) -> NSMutableAttributedString {
        self.append(attribute)
        return self
    }
    func allRange() -> NSRange {
        return NSRange(location: 0, length: self.length)
    }
    /// 添加图片
    ///
    /// - Parameters:
    ///   - image: 图片对象
    ///   - bounds: 图片大小位置
    ///   - index: 插入下标
    /// - Returns: NSMutableAttributedString
    func picture( _ image: UIImage?, bounds: CGRect, index: Int) -> NSMutableAttributedString {
        guard let image = image else {
            return self
        }
        let attchImage = NSTextAttachment()
        attchImage.image = image
        // 设置图片大小
        attchImage.bounds = bounds
        let imageAttr = NSAttributedString(attachment: attchImage)
        self.insert(imageAttr, at: index)
        return self
    }
    
    // 中划线
    func strike(_ value: Int) -> NSMutableAttributedString {
        self.addAttributes([.strikethroughStyle:value], range: self.allRange())
        return self
    }
    // 中划线颜色
    func strikeColor(_ color: UIColor) -> NSMutableAttributedString {
        self.addAttributes([.strikethroughColor:color], range: self.allRange())
        return self
    }
    // 描边宽度
    func strokeWidth(_ width: CGFloat) -> NSMutableAttributedString {
        self.addAttributes([.strokeWidth:width], range: self.allRange())
        return self
    }
    // 描边颜色
    func strokeColor(_ color: UIColor) -> NSMutableAttributedString {
        self.addAttributes([.strokeColor:color], range: self.allRange())
        return self
    }
    // 字间距
    func fontSpace(_ space: CGFloat) -> NSMutableAttributedString {
        self.addAttributes([.kern:space], range: self.allRange())
        return self
    }
    // 背景色
    func backgroundColor(_ color: UIColor) -> NSMutableAttributedString {
        self.addAttributes([.backgroundColor:color], range: self.allRange())
        return self
    }
    // 前景色
    func color(_ color: UIColor) -> NSMutableAttributedString {
        self.addAttributes([.foregroundColor:color], range: self.allRange())
        return self
    }
    // 下划线
    func underLine(_ style: NSUnderlineStyle) -> NSMutableAttributedString {
        self.addAttributes([.underlineStyle:style.rawValue], range: self.allRange())
        return self
    }
    // 下划线颜色
    func underLineColor(_ color: UIColor) -> NSMutableAttributedString {
        self.addAttributes([.underlineColor:color], range: self.allRange())
        return self
    }
    // 字体
    func font(_ font: UIFont) -> NSMutableAttributedString {
        let attributes = NSObject.attributes(withFont: font)
        self.addAttributes(attributes, range: self.allRange())
        //self.addAttributes([.font:font], range: self.allRange())
        return self
    }
    // 系统字体大小
    func fontSize(_ size: CGFloat) -> NSMutableAttributedString {
        self.addAttributes([.font:UIFont.systemFont(ofSize: size)], range: self.allRange())
        return self
    }
    // 对齐方式
    func alignment(_ alignment: NSTextAlignment) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        self.addAttribute(.paragraphStyle, value: style, range: self.allRange())
        return self
    }
    // 行间距
    func lineSpace( _ space: CGFloat) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = space
        style.lineBreakMode = .byCharWrapping
        self.addAttribute(.paragraphStyle, value: style, range: self.allRange())
        return self
    }
    
    // 文字省略方式
    func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = lineBreakMode
        self.addAttribute(.paragraphStyle, value: style, range: self.allRange())
        return self
    }
    
    func toActionString() -> HActionString {
        return HActionString(attributeText: self)
    }
    
}

extension String {
    func attribute() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
    //计算文字的大小
    func size(withFont font: UIFont, width: CGFloat = CGFloat.greatestFiniteMagnitude, height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        let attributes = NSObject.attributes(withFont: font)
        var textSize = CGSize(width: width, height: height)
        textSize = self.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: attributes,
                                     context: nil).size
        return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
    }
}

extension NSObject {
    /**
     *  @brief 根据字体获取符合本项目的相关字体属性
     *
     *  @param font   字体
     */
    static func attributes(withFont font: UIFont) -> [NSAttributedString.Key : Any] {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = NSObject.lineHeight(withFont: font)
        style.lineBreakMode = .byWordWrapping
        return [NSAttributedString.Key.font : font,
                NSAttributedString.Key.paragraphStyle : style]

    }
    /**
     *  获取本项目的行高度
     */
    static func lineHeight(withFont font: UIFont) -> CGFloat {
        
        //行间距
        var lineSpace = 14.0
        
        switch (font.pointSize) {
        case 9, 10:
            lineSpace = 14.0
            break
        case 12:
            lineSpace = 18.0
            break
        case 13:
            lineSpace = 20.0
            break
        case 14:
            lineSpace = 22.0
            break
        case 16:
            lineSpace = 24.0
            break
        case 17:
            lineSpace = 26.0
            break
        case 24:
            lineSpace = 34.0
            break
        default:
            break
        }
        
        lineSpace -= font.lineHeight - font.pointSize
        
        return lineSpace
    }
}

extension UIFont {
    class func font(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: weight)
    }
}
