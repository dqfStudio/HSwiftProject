//
//  HAlertFormatter.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/9.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

typealias HAlertClickedBlock = ( ) -> Void
typealias HAlertButtonBlock = (_ buttonIndex: NSInteger ) -> NSInteger

class HWaitingTransition: NSObject {

    //0为black，1为white，2为gray
    var style: HWaitingType  = .gray //设置展示样式
    var bgColor: UIColor? //设置背景颜色
    var marginTop: CGFloat = 0 //设置marginTop的值

    var desc: String? //设置第一行文字
    var descFont: UIFont? //设置第一行文字字体
    var descColor: UIColor? //设置第一行文字颜色
}

class HResultTransition: NSObject {
    
    //0为noData，1为loadError，2为noNetwork
    var style: HResultType = .noData //设置展示样式
    var bgColor: UIColor? //设置背景颜色
    var marginTop: CGFloat = 0 //设置marginTop的值
    
    var hideImage: Bool = false //是否展示图片，默认展示图片
    
    var desc: String? //设置第一行文字，有默认值
    var descFont: UIFont? //设置第一行文字字体
    var descColor: UIColor? //设置第一行文字颜色
    
    var detlDesc: String? //设置第二行文字
    var detlDescFont: UIFont? //设置第二行文字字体
    var detlDescColor: UIColor? //设置第二行文字颜色
    
    var clickedBlock: HAlertClickedBlock? //设置点击事件
}

class HToastTransition: NSObject {
    var desc: String?
    var delay: TimeInterval = 2 //默认为2秒
    var inView: UIView? = UIApplication.shared.keyWindow //add view to，默认为UIWindow
}
