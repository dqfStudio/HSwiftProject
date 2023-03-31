//
//  NSString+HSize.swift
//  HSwiftProject
//
//  Created by Wind on 25/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

extension NSString {
    /**
     *  @brief 计算文字的高度
     *
     *  @param font  字体(默认为系统字体)
     *  @param width 约束宽度
     */
    func heightWithFont(_ font: UIFont?, constrainedToWidth width: CGFloat) -> CGFloat {

        var textFont: UIFont? = font
        if (font == nil) {
            textFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping

        let textSize = self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [NSAttributedString.Key.font : textFont!, NSAttributedString.Key.paragraphStyle : paragraph],
                                         context: nil).size

        return ceil(textSize.height)
    }

    /**
     *  @brief 计算文字的宽度
     *
     *  @param font   字体(默认为系统字体)
     *  @param height 约束高度
     */
    func widthWithFont(_ font: UIFont?, constrainedToHeight height: CGFloat) -> CGFloat {

        var textFont: UIFont? = font
        if (font == nil) {
            textFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping

        let textSize = self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [NSAttributedString.Key.font : textFont!, NSAttributedString.Key.paragraphStyle : paragraph],
                                         context: nil).size

        return ceil(textSize.width)
    }

    /**
     *  @brief 计算文字的大小
     *
     *  @param font  字体(默认为系统字体)
     *  @param width 约束宽度
     */
    func sizeWithFont(_ font: UIFont?, constrainedToWidth width: CGFloat) -> CGSize {

        var textFont: UIFont? = font
        if (font == nil) {
            textFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping

        let textSize = self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [NSAttributedString.Key.font : textFont!, NSAttributedString.Key.paragraphStyle : paragraph],
                                         context: nil).size

        return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
    }

    /**
     *  @brief 计算文字的大小
     *
     *  @param font   字体(默认为系统字体)
     *  @param height 约束高度
     */
    func sizeWithFont(_ font: UIFont?, constrainedToHeight height: CGFloat) -> CGSize {

        var textFont: UIFont? = font
        if (font == nil) {
            textFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping

        let textSize = self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [NSAttributedString.Key.font : textFont!, NSAttributedString.Key.paragraphStyle : paragraph],
                                         context: nil).size

        return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
    }

    /**
     *  @brief  反转字符串
     *
     *  @param strSrc 被反转字符串
     *
     *  @return 反转后字符串
     */
    static func reverseString(_ strSrc: NSString) -> NSString {

        let reverseString = NSMutableString()
        var charIndex = strSrc.length
        
        while (charIndex > 0) {
            charIndex -= 1
            reverseString.append(strSrc.substring(with: NSRange(location: charIndex, length: 1)))
        }
        return reverseString
    }
    
}

extension String {
    /**
     *  @brief 计算文字的大小
     */
    func size(withFont font: UIFont, width: CGFloat = CGFloat.greatestFiniteMagnitude, height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        let attributes = self.attributes(withFont: font)
        var textSize = CGSize(width: width, height: height)
        textSize = self.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: attributes,
                                     context: nil).size
        return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
    }
    
    func attributedString(withFont font: UIFont) -> NSAttributedString {
        let attributes = self.attributes(withFont: font)
        let attribute = NSMutableAttributedString(string: self)
        attribute.addAttributes(attributes, range: NSRange(location: 0, length: self.count))
        return attribute
    }
    
    /**
     *  @brief 根据字体获取符合本项目的相关字体属性
     *
     *  @param font   字体
     */
    private func attributes(withFont font: UIFont) -> [NSAttributedString.Key : Any] {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = NSObject.lineHeight(withFont: font)
        style.lineBreakMode = .byWordWrapping
        return [NSAttributedString.Key.font : font,
                NSAttributedString.Key.paragraphStyle : style]

    }
}

extension UILabel {
    //自适应高
    func sizeToFitHeight() {
        let text = self.text ?? ""
        if !text.isEmpty {
            let textSize = text.size(withFont: self.font, width: self.width)
            self.frame.size.height = textSize.height
            self.attributedText = text.attributedString(withFont: self.font)
        }
    }
    //自适应宽
    func sizeToFitWidth() {
        let text = self.text ?? ""
        if !text.isEmpty {
            let textSize = text.size(withFont: self.font, height: self.height)
            self.frame.size.width = textSize.width
            self.attributedText = text.attributedString(withFont: self.font)
        }
    }
    //自适应大小
    open override func sizeToFit() {
        let text = self.text ?? ""
        if !text.isEmpty {
            self.frame.size = text.size(withFont: self.font, height: self.height)
            self.attributedText = text.attributedString(withFont: self.font)
        }
    }
}

extension UIFont {
    class func font(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: weight)
    }
}

extension NSObject {
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
        return lineSpace / 6
    }
}
