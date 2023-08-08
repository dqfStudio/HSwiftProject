//
//  HPostCell.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/8.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HPostCell: HTupleBaseCell, HTupleViewDelegate {
    
    lazy var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: self.bounds)
        tupleView.isScrollEnabled = false
        tupleView.disableBounce()
        return tupleView
    }()
    
    //cell初始化是调用的方法
    override func initUI() {
        super.initUI()
        self.tupleView.delegate = self
        self.addSubview(self.tupleView)
    }
    
    //用于子类更新子视图布局
    override func relayoutSubviews() {
        HLayoutTupleCell(self.tupleView)
    }

    func numberOfItemsInSection(_ section: Any) -> Any {
        return 3
    }
    
    func insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func minimumLineSpacingForSectionAt(_ section: Any) -> Any {
        return 8
    }
    
    func minimumInteritemSpacingForSectionAt(_ section: Any) -> Any {
        return 8
    }
    
    func sizeForHeaderInSection(_ section: Any) -> Any {
        return CGRect.zero
    }
    
    func sizeForFooterInSection(_ section: Any) -> Any {
        return CGRect.zero
    }
    
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0:
            return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: 48)
        case 1:
            return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: 30)
        case 2:
            return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: 20)
        default:
            break
        }
        return CGSize(width: self.tupleView.width, height: self.tupleView.height)
    }
    
    func tupleHeader(_ headerBlock: Any, inSection section: Any) {
        let headerBlock = headerBlock as! HTupleHeader
        let cell = headerBlock(nil, HTupleBaseApex.self, nil, false) as! HTupleBaseApex
        let frame = cell.layoutViewBounds
        
        var headerView = cell.layoutView.viewWithTag(121314) as? HPostHeaderView
        if headerView == nil {
            headerView = HPostHeaderView(frame: frame)
            headerView!.tag = 121314
            headerView!.avatarButton.pressed = { (sender, data) in

            }
            cell.layoutView.addSubview(headerView!)
        }
    }
    
    func tupleFooter(_ footerBlock: Any, inSection section: Any) {
        let footerBlock = footerBlock as! HTupleFooter
        let cell = footerBlock(nil, HTupleBaseApex.self, nil, true) as! HTupleBaseApex
        let frame = cell.layoutViewBounds
        
        var footerView = cell.layoutView.viewWithTag(131415) as? HPostFooterView
        if footerView == nil {
            footerView = HPostFooterView(frame: frame)
            footerView!.tag = 131415
            footerView!.likeButton.pressed = { (sender, data) in
                
            }
            
            footerView!.commentButton.pressed = { (sender, data) in
                
            }
            
            footerView!.shareButton.pressed = { (sender, data) in
                
            }
            
            footerView!.moreButton.pressed = { (sender, data) in
                
            }
            cell.layoutView.addSubview(footerView!)
        }
    }
    
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
        let frame = cell.layoutViewBounds

        cell.label.frame = CGRect(x: cell.imageView.maxX + 4, y: 0, width: 100, height: frame.height)

        cell.label.textColor = .black
        cell.label.font = UIFont.font(ofSize: 12.0, weight: .regular)
    }
}
