//
//  HUserLiveCell+HSection0.swift
//  HSwiftProject
//
//  Created by Wind on 18/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

class HUserLiveTopHeaderView : UIView, HTupleViewDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tupleView.delegate = self
        self.addSubview(self.tupleView)
        //设置tupleView release key
        self.tupleView.releaseTupleKey = KLiveRoomReleaseTupleKey
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var _tupleView: HTupleView?
    var tupleView: HTupleView {
        if (_tupleView == nil) {
            _tupleView = HTupleView(frame: self.bounds, scrollDirection: .horizontal)
            _tupleView!.backgroundColor = UIColor.clear
            _tupleView!.bounceDisenable()
        }
        return _tupleView!
    }

    func insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func numberOfItemsInSection(_ section: Any) -> Any {
        return 6
    }
    func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        case 1:
            return UIEdgeInsetsZero
        case 2:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        case 3:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        case 4:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        case 5:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            
        default:
            break
        }
        return UIEdgeInsetsZero
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0:
            return CGSize(width: 135, height: self.tupleView.height)
        case 1:
            return CGSize(width: self.tupleView.width - 20 - 135 - self.tupleView.height * 4, height: self.tupleView.height)
        case 2:
            return CGSize(width: self.tupleView.height, height: self.tupleView.height)
        case 3:
            return CGSize(width: self.tupleView.height, height: self.tupleView.height)
        case 4:
            return CGSize(width: self.tupleView.height, height: self.tupleView.height)
        case 5:
            return CGSize(width: self.tupleView.height, height: self.tupleView.height)
            
        default:
            break
        }
        return CGSize(width: self.tupleView.width, height: self.tupleView.height)
    }
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        switch (indexPath.row) {
        case 0:
            let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
            cell.backgroundColor = UIColor.black
            cell.cornerRadius = cell.height / 2
            
            let frame = cell.layoutViewBounds
            
            var tmpFrame = frame
            tmpFrame.width = tmpFrame.height
            cell.imageView.frame = tmpFrame
            cell.imageView.backgroundColor = UIColor.red
//                [cell.imageView setFillet:YES]
            cell.imageView.cornerRadius = tmpFrame.width / 2
            cell.imageView.setImageWithName("icon_no_server")
            
            
            var tmpFrame2 = frame
            tmpFrame2.x = tmpFrame2.width - 40
            tmpFrame2.width = 40
            
            cell.buttonView.frame = tmpFrame2
            cell.buttonView.backgroundColor = UIColor.red
            cell.buttonView.text = "关注"
            cell.buttonView.textColor = UIColor.white
            cell.buttonView.textFont = UIFont.systemFont(ofSize: 12)
            cell.buttonView.cornerRadius = cell.buttonView.height / 2
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
//                self.viewController?.present(HAlertController(), animated: true, completion: {
//
//                })
//                [[self viewController] presentController:HAlertController.new completion:^(HTransitionType transitionType) {
//                    NSLog(@"")
//                }]
            }
            
            var tmpFrame3 = frame
            tmpFrame3.x = tmpFrame.width + 5
            tmpFrame3.width -= tmpFrame.width + tmpFrame2.width + 10
            tmpFrame3.height /= 2
            
            cell.label.frame = tmpFrame3
            cell.label.font = UIFont.systemFont(ofSize: 9)
            cell.label.textAlignment = .left
            cell.label.textColor = UIColor.white
            cell.label.text = "游客 56738"
            
            var tmpFrame4 = tmpFrame3
            tmpFrame4.y = tmpFrame4.height
            cell.detailLabel.frame = tmpFrame4
            cell.detailLabel.font = UIFont.systemFont(ofSize: 9)
            cell.detailLabel.textAlignment = .left
            cell.detailLabel.textColor = UIColor.white
            cell.detailLabel.text = "ID 56738"
            
            break
        case 1:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.label.font = UIFont.systemFont(ofSize: 14)
            cell.label.textAlignment = .center
            cell.label.textColor = HColorHex("#0B0A0C")
            break
        case 2:
            let cell = itemBlock(nil, HTupleButtonCell.self, nil, true) as! HTupleButtonCell
            cell.buttonView.backgroundColor = UIColor.red
            cell.buttonView.cornerRadius = cell.buttonView.width / 2
            cell.buttonView.setImageWithName("icon_no_server")
//                cell.buttonView setFillet:YES]
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
//                    self.viewController?.present(HAlertController(), animated: true, completion: {
//
//                    })
//                    [[self viewController] presentController:HAlertController.new completion:^(HTransitionType transitionType) {
//                        NSLog(@"")
//                    }]
            }
            break
        case 3:
            let cell = itemBlock(nil, HTupleButtonCell.self, nil, true) as! HTupleButtonCell
            cell.buttonView.backgroundColor = UIColor.red
            cell.buttonView.cornerRadius = cell.buttonView.width / 2
            cell.buttonView.setImageWithName("icon_no_server")
