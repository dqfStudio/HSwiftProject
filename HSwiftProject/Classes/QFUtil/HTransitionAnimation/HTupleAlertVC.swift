//
//  HTupleAlertVC.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/18.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

typealias HTupleAlertNumberBlock = () -> Int
typealias HTupleAlertInsetBlock = () -> UIEdgeInsets
typealias HTupleAlertHeightBlock = (_ index: Int) -> CGFloat
typealias HTupleAlertItemBlock = (_ tuple: HTupleView, _ indexPath: IndexPath) -> Void

let kTupleAlertWidth: CGFloat = 291.0

class HTupleAlertVC: HBaseController, HTupleViewDelegate {
    
    let itemsHeight = NSMutableDictionary()
    var numberBlock: HTupleAlertNumberBlock?
    var insetBlock: HTupleAlertInsetBlock?
    var heightBlock: HTupleAlertHeightBlock?
    var itemBlock: HTupleAlertItemBlock?
    
    override var containerSize: CGSize {
        // 执行block
        self.performBlocks()
        // 计算高度
        let height = self.itemsHeight.allValues.reduce(0, { $0 + ($1 as! CGFloat) })
        return CGSize(width: kTupleAlertWidth, height: height)
    }
    
    // 转场动画内容视图阴影部分颜色
    @objc override var shadowColor: UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
    
    override var presentType: HTransitionStyle {
        return .alert
    }
    
    override var isShadowDismiss: Bool {
        return true
    }

    private lazy var tupleView: HTupleView = {
        var frame = CGRect.zero
        frame.size = self.containerSize
        let tupleView = HTupleView(frame: frame)
        tupleView.backgroundColor = UIColor.red
        tupleView.isScrollEnabled = false
        tupleView.cornerRadius = 14
        //tupleView.setBoarderWith(0.5, color: UIColor.black)
        tupleView.disableBounce()
        return tupleView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.tupleView.delegate = self
        self.view.addSubview(self.tupleView)
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            self.tupleView.releaseTupleBlock()
        }
    }
    
    // 执行block
    func performBlocks() {
        // 调用代理
        let items = self.numberBlock?() ?? 0
        self.itemsHeight.removeAllObjects()
        for item in 0...items - 1 {
            let height = self.heightBlock?(item) ?? 0
            self.itemsHeight.setObject(height, forKey: "\(item)" as NSCopying)
        }
    }

}

extension HTupleAlertVC {

    func numberOfItemsInSection(_ section: Any) -> Any {
        return self.numberBlock?() ?? 0
    }
    
    func insetForSection(_ section: Any) -> Any {
        return self.insetBlock?() ?? UIEdgeInsets.zero
    }
    
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        let width = self.tupleView.width(forSection: indexPath.section)
        let height = self.heightBlock?(indexPath.row) ?? 1.0
        return CGSize(width: width, height: height)
    }
    
    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        self.itemBlock?(tuple, indexPath)
    }

}
