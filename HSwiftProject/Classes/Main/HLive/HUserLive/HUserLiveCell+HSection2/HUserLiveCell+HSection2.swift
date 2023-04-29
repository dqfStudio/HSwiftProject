//
//  HUserLiveCell+HSection2.swift
//  HSwiftProject
//
//  Created by Wind on 20/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

class HUserLiveBottomBarView : UIView, HTupleViewDelegate {

    private var _tupleView: HTupleView?
    var tupleView: HTupleView {
        if (_tupleView == nil) {
            _tupleView = HTupleView(frame: self.bounds, scrollDirection: .horizontal)
            _tupleView!.backgroundColor = UIColor.clear
            _tupleView!.disableBounce()
        }
        return _tupleView!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tupleView.delegate = self
        self.addSubview(self.tupleView)
        //设置tupleView release key
        self.tupleView.releaseTupleKey = KLiveRoomReleaseTupleKey
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    func numberOfItemsInSection(_ section: Any) -> Any {
        return 5
    }
    func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        case 1:
            return UIEdgeInsetsZero
        case 2:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        case 3:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        case 4:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        default:
            break
        }
        return UIEdgeInsetsZero
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0:
            return CGSize(width: self.tupleView.height, height: self.tupleView.height)
        case 1:
            return CGSize(width: self.tupleView.width - 20 - self.tupleView.height * 4, height: self.tupleView.height)
        case 2:
            return CGSize(width: self.tupleView.height, height: self.tupleView.height)
        case 3:
            return CGSize(width: self.tupleView.height, height: self.tupleView.height)
        case 4:
            return CGSize(width: self.tupleView.height, height: self.tupleView.height)
        default:
            break
        }
        return CGSize(width: self.tupleView.width, height: self.tupleView.height)
    }
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        switch (indexPath.row) {
        case 0:
            let cell = itemBlock(nil, HTupleButtonCell.self, nil, true) as! HTupleButtonCell
            cell.buttonView.backgroundColor = UIColor.red
//                cell.buttonView.cornerRadius = cell.buttonView.height / 2
            cell.buttonView.cornerRadius = cell.layoutViewFrame.height / 2
            cell.buttonView.setImageWithName("icon_no_server")
//                cell.buttonView setFillet:YES]
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                NotificationCenter.default.post(name: NSNotification.Name(KShowKeyboardNotify), object: nil)
            }
            break
        case 1:
            _ = itemBlock(nil, HTupleBlankCell.self, nil, true)
            break
        case 2:
            let cell = itemBlock(nil, HTupleButtonCell.self, nil, true) as! HTupleButtonCell
            cell.buttonView.backgroundColor = UIColor.red
//                cell.buttonView.cornerRadius = cell.buttonView.height / 2
            cell.buttonView.cornerRadius = cell.layoutViewFrame.height / 2
            cell.buttonView.setImageWithName("icon_no_server")
//                cell.buttonView setFillet:YES]
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                self.viewController?.presentController(HUserLiveNoteVC(), completion: { transitionType in
                    NSLog("")
                })
            }
            break
        case 3:
            let cell = itemBlock(nil, HTupleButtonCell.self, nil, true) as! HTupleButtonCell
            cell.buttonView.backgroundColor = UIColor.red
//                cell.buttonView.cornerRadius = cell.buttonView.height / 2
            cell.buttonView.cornerRadius = cell.layoutViewFrame.height / 2
            cell.buttonView.setImageWithName("icon_no_server")
//                [cell.buttonView setFillet:YES]
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                self.viewController?.presentController(HUserLiveShareVC(), completion: { transitionType in
                    NSLog("")
                })
            }
            break
        case 4:
            let cell = itemBlock(nil, HTupleButtonCell.self, nil, true) as! HTupleButtonCell
            cell.buttonView.backgroundColor = UIColor.red
//                cell.buttonView.cornerRadius = cell.buttonView.height / 2
            cell.buttonView.cornerRadius = cell.layoutViewFrame.height / 2
            cell.buttonView.text = "✕"
            cell.buttonView.textColor = UIColor.white
            cell.buttonView.textFont = UIFont.systemFont(ofSize: 17)
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                self.viewController?.dismiss(animated: true, completion: nil)
            }
            break
        default:
            break
        }
    }
}

extension HUserLiveCell {
    @objc
    func tupleExa2_numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    @objc
    func tupleExa2_sizeForFooterInSection(_ section: Any) -> Any {
        return CGSize(width: self.liveRightView.width, height: UIScreen.bottomBarHeight + 5)
    }
    @objc
    func tupleExa2_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.liveRightView.width, height: 40)
    }
    @objc
    func tupleExa2_tupleFooter(_ footerBlock: Any, inSection section: Any) {
        let footerBlock = footerBlock as! HTupleFooter
        let cell = footerBlock(nil, HTupleBaseApex.self, nil, true) as! HTupleBaseApex
        cell.backgroundColor = UIColor.clear
    }
    @objc
    func tupleExa2_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
        
        var bottomBarView = cell.viewWithTag(123456) as? HUserLiveBottomBarView
        if (bottomBarView == nil) {
            bottomBarView = HUserLiveBottomBarView(frame: cell.bounds)
            bottomBarView!.tag = 123456
            cell.addSubview(bottomBarView!)
        }
    }
}
