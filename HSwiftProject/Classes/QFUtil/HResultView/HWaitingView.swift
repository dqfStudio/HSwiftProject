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

var kWaitingImageSize = CGSize(width: 130, height: 33)
var kWaitingTextSize = CGSize(width: 130, height: 24)

class HWaitingView: UIView, HTupleViewDelegate {
    
    var make: HWaitingTransition? {
        didSet {
            if make != oldValue {
                self.wakeup()
            }
        }
    }
    
    lazy private var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: .zero)
        tupleView.isUserInteractionEnabled = false
        tupleView.disableBounce()
        return tupleView
    }()
    
    private func wakeup() {
        //添加view
        var height = kWaitingImageSize.height
        if let make = make, let desc = make.desc, desc.count > 0 {
            height += kWaitingTextSize.height
        }
        
        self.tupleView.frame = CGRect(x: 0, y: 0, width: kWaitingImageSize.width, height: height)
        self.tupleView.center = CGPoint(x: self.center.x, y: self.center.y - (make?.marginTop ?? 0))
        
        self.tupleView.delegate = self
        self.addSubview(self.tupleView)
    }
    
    func numberOfSectionsInTupleView() -> Any {
        return 1
    }
    func numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    func sizeForHeaderInSection(_ section: Any) -> Any {
        return kWaitingImageSize
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width, height: self.tupleView.height)
    }

    func tupleHeader(_ headerBlock: Any, inSection section: Any) {
        let headerBlock = headerBlock as! HTupleHeader
        let cell = headerBlock(HTupleAnimatedImageApex.self, nil, true) as! HTupleAnimatedImageApex
        
        if let make = make {
            if let bgColor = make.bgColor {
                cell.imageView.backgroundColor = bgColor
            }
            switch make.style {
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
    }
    
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(HTupleLabelCell.self, nil, true) as! HTupleLabelCell
        
        cell.label.backgroundColor = UIColor.white
        cell.label.font = .systemFont(ofSize: 14.0)
        cell.label.textColor = UIColor.black
        cell.label.textAlignment = .center
        
        if let make = make {
            if let bgColor = make.bgColor {
                cell.label.backgroundColor = bgColor
            }
            if let descFont = make.descFont {
                cell.label.font = descFont
            }
            if let descColor = make.descColor {
                cell.label.textColor = descColor
            }
            if let desc = make.desc, desc.count > 0 {
                cell.label.text = desc
            }
            
        }
        
    }
    
}
