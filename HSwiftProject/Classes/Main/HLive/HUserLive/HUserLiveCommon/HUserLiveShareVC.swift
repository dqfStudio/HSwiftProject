//
//  HUserLiveShareVC.swift
//  HSwiftProject
//
//  Created by Wind on 25/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

private var kItemHeight = 80.0
private var kFooterHeight = 50.0

class HUserLiveShareVC : HViewController, HTupleViewDelegate {

    private lazy var visualView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .extraLight)
        let visualView = UIVisualEffectView(effect: blur)
        var frame = CGRect.zero
        frame.size = self.containerSize
        visualView.frame = frame
        return visualView
    }()
    
    private lazy var tupleView: HTupleView = {
        var frame = CGRect.zero
        frame.size = self.containerSize
        let tupleView = HTupleView(frame: frame)
        tupleView.backgroundColor = .clear
        tupleView.layer.cornerRadius = 3.0 //默认系统弹框圆角为10.f
        tupleView.disableBounce()
        return tupleView
    }()
    
    private var rowItems: Int = 0

    override var containerSize: CGSize {
        return CGSize(width: UIScreen.width, height: kItemHeight * 2 + kFooterHeight + UIScreen.bottomBarHeight)
    }

    override var presentType: HTransitionStyle {
        return .sheet
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .clear
        self.navigationBar.isHidden = true
        if self.hideVisualView {
            self.tupleView.backgroundColor = .white
            self.view.addSubview(self.tupleView)
        }else {
            self.visualView.contentView.addSubview(self.tupleView)
            self.view.addSubview(self.visualView)
        }
        self.tupleView.delegate = self
        self.rowItems = 5
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            self.tupleView.releaseTupleBlock()
        }
    }

    override var hideVisualView: Bool {
        return true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.hideVisualView {
            self.visualView.subviews.forEach {
                $0.layer.cornerRadius = self.tupleView.layer.cornerRadius
            }
        }
    }

    func numberOfItemsInSection(_ section: Any) -> Any {
        return self.rowItems
    }
    func sizeForFooterInSection(_ section: Any) -> Any {
        var height = kFooterHeight
        if UIScreen.isIPhoneX {
            height += UIScreen.bottomBarHeight
        }
        return CGSize(width: self.tupleView.width, height: height)
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width / 4.0, height: kItemHeight)
    }

    func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    func edgeInsetsForFooterInSection(_ section: Any) -> Any {
        var height = 0.0
        if UIScreen.isIPhoneX {
            height += UIScreen.bottomBarHeight
        }
        return UIEdgeInsets(top: 10, left: 0, bottom: height, right: 0)
    }
    func tupleFooter(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.footer(HTupleButtonApex.self, nil, true, indexPath) as! HTupleButtonApex
        cell.setTopLine(withColor: UIColor(white: 0.1, alpha: 0.2), paddingLeft: 0, paddingRight: 0)
        cell.buttonView.backgroundColor = UIColor.white
        cell.buttonView.textColor = UIColor.black
        cell.buttonView.text = "取消"
        cell.buttonView.pressed = { (sender, data) in
            self.naviBack()
        }
    }
    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {        
        let cell = tuple.cell(HTupleViewCellVertValue1.self, nil, true, indexPath) as! HTupleViewCellVertValue1
        cell.imageView.backgroundColor = UIColor.red
        cell.imageView.setImage(WithName: "icon_no_server")
        cell.labelHeight = 25
        cell.label.text = "Item"
        cell.label.textColor = UIColor.black
        cell.label.textAlignment = .center
        //[cell.label setTextAlignment:NSTextAlignmentCenter]
    }
    func didSelectCell(_ cell: HTupleBaseCell, atIndexPath indexPath: IndexPath) {
        self.naviBack()
    }

}
