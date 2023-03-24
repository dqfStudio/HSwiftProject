//
//  HUserLiveNoteVC.swift
//  HSwiftProject
//
//  Created by Wind on 25/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

class HUserLiveNoteVC : HViewController, HTupleViewDelegate {

    private var _visualView: UIVisualEffectView?
    private var visualView: UIVisualEffectView {
        if (_visualView == nil) {
            let blur = UIBlurEffect(style: .extraLight)
            _visualView = UIVisualEffectView(effect: blur)
            var frame = CGRect.zero
            frame.size = self.containerSize
            _visualView!.frame = frame
        }
        return _visualView!
    }
    
    private var _tupleView: HTupleView?
    private var tupleView: HTupleView {
        if (_tupleView == nil) {
            var frame = CGRect.zero
            frame.size = self.containerSize
            _tupleView = HTupleView(frame: frame)
            _tupleView!.backgroundColor = UIColor.clear
            _tupleView!.layer.cornerRadius = 10.0//默认系统弹框圆角为10.f
            _tupleView!.bounceDisenable()
        }
        return _tupleView!
    }
    
    private var note: String?
    private var noteSize: CGSize?

    override var containerSize: CGSize {
        self.note = "测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告测试通告end"
        self.noteSize = self.note?.sizeWithFont(UIFont.systemFont(ofSize: 12), constrainedToWidth: 240)
        return CGSize(width: 270, height: 86 + self.noteSize!.height)
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
            self.visualView.contentView.addSubview(self.tupleView)
            self.view.addSubview(self.visualView)
        }
        self.tupleView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (!self.hideVisualView) {
            for subview in self.visualView.subviews {
                subview.layer.cornerRadius = self.tupleView.layer.cornerRadius
            }
        }
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == HVCDisappearType.pop || type == HVCDisappearType.dismiss {
            self.tupleView.releaseTupleBlock()
            self._visualView = nil
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
            return CGSize(width: self.tupleView.width, height: 42.5)
        case HCell1:
            return CGSize(width: self.tupleView.width, height: self.noteSize!.height)
        case HCell2:
            return CGSize(width: self.tupleView.width, height: 1)
        case HCell3:
            return CGSize(width: self.tupleView.width, height: 42.5)
        default:
            break
        }
        return CGSize.zero
    }
    func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case HCell0:
            return UIEdgeInsets(top: 0, left: 15, bottom: 2.5, right: 15)
        case HCell1:
            return UIEdgeInsets(top: 2.5, left: 15, bottom: 0, right: 15)
        case HCell2:
            return UIEdgeInsetsZero
        case HCell3:
            return UIEdgeInsetsZero

        default:
            break
        }
        return UIEdgeInsetsZero
    }
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        
        switch (indexPath.row) {
        case HCell0:
            //HTupleNoteCell *cell = itemBlock(nil, HTupleNoteCell.class, nil, YES)
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.label.font = UIFont.boldSystemFont(ofSize: 17)
            cell.label.textAlignment = .center
            //cell.label.textVerticalAlignment = HTextVerticalAlignmentBottom
            cell.label.textColor = UIColor(hex: 0x0B0A0C)
            cell.label.text = "公告通知"
            break
        case HCell1:
            //HTupleNoteCell *cell = itemBlock(nil, HTupleNoteCell.class, nil, YES)
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .left
            //cell.label.textVerticalAlignment = HTextVerticalAlignmentTop
            cell.label.numberOfLines = 0
            cell.label.textColor = UIColor(hex: 0x070507)
            cell.label.text = self.note!
            break
        case HCell2:
            let cell = itemBlock(nil, HTupleBlankCell.self, nil, true) as! HTupleBlankCell
            cell.view.backgroundColor = UIColor(white: 0.1, alpha: 0.2)
            break
        case HCell3:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.label.font = UIFont.boldSystemFont(ofSize: 17)
            cell.label.textAlignment = .center
            cell.label.textColor = UIColor(hex: 0x3184DD)
            cell.label.text = "知道了"
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
