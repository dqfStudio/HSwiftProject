//
//  HCollAlertVC+Extern.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/18.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

extension HCollAlertVC {
    // 注销账号
    @discardableResult
    static func showCancelAccountAlert(completion: @escaping (_ actionStyle: Int) -> Void) -> HCollAlertVC {
        let message = "Freechat团队将在15天内处理你的申请并删除你的所有数据，在15天内，如果重新登录Freechat，您的注销账号申请将被撤销。".localized()
        let messageFont = UIFont.font(ofSize: 15, weight: .regular)
        let messageHeight = message.heightWithFont(messageFont, constrainedToWidth: kCollAlertWidth - 48) + 48.5
        
        let alertVC = HCollAlertVC()
        alertVC.numberBlock = {
            return 2
        }
        alertVC.heightBlock = { index in
            if index == 0 {
                return messageHeight
            }
            return 48
        }
        alertVC.itemBlock = { (coll: HCollView, indexPath: IndexPath) in
            let cell = coll.reuseCell(HCollLabelCell.self, true, indexPath) as! HCollLabelCell
            cell.edgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
            if indexPath.row == 0 {
                //cell.setBottomLine(withColor: UIColor.border2, lineHeight: 0.5)
                cell.label.font = messageFont
                cell.label.numberOfLines = 0
                cell.label.textAlignment = .center
                cell.label.textColor = UIColor.white
                cell.label.text = message
            }else {
                cell.label.font = UIFont.font(ofSize: 17, weight: .medium)
                cell.label.textAlignment = .center
                cell.label.numberOfLines = 0
                cell.label.textColor = UIColor.white
                cell.label.text = "完成并登出Freechat".localized()
                cell.selectBlock = {
                    alertVC.naviBack()
                    completion(indexPath.row)
                }
            }
        }
        return alertVC
    }
    // 删除印象评论
    @discardableResult
    static func showDelImpreMentAlert(completion: @escaping (_ actionStyle: Int) -> Void) -> HCollAlertVC {
        let message = "确定要删除该印象评论吗？".localized()
        let messageFont = UIFont.font(ofSize: 17, weight: .medium)
        let messageHeight = message.heightWithFont(messageFont, constrainedToWidth: kCollAlertWidth - 48) + 80.5
        
        let alertVC = HCollAlertVC()
        alertVC.numberBlock = {
            return 2
        }
        alertVC.heightBlock = { index in
            if index == 0 {
                return messageHeight
            }
            return 48
        }
        alertVC.itemBlock = { (coll: HCollView, indexPath: IndexPath) in
            if indexPath.row == 0 {
                let cell = coll.reuseCell(HCollLabelCell.self, true, indexPath) as! HCollLabelCell
                cell.edgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
                //cell.setBottomLine(withColor: UIColor.border2, lineHeight: 0.5)
                cell.label.font = messageFont
                cell.label.numberOfLines = 0
                cell.label.textAlignment = .center
                cell.label.textColor = UIColor.white
                cell.label.text = message
            }else {
                let cell = coll.reuseCell(HCollFreeCell.self, true, indexPath) as! HCollFreeCell
                let frame = cell.layoutViewBounds
                let halfWidth = frame.width / 2
                
                cell.buttonView.frame = CGRect(x: 0, y: 0, width: halfWidth, height: frame.height)
                cell.buttonView.textFont = UIFont.font(ofSize: 17, weight: .medium)
                cell.buttonView.textColor = UIColor.white
                cell.buttonView.text = "取消".localized()
                cell.buttonView.pressed = { (sender, data) in
                    alertVC.naviBack()
                }
                
                cell.label.frame = CGRect(x: halfWidth - 0.5, y: 0, width: 0.5, height: frame.height)
                //cell.label.backgroundColor = UIColor.border2
                
                cell.detailButton.frame = CGRect(x: halfWidth, y: 0, width: halfWidth, height: frame.height)
                cell.detailButton.textFont = UIFont.font(ofSize: 17, weight: .medium)
                cell.detailButton.textColor = UIColor.white
                cell.detailButton.text = "确定".localized()
                cell.detailButton.pressed = { (sender, data) in
                    alertVC.naviBack()
                    completion(indexPath.row)
                }
            }
        }
        return alertVC
    }
    // 密码错误重试
    @discardableResult
    static func showRePassErrorAlert(completion: @escaping (_ actionStyle: Int) -> Void) -> HCollAlertVC {
        let message = "旧密码错误，请重试".localized()
        let messageFont = UIFont.font(ofSize: 17, weight: .medium)
        let messageHeight = message.heightWithFont(messageFont, constrainedToWidth: kCollAlertWidth - 48) + 80.5
        
        let alertVC = HCollAlertVC()
        alertVC.numberBlock = {
            return 2
        }
        alertVC.heightBlock = { index in
            if index == 0 {
                return messageHeight
            }
            return 48
        }
        alertVC.itemBlock = { (coll: HCollView, indexPath: IndexPath) in
            if indexPath.row == 0 {
                let cell = coll.reuseCell(HCollLabelCell.self, true, indexPath) as! HCollLabelCell
                cell.edgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
                //cell.setBottomLine(withColor: UIColor.border2, lineHeight: 0.5)
                cell.label.font = messageFont
                cell.label.numberOfLines = 0
                cell.label.textAlignment = .center
                cell.label.textColor = UIColor.white
                cell.label.text = message
            }else {
                let cell = coll.reuseCell(HCollFreeCell.self, true, indexPath) as! HCollFreeCell
                let frame = cell.layoutViewBounds
                let halfWidth = frame.width / 2
                
                cell.buttonView.frame = CGRect(x: 0, y: 0, width: halfWidth, height: frame.height)
                cell.buttonView.textFont = UIFont.font(ofSize: 17, weight: .medium)
                cell.buttonView.textColor = UIColor.white
                cell.buttonView.text = "忘记密码".localized()
                cell.buttonView.pressed = { (sender, data) in
                    alertVC.naviBack()
                    completion(indexPath.row)
                }
                
                cell.label.frame = CGRect(x: halfWidth - 0.5, y: 0, width: 0.5, height: frame.height)
                //cell.label.backgroundColor = UIColor.border2
                
                cell.detailButton.frame = CGRect(x: halfWidth, y: 0, width: halfWidth, height: frame.height)
                cell.detailButton.textFont = UIFont.font(ofSize: 17, weight: .medium)
                cell.detailButton.textColor = UIColor.white
                cell.detailButton.text = "去重试".localized()
                cell.detailButton.pressed = { (sender, data) in
                    alertVC.naviBack()
                }
            }
        }
        return alertVC
    }
    
