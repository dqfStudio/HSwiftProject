//
//  HTransitionHeader.swift
//  HSwiftProject
//
//  Created by Wind on 22/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import Foundation

/*
 * 弹出框的类型
 */
@objc
enum HTransitionStyle: Int {
    case drop = -1 //顶部弹出
    case alert = 0 //中间弹出
    case sheet = 1 //底部弹出
}

/*
 * 转场动画类型（push、pop、present、dismiss)
 */
@objc
enum HTransitionType: Int {
    case push = 0    //push
    case pop = 1     //push
    case present = 2 //present
    case dismiss = 3 //dismiss
}

/*
 * push动画类型
 */
@objc
enum HPushAnimationType: Int {
    case ocdoor = 0 //开关门动画
}

/*
 * 弹出动画结束后回调
 */
typealias HTransitionCompletion = (_ transitionType: HTransitionType?) -> Void
