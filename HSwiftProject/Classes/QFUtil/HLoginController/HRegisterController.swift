//
//  HRegisterController.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HRegisterController: HViewController, HTupleViewDelegate {

    lazy var tupleView: HTupleView = {
        var frame = UIScreen.bound
        frame.origin.y += UIScreen.topBarHeight
        frame.size.height -= UIScreen.topBarHeight
        let tupleView = HTupleView.tupleFrame({ () -> CGRect in
            return frame
        }, exclusiveSections: { () -> NSArray in
            return [0]
        })
        return tupleView
    }()

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == HVCDisappearType.pop || type == HVCDisappearType.dismiss {
            self.tupleView.releaseTupleBlock()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册"
        self.navigationBar.leftItem.isHidden = true
        
        self.tupleView.delegate = self
        self.view.addSubview(self.tupleView)
        
        self.tupleView.setObject("分身状态一", forKey: "state", state: 0)
        self.tupleView.setObject("分身状态二", forKey: "state", state: 1)
    }
    
    var tabBarView: HTabBar {
        var frame: CGRect = CGRect.zero
        frame.origin.x = self.tupleView.width / 2 - 200 / 2
        frame.origin.y = 55 / 2 - 35 / 2
        frame.size.width = 200
        frame.size.height = 35
        
        let tabBar = HTabBar(frame: frame)
        tabBar.cornerRadius = 35 / 2
        tabBar.tag = 12345
        
        let item1 = HTabItem()
        item1.title = "快速注册"
        item1.backgroundColor = UIColor.yellow
        
        let item2 = HTabItem()
        item2.title = "手机注册"
        item2.backgroundColor = UIColor.white
        
        //@www
        tabBar.tabbardSelectedBlock = { (_ idx: Int) in
            DispatchQueue.main.async { [weak self] in
                //@sss
                switch (idx) {
                case 0:
                    item1.backgroundColor = UIColor.yellow
                    item2.backgroundColor = UIColor.white
                case 1:
                    item1.backgroundColor = UIColor.white
                    item2.backgroundColor = UIColor.yellow
                default: break
                }
                self?.tupleView.tupleState = idx
            }
        }
        
        tabBar.items = [item1, item2]
        tabBar.itemTitleColor = UIColor.black
        tabBar.itemTitleSelectedColor = UIColor.white
        tabBar.itemTitleFont = UIFont.systemFont(ofSize: 17)
        tabBar.itemTitleSelectedFont = UIFont.systemFont(ofSize: 17)
        tabBar.leadingSpace = 0
        tabBar.trailingSpace = 0
        
        tabBar.isItemFontChangeFollowContentScroll = true
        tabBar.isIndicatorScrollFollowContent = true
        tabBar.indicatorColor = UIColor.clear
        tabBar.backgroundColor = UIColor.white
        
        tabBar.selectedItemIndex = 0
        
        tabBar.setScrollEnabledAndItemWidth(frame.size.width / 2)
        return tabBar
    }

    @objc
    func tupleExa0_numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    @objc
    func tupleExa0_sizeForHeaderInSection(_ section: Any) -> Any {
        return CGSize(width: self.tupleView.width, height: 10)
    }
    @objc
    func tupleExa0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width, height: 55)
    }
    @objc
    func tupleExa0_tupleHeader(_ headerBlock: Any, inSection section: Any) {
        _ = (headerBlock as! HTupleHeader)(nil, HTupleBaseApex.self, nil, false)
    }
    @objc
    func tupleExa0_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
        let tabBar = cell.viewWithTag(12345) as? HTabBar
        if tabBar == nil {
            cell.addSubview(self.tabBarView)
        }
    }

}