    // 仿原生alert通用
    class func showAlert(message: String,
                         confirmTitle: String? = "确定".localized(),
                         cancelTitle: String? = "取消".localized(),
                         completion: @escaping (_ actionStyle: Int) -> Void) {
        
        let alertVC = HCollAlertVC()
        alertVC.numberBlock = {
            return 2
        }
        alertVC.heightBlock = { index in
            if index == 0 {
                return message.heightWithFont(UIFont.font(ofSize: 17, weight: .medium), 
                                              constrainedToWidth: kCollAlertWidth - 48) + 80.5
            }
            return 48
        }
        alertVC.itemBlock = { [weak alertVC] (coll, indexPath) in
            guard let alertVC = alertVC else { return }
            if indexPath.row == 0 {
                let cell = coll.reuseCell(HCollLabelCell.self, true, indexPath) as! HCollLabelCell
                cell.edgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
                //cell.setBottomLine(withColor: UIColor.border2, lineHeight: 0.5)
                cell.label.font = UIFont.font(ofSize: 17, weight: .medium)
                cell.label.numberOfLines = 0
                cell.label.textAlignment = .center
                cell.label.textColor = UIColor.white
                cell.label.text = message
            }else {
                let cell = coll.reuseCell(HCollFreeCell.self, true, indexPath) as! HCollFreeCell
                let frame = cell.layoutViewBounds
                let halfWidth = cell.layoutViewBounds.width / 2
                
                cell.buttonView.frame = CGRect(x: 0, y: 0, width: halfWidth, height: frame.height)
                cell.buttonView.textFont = UIFont.font(ofSize: 17, weight: .medium)
                cell.buttonView.textColor = UIColor.white
                cell.buttonView.text = cancelTitle
                cell.buttonView.pressed = { [weak alertVC] (sender, data) in
                    guard let alertVC = alertVC else { return }
                    alertVC.naviBack()
                }
                
                cell.label.frame = CGRect(x: halfWidth - 0.5, y: 0, width: 0.5, height: frame.height)
                //cell.label.backgroundColor = UIColor.border2
                
                cell.detailButton.frame = CGRect(x: halfWidth, y: 0, width: halfWidth, height: frame.height)
                cell.detailButton.textFont = UIFont.font(ofSize: 17, weight: .medium)
                cell.detailButton.textColor = UIColor.white
                cell.detailButton.text = confirmTitle
                cell.detailButton.pressed = { [weak alertVC] (sender, data) in
                    guard let alertVC = alertVC else { return }
                    alertVC.naviBack()
                    completion(indexPath.row)
                }
            }
        }
        UIApplication.naviTop?.presentController(alertVC, completion: nil)
    }
}
