//
//  HWaitingView.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/9.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

enum HWaitingType: Int {
    case black = 0
    case white = 1
    case gray = 2
}

var KWaitingImageSize = CGSize(width: 130, height: 33)
var KWaitingTextSize = CGSize(width: 130, height: 24)

class HWaitingView: UIView, HTupleViewDelegate {
    
    private var _make: HWaitingTransition?
    var make: HWaitingTransition? {
        get {
            return _make
        }
        set {
            if _make != newValue {
                _make = nil
                _make = newValue
                self.wakeup()
            }
        }
    }
    
    lazy private var tupleView: HTupleView = {
        let _tupleView = HTupleView(frame: CGRect.zero)
        _tupleView.disableBounce()
        _tupleView.isUserInteractionEnabled = false
        _tupleView.delegate = self
        self.addSubview(_tupleView)
        return _tupleView
    }()
    
    private func wakeup() {
        //添加view
        var height = KWaitingImageSize.height
        if _make != nil, _make!.desc != nil, _make!.desc!.length > 0 {
            height += KWaitingTextSize.height
        }
        
        let frame = CGRect(x: 0, y: 0, width: KWaitingImageSize.width, height: height)
        self.tupleView.frame = frame
        self.tupleView.center = CGPoint(x: self.center.x, y: self.center.y - _make!.marginTop)
        
        self.tupleView.reloadData()
    }
    
    func numberOfSectionsInTupleView() -> Any {
        return 1
    }
    func numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    func sizeForHeaderInSection(_ section: Any) -> Any {
        return KWaitingImageSize
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width, height: self.tupleView.height)
    }

    func tupleHeader(_ headerBlock: Any, inSection section: Any) {
        let headerBlock = headerBlock as! HTupleHeader
        let cell = headerBlock(nil, HTupleAnimatedImageApex.self, nil, true) as! HTupleAnimatedImageApex
        if _make!.bgColor != nil {
            cell.imageView.backgroundColor = _make!.bgColor
        }
        switch _make!.style {
        case .black:
            cell.imageView.startGifWithImageName(name: "loading_gif_black")
            break
        case .white:
            cell.imageView.startGifWithImageName(name: "loading_gif_white")
            break
        case .gray:
            cell.imageView.startGifWithImageName(name: "loading_gif_lightGray")
            break
        }
    }
    
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        
        let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
        
        cell.label.backgroundColor = UIColor.white
        cell.label.textColor = UIColor.black
        cell.label.font = UIFont.systemFont(ofSize: 14)
        cell.label.textAlignment  = .center
        if _make!.bgColor != nil {
            cell.label.backgroundColor = _make!.bgColor
        }
        if _make!.descFont != nil {
            cell.label.font = _make!.descFont
        }
        if _make!.descColor != nil {
            cell.label.textColor = _make!.descColor
        }
        if _make!.desc != nil, _make!.desc!.length > 0 {
            cell.label.text = _make!.desc
        }
    }
    
}
