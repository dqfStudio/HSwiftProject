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

class HFormCell: HTupleTmplCell, HTupleViewDelegate {
    
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
        let tupleView = HTupleView.tupleFrame {
            return self.bounds
        } mode: {
            return .delegate
        } layout: {
            return HTupleViewLayout(.horizontal, .manual)
        }
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
    
    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {        
        let index = indexPath.section * self.rows * self.rowItems + indexPath.row
        if let modelArr = self.modelArr, index < modelArr.count {
            let cell = tuple.reuseCell(HTupleButtonCell.self, nil, true, indexPath) as! HTupleButtonCell
            cell.buttonView.textColor = .black
            
            let model = modelArr[index]
            
            if let icon = model.icon {
                cell.buttonView.setImage(WithName: icon)
            }
            cell.buttonView.text = model.title
            
            cell.buttonView.pressed = { (sender, data) in
                self.formCellBlock?(indexPath, model)
            }
        }else {
            _ = tuple.reuseCell(HTupleTmplCell.self, nil, true, indexPath) as! HTupleTmplCell
        }
    }
    
}
