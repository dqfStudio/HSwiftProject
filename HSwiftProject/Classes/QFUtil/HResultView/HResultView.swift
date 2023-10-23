//
//  HResultView.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/9.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

enum HResultType: Int {
    case noData = 0 // 没有数据
    case loadError = 1 // 请求失败
    case noNetwork = 2 // 无网络
}

private var kResultImageSize = CGSize(width: 200, height: 140)
private var kResultTextSize = CGSize(width: 200, height: 25)
private var kResultDetlTextSize = CGSize(width: 200, height: 20)

class HResultView: UIView, HTupleViewDelegate {
    
    var make: HResultTransition? {
        didSet {
            if make != oldValue {
                self.wakeup()
            }
        }
    }
    
    lazy private var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: .zero)
        tupleView.disableBounce()
        return tupleView
    }()
    
    private func wakeup() {
        //添加view
        var height = kResultTextSize.height
        guard let make = make, make.hideImage else {
            height += kResultImageSize.height
            return
        }
        guard let detlDesc = make.detlDesc, detlDesc.count > 0 else {
            height += kResultDetlTextSize.height
            return
        }
        
        self.tupleView.frame = CGRect(x: 0, y: 0, width: kResultImageSize.width, height: height)
        self.tupleView.center = CGPoint(x: self.center.x, y: self.center.y - make.marginTop)
        
        self.tupleView.delegate = self
        self.addSubview(self.tupleView)
    }
    
    func numberOfSectionsInTupleView() -> Any {
//        if (![AFNetworkReachabilityManager sharedManager].isReachable) {
//            make.style = .noNetwork
//        }
        return 1
    }
    func numberOfItemsInSection(_ section: Any) -> Any {
        guard let make = make, let detlDesc = make.detlDesc, detlDesc.count > 0 else {
            return 2
        }
        return 1
    }
    func sizeForHeaderInSection(_ section: Any) -> Any {
        guard let make = make, !make.hideImage else {
            return kResultImageSize
        }
        return CGSize.zero
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0: return kResultTextSize
        case 1: return kResultDetlTextSize
        default:break
        }
        return CGSize.zero
    }

    func tupleHeader(_ headerBlock: Any, inSection section: Any) {
        let headerBlock = headerBlock as! HTupleHeader
        let cell = headerBlock(nil, HTupleButtonApex.self, nil, true) as! HTupleButtonApex
        cell.buttonView.backgroundColor = UIColor.white
        if let make = make {
            if let bgColor = make.bgColor {
                cell.buttonView.backgroundColor = bgColor
            }
            switch make.style {
            case .noData:
                cell.buttonView.setImage(WithName: "icon_load_nothing")
                break
            case .loadError:
                cell.buttonView.setImage(WithName: "loading_gif_white")
                break
            case .noNetwork:
                cell.buttonView.setImage(WithName: "loading_gif_lightGray")
                break
            }
        }
        cell.buttonView.pressed = { (sender, data) in
            if let make = self.make, let clickedBlock = make.clickedBlock {
                clickedBlock()
            }
        }
    }
    
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        
        let itemBlock = itemBlock as! HTupleItem
        
        switch (indexPath.row) {
        case 0:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            
            cell.label.backgroundColor = UIColor.white
            cell.label.font = .systemFont(ofSize: 14.0)
            cell.label.textColor = UIColor.black
            cell.label.textAlignment = .center
            
            if let make = make {
                if let bgColor = make.bgColor {
                    cell.label.backgroundColor = bgColor
                }
                if let descFont = make.descFont {
                    cell.label.font = descFont
                }
                if let descColor = make.descColor {
                    cell.label.textColor = descColor
                }
                if let desc = make.desc, desc.count > 0 {
                    cell.label.text = desc
                }else {
                    switch (make.style) {
                    case .noData:
                        cell.label.text = "这里好像什么都没有呢⋯"
                        break
                    case .loadError:
                        cell.label.text = "服务器开小差了，请稍后再试~"
                        break
                    case .noNetwork:
                        cell.label.text = "网络已断开"
                        break
                    }
                }
                
            }
            break
        case 1:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            
            cell.label.backgroundColor = UIColor.white
            cell.label.font = .systemFont(ofSize: 14.0)
            cell.label.textColor = UIColor.black
            cell.label.textAlignment = .center
            
            if let make = make {
                if let bgColor = make.bgColor {
                    cell.label.backgroundColor = bgColor
                }
                if let detlDescFont = make.detlDescFont {
                    cell.label.font = detlDescFont
                }
                if let detlDescColor = make.detlDescColor {
                    cell.label.textColor = detlDescColor
                }
                if let detlDesc = make.detlDesc, detlDesc.count > 0 {
                    cell.label.text = detlDesc
                }
            }
            break
            
        default:
            break
        }
    }
    
    func didSelectItemAtIndexPath(_ indexPath: IndexPath) {
        if let make = make, let clickedBlock = make.clickedBlock {
            clickedBlock()
        }
    }
}
