//
//  HResultView.swift
//  HSwiftProject
//
//  Created by owner on 2023/3/9.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

enum HResultType: Int {
    case noData = 0 // 没有数据
    case loadError = 1 // 请求失败
    case noNetwork = 2 // 无网络
}

private var KResultImageSize = CGSize(width: 200, height: 140)
private var KResultTextSize = CGSize(width: 200, height: 25)
private var KResultDetlTextSize = CGSize(width: 200, height: 20)

class HResultView: UIView, HTupleViewDelegate {
    
    private var _make: HResultTransition?
    var make: HResultTransition? {
        get {
            return _make
        }
        set {
            if _make != newValue {
                _make = nil
                _make = newValue
                self.wakeup()
            }
        }
    }
    
    lazy private var tupleView: HTupleView = {
        let _tupleView = HTupleView(frame: CGRect.zero)
        _tupleView.bounceDisenable()
        _tupleView.delegate = self
        self.addSubview(_tupleView)
        return _tupleView
    }()
    
    private func wakeup() {
        //添加view
        var height = KResultTextSize.height
        guard _make != nil, _make!.hideImage else {
            height += KResultImageSize.height
            return
        }
        guard _make != nil, _make!.detlDesc != nil, _make!.detlDesc!.length > 0 else {
            height += KResultDetlTextSize.height
            return
        }
        
        let frame = CGRect(x: 0, y: 0, width: KResultImageSize.width, height: height)
        self.tupleView.frame = frame
        self.tupleView.center = CGPoint(x: self.center.x, y: self.center.y - (_make?.marginTop ?? 0))
        
        self.tupleView.reloadData()
    }
    
    func numberOfSectionsInTupleView() -> Any {
//        if (![AFNetworkReachabilityManager sharedManager].isReachable) {
//            _make.style = HResultType.noNetwork
//        }
        return 1
    }
    func numberOfItemsInSection(_ section: Any) -> Any {
        if _make != nil, _make!.detlDesc != nil, _make!.detlDesc!.length > 0 {
            return 2
        }
        return 1
    }
    func sizeForHeaderInSection(_ section: Any) -> Any {
        if _make != nil, _make!.hideImage == false {
            return KResultImageSize
        }
        return CGSize.zero
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0: return KResultTextSize
        case 1: return KResultDetlTextSize
        default:break
        }
        return CGSize.zero
    }

    func tupleHeader(_ headerBlock: Any, inSection section: Any) {
        let headerBlock = headerBlock as! HTupleHeader
        let cell = headerBlock(nil, HTupleImageApex.self, nil, true) as! HTupleImageApex
        cell.imageView.backgroundColor = UIColor.white
        if _make != nil, _make!.bgColor != nil {
            cell.imageView.backgroundColor = _make!.bgColor!
        }
        switch _make?.style {
        case .noData:
            cell.imageView.image = UIImage(named: "icon_load_nothing")
            break
        case .loadError:
            cell.imageView.image = UIImage(named: "loading_gif_white")
            break
        case .noNetwork:
            cell.imageView.image = UIImage(named: "loading_gif_lightGray")
            break
        default:
            break
        }
        cell.imageView.pressed = { (_ sender: Any?, _ data: Any?) in
            if self._make != nil, self._make!.clickedBlock != nil {
                self._make!.clickedBlock!()
            }
        }
    }
    
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        
        let itemBlock = itemBlock as! HTupleItem
        
        switch (indexPath.row) {
        case 0:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            
            cell.label.backgroundColor = UIColor.white
            cell.label.textColor = UIColor.black
            cell.label.font = UIFont.systemFont(ofSize: 14)
            cell.label.textAlignment  = .center
            if _make != nil, _make!.bgColor != nil {
                cell.label.backgroundColor = _make!.bgColor!
            }
            if _make != nil, _make!.descFont != nil {
                cell.label.font = _make!.descFont!
            }
            if _make != nil, _make!.descColor != nil {
                cell.label.textColor = _make!.descColor!
            }
            if _make != nil, _make!.desc != nil, _make!.desc!.length > 0 {
                cell.label.text = _make!.desc!
            }else {
                switch (_make?.style) {
                case .noData:
                    cell.label.text = "这里好像什么都没有呢⋯"
                    break
                case .loadError:
                    cell.label.text = "服务器开小差了，请稍后再试~"
                    break
                case .noNetwork:
                    cell.label.text = "网络已断开"
                    break
                default:
                    break
                }
            }
            break
        case 1:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            
            cell.label.backgroundColor = UIColor.white
            cell.label.textColor = UIColor.black
            cell.label.font = UIFont.systemFont(ofSize: 14)
            cell.label.textAlignment  = .center
            if _make != nil, _make!.bgColor != nil {
                cell.label.backgroundColor = _make!.bgColor!
            }
            if _make != nil, _make!.detlDescFont != nil {
                cell.label.font = _make!.detlDescFont!
            }
            if _make != nil, _make!.detlDescColor != nil {
                cell.label.textColor = _make!.detlDescColor!
            }
            if _make != nil, _make!.detlDesc != nil, _make!.detlDesc!.length > 0 {
                cell.label.text = _make!.detlDesc!
            }
            break
            
        default:
            break
        }
    }
    
    func didSelectItemAtIndexPath(_ indexPath: IndexPath) {
        if _make != nil, _make!.clickedBlock != nil {
            _make!.clickedBlock!()
        }
    }
}
