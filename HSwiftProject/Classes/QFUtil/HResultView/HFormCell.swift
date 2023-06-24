//
//  HFormCell.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/16.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

typealias HFormCellBlock = (_ idxPath: IndexPath, _ model: HFormModel) -> Void

class HFormModel: NSObject {
    var title: String?
    var icon: String?
    
    static func modelWithTitle(_ title: String, icon: String) -> HFormModel {
        let model = HFormModel()
        model.title = title
        model.icon  = icon
        return model
    }
}

class HFormCell: HTupleBaseCell, HTupleViewDelegate {
    
    var modelArr: [HFormModel]? {
        didSet {
            if modelArr != oldValue {
                self.tupleView.reloadData()
            }
        }
    }
    
    var rows: Int = 1 //显示几排，默认为1.
    var rowItems: Int = 4 //每排显示几个，默认为4.
    var formCellBlock: HFormCellBlock?
    
    lazy private var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: self.bounds, scrollDirection: .horizontal)
        tupleView.backgroundColor = .white
        tupleView.isPagingEnabled = true
        tupleView.delegate = self
        // 设置默认参数
        self.setup()
        self.addSubview(tupleView)
        return tupleView
    }()
    
    override func relayoutSubviews() {
        HLayoutTupleCell(self.tupleView)
    }
    
    private func setup() {
        self.rows = 1
        self.rowItems = 4
    }
    
    func numberOfSectionsInTupleView() -> Any {
        var pages = 1
        if let modelArr = self.modelArr {
            
            let items = modelArr.count
            var tmpItems = self.rows * self.rowItems
            
            pages = items / tmpItems
            tmpItems = pages * tmpItems
            
            if tmpItems != items {
                pages += 1
            }
        }
        return pages
    }
    
    func numberOfItemsInSection(_ section: Any) -> Any {
        return self.rows * self.rowItems
    }
    
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: Int(self.tupleView.width) / self.rowItems - 1, height: Int(self.tupleView.height) / self.rows - 1)
    }
    
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let index = indexPath.section * self.rows * self.rowItems + indexPath.row
        if let modelArr = self.modelArr, index < modelArr.count {
            let cell = itemBlock(nil, HTupleButtonCell.self, nil, true) as! HTupleButtonCell
            cell.buttonView.textColor = .black
            
            let model = modelArr[index]
            
            cell.buttonView.setImage(WithName: model.icon!)
            cell.buttonView.text = model.title
            
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                self.formCellBlock?(indexPath, model)
            }
        }else {
            _ = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
        }
    }
    
}
