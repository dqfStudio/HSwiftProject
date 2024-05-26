//
//  HPostCommentViewCellCell.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/26.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HPostCommentViewCell: HTupleBaseCell, HTupleViewDelegate {
    
    // 帖子model
    private var _postVM: HPostCommentVM?
    var postVM: HPostCommentVM! {
        get { return _postVM }
        set {
            if _postVM?.post != newValue.post {
                _postVM = newValue
            }
        }
    }
    
    lazy var tupleView: HTupleView = {
        let tupleView = HTupleView.splitFrame {
            return self.bounds
        } mode: {
            return .delegate
        } exclusiveSections: {
            return [0, 1, 2, 3, 4, 5]
        } layout: {
            return HTupleViewLayout(.vertical, .manual)
        }
        tupleView.isScrollEnabled = false
        tupleView.disableBounce()
        return tupleView
    }()
    
    override func initUI() {
        self.tupleView.delegate = self
        self.layoutView.addArrangedSubview(self.tupleView)
        self.tupleView.cntSizeBlock = { [weak self] cntSize in
            if let tuple = self?.tuple {
                tuple.reloadData()
            }
        }
    }
    
    func reloadTupleData() {
        self.tupleView.reloadTupleData()
    }
    
    deinit {
        self.tupleView.releaseTupleBlock()
    }
    
    @objc
    func tuple0_numberOfSectionsInTupleView() -> Any {
        return 6
    }

}

extension HPostCommentViewCell {
    
    @objc
    func tupleExa0_numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    
    @objc
    func tupleExa0_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 12, left: postCommentEdgeSpace, bottom: 0, right: postCommentEdgeSpace)
    }
    
    @objc
    func tupleExa0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: 48)
    }
    
    @objc
    func tupleExa0_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HTupleBaseCell.self, indexPath.stringValue, true, indexPath) as! HTupleBaseCell
        let frame = cell.layoutViewBounds
        
        var headerView = cell.layoutView.viewWithTag(121314) as? HPostCommentHeader
        if headerView == nil {
            headerView = HPostCommentHeader(frame: frame)
            headerView!.tag = 121314
            headerView!.avatarButton.pressed = { (sender, data) in
                NSLog("")
            }
            cell.layoutView.addSubview(headerView!)
        }
        headerView!.avatarButton.backgroundColor = .red
        headerView!.nameLabel.text = "张三"
        headerView!.dateLabel.text = "2023-08-10"
        
        cell.selectBlock = {
            NSLog("")
        }
    }
    
}

extension HPostCommentViewCell {
    
    @objc
    func tupleExa1_numberOfItemsInSection(_ section: Any) -> Any {
        var items = 0
        // 文字内容
        if postVM.post?.count ?? 0 > 0 {
            items += 1
        }
        return items
    }
    
    @objc
    func tupleExa1_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: postCommentLineSpace, left: postCommentEdgeSpace + 60, bottom: 0, right: postCommentEdgeSpace)
    }
    
    @objc
    func tupleExa1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postVM.textHeight)
    }
    
    @objc
    func tupleExa1_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HTupleLabelCell.self, indexPath.stringValue, true, indexPath) as! HTupleLabelCell
        cell.label.font = UIFont.font(ofSize: 14, weight: .regular)
        cell.label.textColor = UIColor(hex: "#17191E")
        cell.label.numberOfLines = 0
        cell.label.text = postVM.post
    }
    
}

extension HPostCommentViewCell {
    
    @objc
    func tupleExa2_numberOfItemsInSection(_ section: Any) -> Any {
        var items = 0
        // 是否需要翻译
        if postVM.postTranslate != .undefine {
            items += 1
        }
        return items
    }
    
    @objc
    func tupleExa2_insetForSection(_ section: Any) -> Any {
        // 是否需要翻译
        if postVM.postTranslate != .undefine {
            return UIEdgeInsets(top: 8, left: postCommentEdgeSpace + 60, bottom: 0, right: postCommentEdgeSpace)
        }
        return UIEdgeInsets(top: 0, left: postCommentEdgeSpace + 60, bottom: 0, right: postCommentEdgeSpace)
    }
    
    @objc
    func tupleExa2_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        // 是否已经翻译过了
        if postVM.postTranslate == .isTranslated {
            return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postVM.textHeight)
        }
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postCommentTranslateSpace - 8.0)
    }
    
    @objc
    func tupleExa2_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        // 是否已经翻译过了
        if postVM.postTranslate == .isTranslated {
            let cell = tuple.reuseCell(HTupleLabelCell.self, indexPath.stringValue, true, indexPath) as! HTupleLabelCell
            cell.label.font = UIFont.font(ofSize: 14, weight: .regular)
            cell.label.textColor = UIColor(hex: "#17191E")
            cell.label.numberOfLines = 0
            cell.label.text = postVM.post
        } else {
            let cell = tuple.reuseCell(HTupleViewCell.self, indexPath.stringValue, true, indexPath) as! HTupleViewCell
            
            let frame = cell.layoutViewBounds
            let width = "翻译内容".widthWithFont(UIFont.font(ofSize: 14, weight: .regular), constrainedToHeight: postTranslateSpace - 8.0)
            
            cell.buttonView.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
            cell.buttonView.textFont = UIFont.font(ofSize: 14, weight: .regular)
            cell.buttonView.textColor = UIColor(hex: "#3879FC")
            cell.buttonView.text = "翻译内容"
            
            cell.buttonView.pressed = { (sender, data) in
                // 是否已经翻译过了
                self.postVM.postTranslate = .isTranslated
                // 刷新tuple view
                UIView.performWithoutAnimation {
                    self.tupleView.reloadData()
                }
            }
        }

    }
    
}