//                cell.buttonView setFillet:YES]
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
//                    self.viewController?.present(HAlertController(), animated: true, completion: {
//
//                    })
//                    [[self viewController] presentController:HAlertController.new completion:^(HTransitionType transitionType) {
//                        NSLog(@"")
//                    }]
            }
            break
        case 4:
            let cell = itemBlock(nil, HTupleButtonCell.self, nil, true) as! HTupleButtonCell
            cell.buttonView.backgroundColor = UIColor.red
            cell.buttonView.cornerRadius = cell.buttonView.width / 2
            cell.buttonView.setImageWithName("icon_no_server")
//                cell.buttonView setFillet:YES]
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
//                self.viewController?.present(HAlertController(), animated: true, completion: {
//
//                })
//                [[self viewController] presentController:HAlertController.new completion:^(HTransitionType transitionType) {
//                    NSLog(@"")
//                }]
            }
            break
        case 5:
            let cell = itemBlock(nil, HTupleButtonCell.self, nil, true) as! HTupleButtonCell
            cell.buttonView.backgroundColor = UIColor.red
            cell.buttonView.cornerRadius = cell.buttonView.width / 2
            cell.buttonView.setImageWithName("icon_no_server")
//                cell.buttonView setFillet:YES]
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
//                self.viewController?.present(HAlertController(), animated: true, completion: {
//
//                })
//                [[self viewController] presentController:HAlertController.new completion:^(HTransitionType transitionType) {
//                    NSLog(@"")
//                }]
            }
            break
            
        default:
            break
        }
    }
}

class HUserLiveTopHonorView : UIView, HTupleViewDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tupleView.delegate = self
        self.addSubview(self.tupleView)
        //设置tupleView release key
        self.tupleView.releaseTupleKey = KLiveRoomReleaseTupleKey
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var _tupleView: HTupleView?
    var tupleView: HTupleView {
        if (_tupleView == nil) {
            _tupleView = HTupleView(frame: self.bounds, scrollDirection: .horizontal)
            _tupleView!.backgroundColor = UIColor.clear
            _tupleView!.bounceDisenable()
        }
        return _tupleView!
    }

    func tuple0_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    func numberOfItemsInSection(_ section: Any) -> Any {
        return 3
    }
    func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return UIEdgeInsets(top: 7.5, left: 10, bottom: 7.5, right: 0)
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0:
            return CGSize(width: 100, height: self.tupleView.height)
        case 1:
            return CGSize(width: 100, height: self.tupleView.height)
        case 2:
            return CGSize(width: self.tupleView.width - 200 - 20, height: self.tupleView.height)
        default:
            break
        }
        return CGSize(width: self.tupleView.width, height: self.tupleView.height)
    }
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        switch (indexPath.row) {
        case 0:
            let cell = itemBlock(nil, HTupleViewCellHoriValue3.self, nil, true) as! HTupleViewCellHoriValue3
            cell.layoutView.backgroundColor = UIColor.black
            cell.layoutView.cornerRadius = cell.layoutView.height / 2
            
            cell.label.font = UIFont.systemFont(ofSize: 10)
            cell.label.textAlignment = .right
            cell.label.textColor = UIColor.white
            cell.label.text = "魅力值 202"

            cell.detailWidth = 20
            cell.detailLabel.font = UIFont.systemFont(ofSize: 18)
            cell.detailLabel.textAlignment = .right
            cell.detailLabel.textColor = UIColor.white
            cell.detailLabelInsets = UILREdgeInsetsMake(0, 5)
//                cell.detailLabel setTextVerticalAlignment:HTextVerticalAlignmentBottom]
            cell.detailLabel.text = "›"
            break
        case 1:
            let cell = itemBlock(nil, HTupleViewCellHoriValue3.self, nil, true) as! HTupleViewCellHoriValue3
            cell.layoutView.backgroundColor = UIColor.black
            cell.layoutView.cornerRadius = cell.layoutView.height / 2
            
            cell.label.font = UIFont.systemFont(ofSize: 10)
            cell.label.textAlignment = .right
            cell.label.textColor = UIColor.white
            cell.label.text = "守护 虚位以待"

            cell.detailWidth = 18
            cell.detailLabel.font = UIFont.systemFont(ofSize: 18)
            cell.detailLabel.textAlignment = .right
            cell.detailLabel.textColor = UIColor.white
            cell.detailLabelInsets = UILREdgeInsetsMake(0, 5)
//                [cell.detailLabel setTextVerticalAlignment:HTextVerticalAlignmentBottom]
            cell.detailLabel.text = "›"
            break
        case 2:
            let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
            cell.label.font = UIFont.systemFont(ofSize: 10)
            cell.label.textAlignment = .center
            cell.label.textColor = UIColor.white
            break
            
        default:
            break
        }
    }
}

