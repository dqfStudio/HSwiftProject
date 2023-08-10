//
//  HTuplePostCell.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/8.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HTuplePostCell: UIStackView, HTupleViewDelegate {
    
    // 帖子model
    private var _postVM: HTuplePostVM?
    var postVM: HTuplePostVM! {
        get { return _postVM }
        set {
            if _postVM?.post != newValue.post {
                _postVM = newValue
            }
        }
    }
    
    // 父类tuple view
    weak var tuple: HTupleView?
    
    private lazy var tupleView: HTupleView = {
        let tupleView = HTupleView.tupleFrame({
            return self.bounds
        }, exclusiveSections: {
            return [0, 1, 2, 3, 4, 5]
        })
        tupleView.isScrollEnabled = false
        tupleView.disableBounce()
        return tupleView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.tupleView.delegate = self
        self.addArrangedSubview(self.tupleView)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension HTuplePostCell {
    
    @objc
    func tupleExa0_numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    
    @objc
    func tupleExa0_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 24, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
    }
    
    @objc
    func tupleExa0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: 48)
    }
    
    @objc
    func tupleExa0_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleBaseCell.self, indexPath.stringValue, true) as! HTupleBaseCell
        let frame = cell.layoutViewBounds
        
        var headerView = cell.layoutView.viewWithTag(121314) as? HPostHeaderView
        if headerView == nil {
            headerView = HPostHeaderView(frame: frame)
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

extension HTuplePostCell {
    
    @objc
    func tupleExa1_numberOfItemsInSection(_ section: Any) -> Any {
        var items = 0
        // 文字内容
        if postVM.post?.count ?? 0 > 0 {
            items += 1
            // 是否显示更多信息
            if postVM.postExtend == .extend {
                items += 1
            }
        }
        return items
    }
    
    @objc
    func tupleExa1_insetForSection(_ section: Any) -> Any {
        if postVM.post?.count ?? 0 > 0 {
            return UIEdgeInsets(top: postLineSpace, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
        } else {
            return UIEdgeInsets(top: 0, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
        }
    }
    
    @objc
    func tupleExa1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch indexPath.row {
        case 0:
            if postVM.postExtend == .extend {
                return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postTextHeightOmit)
            } else {
                return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postVM.textHeight)
            }
        case 1:
            return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postExtendSpace)
        default:
            break
        }
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postExtendSpace)
    }
    
    @objc
    func tupleExa1_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        switch indexPath.row {
        case 0: //内容
            if postVM.postExtend == .extend {
                let cell = itemBlock(nil, HTupleLabelCell.self, indexPath.stringValue + "notExtended", true) as! HTupleLabelCell
                cell.label.font = UIFont.font(ofSize: 14, weight: .regular)
                cell.label.textColor = UIColor(hex: "#17191E")
                cell.label.numberOfLines = 3
                cell.label.text = postVM.post
            } else {
                let cell = itemBlock(nil, HTupleLabelCell.self, indexPath.stringValue + "isExtended", true) as! HTupleLabelCell
                cell.label.font = UIFont.font(ofSize: 14, weight: .regular)
                cell.label.textColor = UIColor(hex: "#17191E")
                cell.label.numberOfLines = 0
                cell.label.text = postVM.post
            }
        case 1: //更多
            let cell = itemBlock(nil, HTupleViewCell.self, indexPath.stringValue, true) as! HTupleViewCell
            cell.edgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
            
            let frame = cell.layoutViewBounds
            let width = "显示更多".widthWithFont(UIFont.font(ofSize: 14, weight: .regular), constrainedToHeight: postExtendSpace - 8.0)

            cell.buttonView.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
            cell.buttonView.textFont = UIFont.font(ofSize: 14, weight: .regular)
            cell.buttonView.textColor = UIColor(hex: "#3879FC")
            cell.buttonView.text = "显示更多"
            cell.buttonView.pressed = { (sender, data) in
                self.postVM.postExtend = .isExtended
                // 刷新tuple view
                UIView.performWithoutAnimation {
                    self.tuple?.reloadData()
                }
            }
        default:
            break
        }

    }
    
}

extension HTuplePostCell {
    
    @objc
    func tupleExa2_numberOfItemsInSection(_ section: Any) -> Any {
        var items = 0
        // 是否需要翻译
        if postVM.postExtend != .extend, postVM.postTranslate != .undefine {
            items += 1
        }
        return items
    }
    
    @objc
    func tupleExa2_insetForSection(_ section: Any) -> Any {
        // 是否需要翻译
        if postVM.postExtend != .extend, postVM.postTranslate != .undefine {
            return UIEdgeInsets(top: 8, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
        }
        return UIEdgeInsets(top: 0, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
    }
    
    @objc
    func tupleExa2_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        // 是否已经翻译过了
        if postVM.postTranslate == .isTranslated {
            return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postVM.textHeight)
        }
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postTranslateSpace - 8.0)
    }
    
    @objc
    func tupleExa2_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        // 是否已经翻译过了
        if postVM.postTranslate == .isTranslated {
            let cell = itemBlock(nil, HTupleLabelCell.self, indexPath.stringValue, true) as! HTupleLabelCell
            cell.label.font = UIFont.font(ofSize: 14, weight: .regular)
            cell.label.textColor = UIColor(hex: "#17191E")
            cell.label.numberOfLines = 0
            cell.label.text = postVM.post
        } else {
            let cell = itemBlock(nil, HTupleViewCell.self, indexPath.stringValue, true) as! HTupleViewCell
            
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
                    self.tuple?.reloadData()
                }
            }
        }

    }
    
}

extension HTuplePostCell {
    
