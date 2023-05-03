//
//  HSheetController.swift
//  HSwiftProject
//
//  Created by Wind on 23/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit


class HSheetController : HViewController, HTupleViewDelegate {
    
    override var containerSize: CGSize {
        return CGSize(width: UIScreen.width, height: 100)
    }

    override var presetType: HTransitionStyle {
        return .sheet
    }

    lazy var visualView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        return UIVisualEffectView(effect: blur)
    }()

    lazy var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: .zero)
        tupleView.backgroundColor = UIColor.clear
        tupleView.layer.cornerRadius = 3.0//默认为3.f
        tupleView.isScrollEnabled = false
        tupleView.disableBounce()
        return tupleView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.navigationBar.isHidden = true
        
        //是否隐藏视觉展示效果，如毛玻璃效果
        if self.hideVisualView {
            self.tupleView.backgroundColor = UIColor.white
            self.view.addSubview(self.tupleView)
        } else {
            self.visualView.contentView.addSubview(self.tupleView)
            self.view.addSubview(self.visualView)
        }
        
        // 设置frame
        self.visualView.frame.size = self.containerSize
        self.tupleView.frame.size = self.containerSize
        
        // 设置代理
        self.tupleView.delegate = self
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.hideVisualView {
            self.visualView.subviews.forEach {
                $0.layer.cornerRadius = self.tupleView.layer.cornerRadius
            }
        }
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            self.tupleView.releaseTupleBlock()
        }
    }

    func numberOfSectionsInTupleView() -> Any {
        return 1
    }
    func numberOfItemsInSection(_ section: Any) -> Any {
        return 4
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case HCell0:
            return CGSize(width: self.tupleView.width, height: 40)
        case HCell1:
            return CGSize(width: self.tupleView.width, height: 50)
        case HCell2:
            return CGSize(width: self.tupleView.width, height: 50)
        case HCell3:
            return CGSize(width: self.tupleView.width, height: 50)
        default:
            break
        }
        return CGSize.zero
    }
    func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return UIEdgeInsetsZero
    }
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        switch (indexPath.row) {
        case HCell0:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.setBottomLine(withColor: UIColor(white: 0.1, alpha: 0.2), paddingLeft: 0, paddingRight: 0)
            cell.label.font = UIFont.boldSystemFont(ofSize: 17)
            cell.label.textAlignment = .center
            cell.label.textColor = HColorHex("#0B0A0C")
            cell.label.text = "过期提醒"
            break
        case HCell1:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.setBottomLine(withColor: UIColor(white: 0.1, alpha: 0.2), paddingLeft: 0, paddingRight: 0)
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            cell.label.numberOfLines = 0
            cell.label.textColor = HColorHex("#070507")
            cell.label.text = "您的会员资格已不足3天，请及时充值!"
            break
        case HCell2:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.setBottomLine(withColor: UIColor(white: 0.1, alpha: 0.2), paddingLeft: 0, paddingRight: 0)
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            cell.label.numberOfLines = 0
            cell.label.textColor = HColorHex("#070507")
            cell.label.text = "您的会员资格已不足3天，请及时充值!"
            break
        case HCell3:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.label.font = UIFont.boldSystemFont(ofSize: 17)
            cell.label.textAlignment = .center
            cell.label.textColor = HColorHex("#3184DD")
            cell.label.text = "确定"
            break
        default:
            break
        }
        
    }
    func didSelectItemAtIndexPath(_ indexPath: IndexPath) {
        if (indexPath.row == HCell3) {
            self.back()
        }
    }

}
