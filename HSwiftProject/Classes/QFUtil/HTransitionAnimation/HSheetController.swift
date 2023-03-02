//
//  HSheetController.swift
//  HSwiftProject
//
//  Created by Wind on 23/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit


class HSheetController : HViewController, HTupleViewDelegate {

    private var _visualView: UIVisualEffectView?
    private var visualView: UIVisualEffectView? {
        get {
            if (_visualView == nil) {
                let blur = UIBlurEffect(style: .extraLight)
                _visualView = UIVisualEffectView(effect: blur)
                var frame = CGRect.zero
                frame.size = self.containerSize
                _visualView!.frame = frame
            }
            return _visualView!
        }
        set {
            _visualView = newValue
        }
    }
    private var _tupleView: HTupleView?
    private var tupleView: HTupleView {
        get {
            if (_tupleView == nil) {
                var frame = CGRect.zero
                frame.size = self.containerSize
                _tupleView = HTupleView(frame: frame)
                _tupleView!.backgroundColor = UIColor.clear
                _tupleView!.layer.cornerRadius = 3.0//默认为3.f
                _tupleView!.bounceDisenable()
            }
            return _tupleView!
        }
        set {
            _tupleView = newValue
        }
    }

    override var containerSize: CGSize {
        return CGSize.zero
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
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (!self.hideVisualView) {
            for subview in self.visualView!.subviews {
                subview.layer.cornerRadius = self.tupleView.layer.cornerRadius
            }
        }
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == HVCDisappearType.pop || type == HVCDisappearType.dismiss {
            self.tupleView.releaseTupleBlock()
            self.visualView = nil
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
            cell.setBottomLineWithColor(UIColor(white: 0.1, alpha: 0.2), paddingLeft: 0, paddingRight: 0)
            cell.label.font = UIFont.boldSystemFont(ofSize: 17)
            cell.label.textAlignment = .center
            cell.label.textColor = HColorHex("#0B0A0C")
            cell.label.text = "过期提醒"
            break
        case HCell1:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.setBottomLineWithColor(UIColor(white: 0.1, alpha: 0.2), paddingLeft: 0, paddingRight: 0)
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            cell.label.numberOfLines = 0
            cell.label.textColor = HColorHex("#070507")
            cell.label.text = "您的会员资格已不足3天，请及时充值!"
            break
        case HCell2:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.setBottomLineWithColor(UIColor(white: 0.1, alpha: 0.2), paddingLeft: 0, paddingRight: 0)
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
