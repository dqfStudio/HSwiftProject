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
     *  @brief 计算文字的大小
     *
     *  @param make   设置HStringAttributes属性，font不能为ni
     */
    func size(_ make: (_ make: HStringAttributes) -> Void) -> CGSize {

        let stringAttributes = HStringAttributes()
        make(stringAttributes)
        
        if stringAttributes.font != nil {
            let attributes = self.attributes(withFont: stringAttributes.font!)

            var textSize = CGSize.zero
            if stringAttributes.width > 0 {
                textSize = CGSize(width: stringAttributes.width, height: CGFloat.greatestFiniteMagnitude)
            }else {
                textSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: stringAttributes.height)
            }

            textSize = self.boundingRect(with: textSize,
                                         options: .usesLineFragmentOrigin,
                                         attributes: attributes,
                                         context: nil).size
            return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
        }
        return CGSize.zero
    }
    
    /**
     *  @brief 根据字体获取符合本项目的相关字体属性
     *
     *  @param font   字体
     */
    private func attributes(withFont font: UIFont) -> [NSAttributedString.Key : Any] {

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
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpace
        style.lineBreakMode = .byWordWrapping
        
        return [NSAttributedString.Key.font : font,
                NSAttributedString.Key.paragraphStyle : style]

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

class HStringAttributes: NSObject {
    //字体
    var font: UIFont?
    //预设的固定宽度
    var width: CGFloat = 0
    //预设的固定高度
    var height: CGFloat = 0
}

extension UIFont {
    class func font(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: weight)
    }
}