extension HUserLiveCell {
    @objc
    func tupleExa0_numberOfItemsInSection(_ section: Any) -> Any {
        return 4
    }
    @objc
    func tupleExa0_sizeForHeaderInSection(_ section: Any) -> Any {
        return CGSize(width: self.liveRightView.width, height: UIScreen.statusBarHeight + 5)
    }
    @objc
    func tupleExa0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0:
            return CGSize(width: self.liveRightView.width, height: 35)
        case 1:
            return CGSize(width: self.liveRightView.width, height: 35)
        case 2:
            return CGSize(width: self.liveRightView.width, height: 18)
        case 3:
            return CGSize(width: self.liveRightView.width, height: 35)
            
        default:
            break
        }
        return CGSize.zero
    }
    @objc
    func tupleExa0_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        if (indexPath.row == 2) {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }else if (indexPath.row == 3) {
            return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: self.liveRightView.width - 130)
        }
        return UIEdgeInsetsZero
    }
    @objc
    func tupleExa0_tupleHeader(_ headerBlock: Any, inSection section: Any) {
        let headerBlock = headerBlock as! HTupleHeader
        let cell = headerBlock(nil, HTupleBaseApex.self, nil, true) as! HTupleBaseApex
        cell.backgroundColor = UIColor.clear
    }
    @objc
    func tupleExa0_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        switch (indexPath.row) {
        case 0:
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            var topHeaderView = cell.viewWithTag(123456) as? HUserLiveTopHeaderView
            if (topHeaderView == nil) {
                topHeaderView = HUserLiveTopHeaderView(frame: cell.bounds)
                topHeaderView!.tag = 123456
                cell.addSubview(topHeaderView!)
            }
            break
        case 1:
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            var topHonorView = cell.viewWithTag(234567) as? HUserLiveTopHonorView
            if (topHonorView == nil) {
                topHonorView = HUserLiveTopHonorView(frame: cell.bounds)
                topHonorView!.tag = 234567
                cell.addSubview(topHonorView!)
            }
            break
        case 2:
//                let cell = itemBlock(nil, HTupleViewMarqueeCell.self, nil, true) as! HTupleViewMarqueeCell
//                cell.layoutView.backgroundColor = UIColor.black
//                cell.layoutView.cornerRadius = cell.layoutView.height / 2
//                cell.msg = "测试通告!!!"
//                cell.bgColor = UIColor.black
//                cell.txtColor = UIColor.white
//                cell.selectedBlock = { () in
//                    NSLog("")
//                }
            
            let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
            cell.layoutView.backgroundColor = UIColor.black
            cell.layoutView.cornerRadius = cell.layoutView.height / 2
            
//                HNoticeBrowseLabel *noticeBrowse = [cell viewWithTag:345678]
//                [noticeBrowse releaseNotice]
//                if (!noticeBrowse) {
//                    CGRect frame = cell.layoutViewBounds
//                    frame.origin.x = 20
//                    frame.size.width -= 20
//                    noticeBrowse = [[HNoticeBrowseLabel alloc] initWithFrame:frame]
//                    [noticeBrowse setTag:345678]
//                    noticeBrowse.textColor = UIColor.whiteColor
//                    noticeBrowse.textFont = [UIFont systemFontOfSize:12.f]
//                    noticeBrowse.durationTime = 4.0
//                    [cell addSubview:noticeBrowse]
//                }
//                noticeBrowse.texts = @[@"测试通告!!!"]
//                [noticeBrowse reloadData]
            break
        case 3:
            let cell = itemBlock(nil, HTupleButtonCell.self, nil, true) as! HTupleButtonCell
            cell.buttonView.cornerRadius = cell.layoutViewFrame.height / 2
            cell.buttonView.backgroundColor = UIColor.yellow
            cell.buttonView.text = "测试公告"
            cell.buttonView.textFont = UIFont.systemFont(ofSize: 14)
            cell.buttonView.textColor = UIColor.black
            cell.buttonView.textAlignment = .left
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
//                [[self viewController] presentController:HUserLiveNoteVC.new completion:^(HTransitionType transitionType) {
//                    NSLog(@"")
//                }]
            }
            break
            
        default:
            break
        }
    }
    
}