extension HPostCommentViewCell {
    
    @objc
    func tupleExa3_numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    
    @objc
    func tupleExa3_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 8, left: postCommentEdgeSpace + 60, bottom: 0, right: postCommentEdgeSpace)
    }
    
    @objc
    func tupleExa3_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postCommentTimeSpace - 8.0)
    }
    
    @objc
    func tupleExa3_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HTupleViewCell.self, indexPath.stringValue, true, indexPath) as! HTupleViewCell
        let frame = cell.layoutViewBounds
        
        let string1 = "14小时前"
        let width1 = string1.widthWithFont(UIFont.font(ofSize: 14, weight: .regular), constrainedToHeight: 20)
        
        cell.label.frame = CGRect(x: 0, y: 0, width: width1, height: frame.height)
        cell.label.font = UIFont.font(ofSize: 14, weight: .regular)
        cell.label.textColor = UIColor(hex: "#9B9FA8")
        cell.label.text = string1
        
        let string2 = "回复"
        let width2 = string2.widthWithFont(UIFont.font(ofSize: 14, weight: .medium), constrainedToHeight: 20)
        
        cell.buttonView.frame = CGRect(x: cell.label.maxX + 8, y: 0, width: width2, height: frame.height)
        cell.buttonView.textFont = UIFont.font(ofSize: 14, weight: .medium)
        cell.buttonView.textColor = UIColor(hex: "#727781")
        cell.buttonView.text = string2
        cell.buttonView.pressed = { (sender, data) in
            
        }
    }
    
}

extension HPostCommentViewCell {
    
    @objc
    func tupleExa4_numberOfItemsInSection(_ section: Any) -> Any {
        var items = 0
        // 是否显示更多信息
        if postVM.postExtend == .extend {
            items += 1
        }
        return items
    }
    
    @objc
    func tupleExa4_insetForSection(_ section: Any) -> Any {
        // 是否显示更多信息
        if postVM.postExtend == .extend {
            return UIEdgeInsets(top: 16, left: postCommentEdgeSpace + 60, bottom: 0, right: postCommentEdgeSpace)
        }
        return UIEdgeInsets(top: 0, left: postCommentEdgeSpace + 60, bottom: 0, right: postCommentEdgeSpace)
    }
    
    @objc
    func tupleExa4_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postCommentExtendSpace - 16.0)
    }
    
    @objc
    func tupleExa4_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HTupleViewCell.self, indexPath.stringValue, true, indexPath) as! HTupleViewCell
        let frame = cell.layoutViewBounds
        
        let ff = true
        
        if ff {
            let string = "展开14条回复"
            let width = string.widthWithFont(UIFont.font(ofSize: 14, weight: .medium), constrainedToHeight: 20)

            cell.buttonView.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
            cell.buttonView.textFont = UIFont.font(ofSize: 14, weight: .medium)
            cell.buttonView.textColor = UIColor(hex: "#727781")
            cell.buttonView.text = string
            cell.buttonView.pressed = { (sender, data) in
                // 刷新tuple view
                UIView.performWithoutAnimation {
                    // 更多按钮高度
                    self.postVM.postExtend = .undefine
                    self.tupleView.reloadData()
                }
            }
        } else {
            let string1 = "展开更多回复"
            let width1 = string1.widthWithFont(UIFont.font(ofSize: 14, weight: .medium), constrainedToHeight: 20)
            
            cell.buttonView.frame = CGRect(x: 0, y: 0, width: width1, height: frame.height)
            cell.buttonView.textFont = UIFont.font(ofSize: 14, weight: .medium)
            cell.buttonView.textColor = UIColor(hex: "#727781")
            cell.buttonView.text = string1
            cell.buttonView.pressed = { (sender, data) in
                // 刷新tuple view
                UIView.performWithoutAnimation {
                    self.tupleView.reloadData()
                }
            }
            
            let string2 = "收起"
            let width2 = string2.widthWithFont(UIFont.font(ofSize: 14, weight: .medium), constrainedToHeight: 20)
            
            cell.detailButton.frame = CGRect(x: cell.buttonView.maxX + 24, y: 0, width: width2, height: frame.height)
            cell.detailButton.textFont = UIFont.font(ofSize: 14, weight: .medium)
            cell.detailButton.textColor = UIColor(hex: "#727781")
            cell.detailButton.text = string2
            cell.detailButton.pressed = { (sender, data) in
                // 刷新tuple view
                UIView.performWithoutAnimation {
                    self.tupleView.reloadData()
                }
            }
        }
    }
    
}

extension HPostCommentViewCell {
    
    @objc
    func tupleExa5_numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    
    @objc
    func tupleExa5_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 0, left: postCommentEdgeSpace, bottom: 0, right: postCommentEdgeSpace)
    }
    
    @objc
    func tupleExa5_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: 12.0)
    }
    
    @objc
    func tupleExa5_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        _ = tuple.reuseCell(HTupleBaseCell.self, indexPath.stringValue, true, indexPath) as! HTupleBaseCell
    }
    
}