    @objc
    func tupleExa3_numberOfItemsInSection(_ section: Any) -> Any {
        var items = 0
        // 图片
        if let count = postVM.imageUrls?.count, count > 0 {
            items += count
            //四张图片时由于布局的特殊性，多添加一个item
            if count == 4 {
                items += 1
            }
        }
        return items
    }
    
    @objc
    func tupleExa3_insetForSection(_ section: Any) -> Any {
        if postVM.imageUrls?.count ?? 0 > 0 {
            return UIEdgeInsets(top: postLineSpace, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
        } else {
            return UIEdgeInsets(top: 0, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
        }
    }
    
    @objc
    func tupleExa3_minimumLineSpacingForSectionAt(_ section: Any) -> Any {
        return postImageSpace
    }
    
    @objc
    func tupleExa3_minimumInteritemSpacingForSectionAt(_ section: Any) -> Any {
        return postImageSpace
    }
    
    @objc
    func tupleExa3_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        let width = (self.tupleView.width(forSection: indexPath.section) - 2 * postImageSpace) / 3
        return CGSize(width: width, height: postImageSize)
    }
    
    @objc
    func tupleExa3_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        if indexPath.row == 0 {
            
            let cell = itemBlock(nil, HTupleViewCell.self, indexPath.stringValue, true) as! HTupleViewCell
            let frame = cell.layoutViewBounds
            cell.buttonView.frame = frame
            cell.buttonView.backgroundColor = .red
            cell.buttonView.text = "图片"
            cell.buttonView.cornerRadius = 8.0
            cell.buttonView.isUserInteractionEnabled = true
            cell.buttonView.pressed = { (sender, data) in
                NSLog("")
            }
            
        } else if indexPath.row == 1 {
            
            let cell = itemBlock(nil, HTupleButtonCell.self, indexPath.stringValue, true) as! HTupleButtonCell
            cell.buttonView.backgroundColor = .red
            cell.buttonView.text = "图片"
            cell.buttonView.cornerRadius = 8.0
            cell.buttonView.isUserInteractionEnabled = true
            cell.buttonView.pressed = { (sender, data) in
                
            }

        }  else if indexPath.row == 2 {
            
            let cell = itemBlock(nil, HTupleButtonCell.self, indexPath.stringValue, true) as! HTupleButtonCell
            
            //四张图片时由于布局的特殊性，多添加了一个item
            if let count = postVM.imageUrls?.count, count == 4 {
                cell.buttonView.isUserInteractionEnabled = false
            } else {
                cell.buttonView.backgroundColor = .red
                cell.buttonView.isUserInteractionEnabled = true
                cell.buttonView.text = "图片"
                cell.buttonView.cornerRadius = 8.0
                cell.buttonView.pressed = { (sender, data) in
                    
                }
            }
            
        } else {
            
            let cell = itemBlock(nil, HTupleButtonCell.self, indexPath.stringValue, true) as! HTupleButtonCell
            cell.buttonView.backgroundColor = .red
            cell.buttonView.isUserInteractionEnabled = true
            cell.buttonView.text = "图片"
            cell.buttonView.cornerRadius = 8.0
            
            //四张图片时由于布局的特殊性，多添加了一个item
            if let count = postVM.imageUrls?.count, count == 4 {
                
                cell.buttonView.pressed = { (sender, data) in
                    //let row = indexPath.row - 1
                }
                
            } else {
                
                cell.buttonView.pressed = { (sender, data) in
                    //let row = indexPath.row
                }
            }
            
        }

    }
    
}

extension HTuplePostCell {
    
    @objc
    func tupleExa4_numberOfItemsInSection(_ section: Any) -> Any {
        var items = 0
        if postVM.videoUrl?.count ?? 0 > 0 {
            items += 1
        }
        return items
    }
    
    @objc
    func tupleExa4_insetForSection(_ section: Any) -> Any {
        if postVM.videoUrl?.count ?? 0 > 0 {
            return UIEdgeInsets(top: postLineSpace, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
        } else {
            return UIEdgeInsets(top: 0, left: postEdgeSpace, bottom: 0, right: postEdgeSpace)
        }
    }
    
    @objc
    func tupleExa4_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postVideoSize)
    }
    
    @objc
    func tupleExa4_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleButtonCell.self, indexPath.stringValue, true) as! HTupleButtonCell
        cell.buttonView.backgroundColor = .red
        cell.buttonView.text = "视频"
        cell.buttonView.cornerRadius = 8.0
        cell.buttonView.pressed = { (sender, data) in
            
        }
    }
    
}

extension HTuplePostCell {
    
    @objc
    func tupleExa5_numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    
    @objc
    func tupleExa5_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: postLineSpace, left: postEdgeSpace, bottom: 25, right: postEdgeSpace)
    }
    
    @objc
    func tupleExa5_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: 24)
    }
    
    @objc
    func tupleExa5_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleBaseCell.self, indexPath.stringValue, true) as! HTupleBaseCell
        let frame = cell.layoutViewBounds
        
        var footerView = cell.layoutView.viewWithTag(131415) as? HPostFooterView
        if footerView == nil {
            footerView = HPostFooterView(frame: frame)
            footerView!.tag = 131415
            footerView!.likeButton.pressed = { (sender, data) in
                NSLog("")
            }
            
            footerView!.commentButton.pressed = { (sender, data) in
                NSLog("")
            }
            
            footerView!.shareButton.pressed = { (sender, data) in
                NSLog("")
            }
            
            footerView!.moreButton.pressed = { (sender, data) in
                NSLog("")
            }
            cell.layoutView.addSubview(footerView!)
        }
        footerView!.likeButton.text = "22"
        footerView!.commentButton.text = "33"
        footerView!.shareButton.text = "44"
        footerView!.moreButton.text = "55"
    }
    
}
