//
//  NSString+HSize.swift
//  HSwiftProject
//
//  Created by Wind on 25/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

extension NSString {
//    /**
//     *  @brief 计算文字的高度
//     *
//     *  @param font  字体(默认为系统字体)
//     *  @param width 约束宽度
//     */
//    func heightWithFont(_ font: UIFont?, constrainedToWidth width: CGFloat) -> CGFloat {
//
//        var textFont: UIFont? = font
//        if (font == nil) {
//            textFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
//        }
//
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.lineBreakMode = .byWordWrapping
//
//        let textSize = self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
//                                         options: .usesLineFragmentOrigin,
//                                         attributes: [NSAttributedString.Key.font : textFont!, NSAttributedString.Key.paragraphStyle : paragraph],
//                                         context: nil).size
//
//        return ceil(textSize.height)
//    }
//
//    /**
//     *  @brief 计算文字的宽度
//     *
//     *  @param font   字体(默认为系统字体)
//     *  @param height 约束高度
//     */
//    func widthWithFont(_ font: UIFont?, constrainedToHeight height: CGFloat) -> CGFloat {
//
//        var textFont: UIFont? = font
//        if (font == nil) {
//            textFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
//        }
//
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.lineBreakMode = .byWordWrapping
//
//        let textSize = self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height),
//                                         options: .usesLineFragmentOrigin,
//                                         attributes: [NSAttributedString.Key.font : textFont!, NSAttributedString.Key.paragraphStyle : paragraph],
//                                         context: nil).size
//
//        return ceil(textSize.width)
//    }
//
//    /**
//     *  @brief 计算文字的大小
//     *
//     *  @param font  字体(默认为系统字体)
//     *  @param width 约束宽度
//     */
//    func sizeWithFont(_ font: UIFont?, constrainedToWidth width: CGFloat) -> CGSize {
//
//        var textFont: UIFont? = font
//        if (font == nil) {
//            textFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
//        }
//
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.lineBreakMode = .byWordWrapping
//
//        let textSize = self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
//                                         options: .usesLineFragmentOrigin,
//                                         attributes: [NSAttributedString.Key.font : textFont!, NSAttributedString.Key.paragraphStyle : paragraph],
//                                         context: nil).size
//
//        return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
//    }
//
//    /**
//     *  @brief 计算文字的大小
//     *
//     *  @param font   字体(默认为系统字体)
//     *  @param height 约束高度
//     */
//    func sizeWithFont(_ font: UIFont?, constrainedToHeight height: CGFloat) -> CGSize {
//
//        var textFont: UIFont? = font
//        if (font == nil) {
//            textFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
//        }
//
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.lineBreakMode = .byWordWrapping
//
//        let textSize = self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height),
//                                         options: .usesLineFragmentOrigin,
//                                         attributes: [NSAttributedString.Key.font : textFont!, NSAttributedString.Key.paragraphStyle : paragraph],
//                                         context: nil).size
//
//        return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
//    }
//
//
    func size(_ make: (_ make: HStringAttributes) -> Void) -> CGSize {

        let stringAttributes = HStringAttributes()
        make(stringAttributes)

        let attributes = self.attributes(withFont: stringAttributes.font, lineSpace: stringAttributes.lineSpace)

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
    
    func attributes(withFont font: UIFont, lineSpace: CGFloat = 2.0) -> [NSAttributedString.Key : Any] {
        
        if font.fontName.contains("Regular") {
            
        }else if font.fontName.contains("Medium") {
            
        }
        
        // 字间距
        var fontSpace: CGFloat = 0.0

        switch (font.pointSize) {
        case 8:
            fontSpace = 1.5
            break
        case 9:
            fontSpace = 1.5
            break
        case 10:
            fontSpace = 1.5
            break
        case 11:
            fontSpace = 1.5
            break
        case 12:
            fontSpace = 1.5
            break
        case 13:
            fontSpace = 1.5
            break
        case 14:
            fontSpace = 1.5
            break
        case 15:
            fontSpace = 1.5
            break
        case 16:
            fontSpace = 1.5
            break
        case 17:
            fontSpace = 1.5
            break
        case 18:
            fontSpace = 1.5
            break
        default:
            break
        }
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpace
        style.lineBreakMode = .byWordWrapping
        
        return [NSAttributedString.Key.font : font,
                NSAttributedString.Key.kern : fontSpace,
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
    var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    //行间距
    var lineSpace: CGFloat = 0
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
