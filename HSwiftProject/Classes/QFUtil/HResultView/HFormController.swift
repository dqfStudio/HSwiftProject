//
//  HFormController.swift
//  HSwiftProject
//
//  Created by owner on 2023/3/16.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

private var KItemHeight: CGFloat = 80
private var KFooterHeight: CGFloat = 50

class HFormController: NSObject, HTupleViewDelegate {
    
    static func formControllerWithModel(_ models: [HFormModel], numberOfRows: Int, rowItems: Int, buttonBlock: HFormCellBlock) -> HFormController {
        let formController = HFormController()
        formController.sourceArr = models
        formController.numberOfRows = numberOfRows
        formController.rowItems = rowItems
        formController.setup()
        return formController
    }
    
    lazy private var tupleView: HTupleView = {
        let frame = UIScreen.main.bounds
        let _tupleView = HTupleView(frame: frame)
        _tupleView.bounceDisenable()
        _tupleView.tupleDelegate = self
        return _tupleView
    }()
    
    private var numberOfRows: Int = 0
    private var rowItems: Int = 0
    private var sourceArr: [HFormModel]?
    private var cellBlock: HFormCellBlock?
    
    private func setup() {
        //添加view
        let window = UIApplication.shared.delegate?.window as? UIWindow
        window?.addSubview(self.tupleView)
    }
    
    func numberOfSectionsInTupleView() -> Any {
        return 1
    }
    func numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    
    func sizeForHeaderInSection(_ section: Any) -> Any {
        var height = KFooterHeight
        if UIScreen.isIPhoneX {
            height += UIScreen.bottomBarHeight
        }
        return CGSize(width: self.tupleView.width, height: self.tupleView.height - KItemHeight * CGFloat(self.numberOfRows) - height)
    }
    func sizeForFooterInSection(_ section: Any) -> Any {
        var height = KFooterHeight
        if UIScreen.isIPhoneX {
            height += UIScreen.bottomBarHeight
        }
        return CGSize(width: self.tupleView.width, height: height)
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width, height: KItemHeight * CGFloat(self.numberOfRows))
    }
    
    func edgeInsetsForFooterInSection(_ section: Any) -> Any {
        var height: CGFloat = 0
        if UIScreen.isIPhoneX {
            height += UIScreen.bottomBarHeight
        }
        return UIEdgeInsets(top: 10, left: 0, bottom: height, right: 0)
    }
    
    func tupleHeader(_ headerBlock: Any, inSection section: Any) {
        _ = headerBlock as! HTupleItem
//        let headerBlock = headerBlock as! HTupleItem
//        let cell = itemBlock(nil, HTupleButtonApex.self, nil, true) as! HTupleButtonApex
//        cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
//            //销毁对象
//            self.destroy()
//        }
    }
    func tupleFooter(_ footerBlock: Any, inSection section: Any) {
        let footerBlock = footerBlock as! HTupleFooter
        let cell = footerBlock(nil, HTupleButtonApex.self, nil, true) as! HTupleButtonApex
        cell.buttonView.backgroundColor = UIColor.white
        cell.buttonView.textColor = UIColor.black
        cell.buttonView.text = "取消"
        cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
            //销毁对象
            self.destroy()
        }
    }
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HFormCell.self, nil, true) as! HFormCell
        cell.modelArr = self.sourceArr
        
        //配置参数
        cell.rows = self.numberOfRows
        cell.rowItems = self.rowItems
        
        cell.formCellBlock = { (_ idxPath: IndexPath, _ model: HFormModel) in
            if self.cellBlock != nil {
                self.cellBlock!(indexPath, model)
            }
        }
    }
    
    //销毁对象
    private func destroy() {
        //弹框消失
        self.tupleView.removeFromSuperview()
    }
    
}
