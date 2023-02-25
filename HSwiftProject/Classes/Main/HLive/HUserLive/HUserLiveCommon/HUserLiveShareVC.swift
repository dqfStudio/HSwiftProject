//
//  HUserLiveShareVC.swift
//  HSwiftProject
//
//  Created by Wind on 25/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

private let KItemHeight   = 80.0
private let KFooterHeight = 50.0

class HUserLiveShareVC : HViewController, HTupleViewDelegate {

    private var _visualView: UIVisualEffectView?
    private var visualView: UIVisualEffectView? {
        if (_visualView == nil) {
            let blur = UIBlurEffect.init(style: .extraLight)
            _visualView = UIVisualEffectView.init(effect: blur)
            var frame = CGRectZero
            frame.size = self.containerSize
            _visualView!.frame = frame
        }
        return _visualView!
    }
    
    private var _tupleView: HTupleView?
    private var tupleView: HTupleView {
        if (_tupleView == nil) {
            var frame = CGRectZero
            frame.size = self.containerSize
            _tupleView = HTupleView.init(frame: frame)
            _tupleView!.backgroundColor = UIColor.clear
            _tupleView!.layer.cornerRadius = 3.0;//默认系统弹框圆角为10.f
            _tupleView!.bounceDisenable()
        }
        return _tupleView!
    }
    
    private var rowItems: Int = 0

    override var containerSize: CGSize {
        return CGSizeMake(UIScreen.width, KItemHeight*2+KFooterHeight+UIScreen.bottomBarHeight)
    }

    override var presetType: HTransitionStyle {
        return .sheet
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.topBar.isHidden = true
        if (self.hideVisualView) {
            self.tupleView.backgroundColor = UIColor.white
            self.view.addSubview(self.tupleView)
        }else {
            self.visualView!.contentView.addSubview(self.tupleView)
            self.view.addSubview(self.visualView!)
        }
        self.tupleView.delegate = self
        self.rowItems = 5
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == HVCDisappearType.pop || type == HVCDisappearType.dismiss {
            self.tupleView.releaseTupleBlock()
            self._visualView = nil;
        }
    }

    override var hideVisualView: Bool {
        return true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (!self.hideVisualView) {
            for subview in self.visualView!.subviews {
                subview.layer.cornerRadius = self.tupleView.layer.cornerRadius
            }
        }
    }

    func numberOfItemsInSection(_ section: Any) -> Any {
        return self.rowItems
    }
    func sizeForFooterInSection(_ section: Any) -> Any {
        var height = KFooterHeight;
        if (UIScreen.isIPhoneX) {
            height += UIScreen.bottomBarHeight
        }
        return CGSizeMake(self.tupleView.width, height);
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSizeMake(self.tupleView.width/4, KItemHeight)
    }

    func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return UIEdgeInsetsMake(10, 0, 0, 0)
    }
    func edgeInsetsForFooterInSection(_ section: Any) -> Any {
        var height = 0.0
        if (UIScreen.isIPhoneX) {
            height += UIScreen.bottomBarHeight
        }
        return UIEdgeInsetsMake(10, 0, height, 0)
    }
    func tupleFooter(_ footerBlock: Any, inSection section: Any) {
        let footerBlock = footerBlock as! HTupleFooter
        let cell = footerBlock(nil, HTupleButtonApex.self, nil, true) as! HTupleButtonApex
        cell.setTopLineWithColor(UIColor.init(white: 0.1, alpha: 0.2), paddingLeft: 0, paddingRight: 0)
        cell.buttonView.backgroundColor = UIColor.white;
        cell.buttonView.textColor = UIColor.black
        cell.buttonView.text = "取消"
        cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
            self.back()
        }
    }
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        
        let cell = itemBlock(nil, HTupleViewCellVertValue1.self, nil, true) as! HTupleViewCellVertValue1
        cell.imageView.backgroundColor = UIColor.red
        cell.imageView.setImageWithName("icon_no_server")
        //[cell.imageView setFillet:YES];
        cell.labelHeight = 25
        cell.label.text = "Item"
        cell.label.textColor = UIColor.black
        cell.label.textAlignment = .center
        //[cell.label setTextAlignment:NSTextAlignmentCenter];
    }
    func didSelectItemAtIndexPath(_ indexPath: IndexPath) {
        self.back()
    }

}
