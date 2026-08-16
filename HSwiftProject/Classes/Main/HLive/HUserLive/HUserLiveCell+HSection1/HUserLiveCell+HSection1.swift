//
//  HUserLiveCell+HSection1.swift
//  HSwiftProject
//
//  Created by Wind on 20/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

class HUserLiveMiddleBarView : UIView, HTupleViewDelegate {
    
    var mutableArr: NSMutableArray = NSMutableArray()
    var timer: Timer?
    
    lazy var tupleView: HTupleView = {
        let view = HTupleView(frame: self.bounds)
        view.backgroundColor = .clear
        view.enableVerticalBounce()
        view.transform = CGAffineTransform(scaleX: 1, y: -1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tupleView.delegate = self
        self.addSubview(self.tupleView)
        //设置tupleView release key
        self.tupleView.releaseTupleKey = kLiveRoomReleaseTupleKey
        for i in 0..<5 {
            let string = "黑客帝国".appendingFormat("%d", i)
            self.mutableArr.add(string)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(liveRoomReleaseTuple), name: NSNotification.Name(kLiveRoomReleaseTupleKey), object: nil)
        self.timer = Timer(timeInterval: 2, repeats: true) { timer in
            let string = "黑客帝国".appendingFormat("%lu", self.mutableArr.count)
            self.mutableArr.add(string)
            self.tupleView.reloadData()
            DispatchQueue.main.async { [weak self] in
                self!.scrollViewToBottom()
            }
        }
        RunLoop.current.add(self.timer!, forMode: .common)
    }
    
    @objc
    func liveRoomReleaseTuple() {
        self.timer?.invalidate()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func numberOfItemsInSection(_ section: Any) -> Any {
        return self.mutableArr.count
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width, height: 25)
    }
    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
        //将cell.contentView倒置
        cell.contentView.transform = CGAffineTransform (scaleX: 1, y: -1)
        cell.setTopLine(color: UIColor(white: 0.1, alpha: 0.2), paddingLeft: 0, paddingRight: 20)
        cell.label.textColor = UIColor.white
        cell.label.font = UIFont.systemFont(ofSize: 12)
        //此处数据源需要倒着加载
        let index = self.mutableArr.count - 1 - indexPath.row
        let string = self.mutableArr[index] as! String
        cell.label.text = string
    }
    private func scrollViewToBottom() {
        self.tupleView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

}

extension HUserLiveCell {
    @objc
    func tupleExa1_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    @objc
    func tupleExa1_numberOfItemsInSection(_ section: Any) -> Any {
        return 3
    }
    @objc
    func tupleExa1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0:
            return CGSize(width: self.liveRightView.width - 20, height: 60)
        case 1:
            return CGSize(width: self.liveRightView.width - 20, height: 60)
        case 2:
            var height = UIScreen.height
            height -= (UIScreen.statusBarHeight + 5) + 35 * 3 + 18//section0的高度
            height -= 60 + 60//section1的row0和row1高度
            height -= (UIScreen.bottomBarHeight + 5) + 40//section2的高度
            return CGSize(width: self.liveRightView.width, height: height)
        default:
            break
        }
        return CGSize.zero
    }
    @objc
    func tupleExa1_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0:
            return UIEdgeInsets(top: 10, left: 0, bottom: 5, right: 0)
        case 1:
            return UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
        case 2:
            return UIEdgeInsets.zero
        default:
            break
        }
        return UIEdgeInsets.zero
    }
    @objc
    func tupleExa1_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            let cell = tuple.reuseCell(HTupleTmplCell.self, nil, true, indexPath) as! HTupleTmplCell
            var buttonView = cell.viewWithTag(123456) as? HWebButtonView
            if (buttonView == nil) {
                var tmpFrame = cell.layoutViewBounds
                tmpFrame.x = tmpFrame.width - tmpFrame.height
                tmpFrame.width = tmpFrame.height
                buttonView = HWebButtonView(frame: tmpFrame)
                buttonView!.backgroundColor = UIColor.red
                buttonView!.cornerRadius = buttonView!.width / 2
                buttonView!.setImage(named: "icon_no_server")
                buttonView!.tag = 123456
                cell.addSubview(buttonView!)
//                [buttonView setPressed:^(id sender, id data) {
//                    [[self viewController] presentController:HAlertController.new completion:^(HTransitionType transitionType) {
//                        NSLog(@"")
//                    }]
//                }]
            }
            var honorLabel = cell.viewWithTag(234567) as? UILabel
            if (honorLabel == nil) {
                let frame = CGRect(x: self.width, y: 10, width: 80, height: 25)
                honorLabel = UILabel(frame: frame)
                honorLabel!.text = "恭喜中奖!!!"
                honorLabel!.font = UIFont.systemFont(ofSize: 12)
                honorLabel!.textColor = UIColor.white
                honorLabel!.backgroundColor = UIColor.red
                honorLabel!.textAlignment = .center
                honorLabel!.cornerRadius = honorLabel!.height / 2
                honorLabel!.tag = 234567
                cell.addSubview(honorLabel!)
                
                let honorTimer = Timer(timeInterval: 5, repeats: true) { timer in
                    honorLabel!.frame = CGRect(x: cell.width, y: 10, width: 80, height: 25)
                    UIView.animate(withDuration: 0.7) {
                        honorLabel!.frame = CGRect(x: 0, y: 10, width: 80, height: 25)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        UIView.animate(withDuration: 0.3) {
                            honorLabel!.frame = CGRect(x: -100, y: 10, width: 80, height: 25)
                        }
                    })
                }
                RunLoop.current.add(honorTimer, forMode: .common)
            }
            break
        case 1:
            let cell = tuple.reuseCell(HTupleTmplCell.self, nil, true, indexPath) as! HTupleTmplCell
            var buttonView = cell.viewWithTag(123456) as? HWebButtonView
            if (buttonView == nil) {
                var tmpFrame = cell.layoutViewBounds
                tmpFrame.x = tmpFrame.width - tmpFrame.height
                tmpFrame.width = tmpFrame.height
                buttonView = HWebButtonView(frame: tmpFrame)
                buttonView!.backgroundColor = UIColor.red
                buttonView!.cornerRadius = buttonView!.width / 2
                buttonView!.setImage(named: "icon_no_server")
                buttonView!.tag = 123456
                cell.addSubview(buttonView!)
//                [buttonView setPressed:^(id sender, id data) {
//                    [[self viewController] presentController:HAlertController.new completion:^(HTransitionType transitionType) {
//                        NSLog(@"")
//                    }]
//                }]
            }
            break
        case 2:
            let cell = tuple.reuseCell(HTupleTmplCell.self, nil, true, indexPath) as! HTupleTmplCell
            var bottomBarView = cell.viewWithTag(123456) as? HUserLiveMiddleBarView
            if bottomBarView == nil {
                bottomBarView = HUserLiveMiddleBarView(frame: cell.bounds)
                bottomBarView!.tag = 123456
                cell.addSubview(bottomBarView!)
            }
            break
        default:
            break
        }
    }
}
