//
//  HMainController7.swift
//  HSwiftProject
//
//  Created by owner on 2023/11/3.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HMainController7: HViewController, HTupleViewDelegate {
    
    private lazy var tupleView: HTupleView = {
        let layout = HWaterfallMutiSectionFlowLayout(delegate: self)
        var frame = self.view.bounds
        frame.y = UIScreen.topBarHeight
        frame.height -= frame.y + 50
        let tupleView = HTupleView(frame: frame, collectionViewLayout: layout)
        return tupleView
    }()
    
    var sourceData: [String] = ["放假啦束带结发拉屎会计法拉数据发来的撒放假了打撒发给垃圾粉了",
                                "我饿付了款静电纺丝啦",
                                "电风扇两地分居啊射流风机撒冷风机打死了封疆大吏酸辣粉家里的撒放假了手打见风使舵附件丽都水岸就发了打撒就发了打撒开发激发来撒娇飞力达快捷方式独立开发阿萨德浪费萨拉丁发撒老大饭卡手打理发手打拉法基撒发啦",
                                "sfadsklfdaslfjdslaf",
                                "weejeffljfljl",
                                "jdflsakjfljsaflkjsal"]
    
    var postList: [HPostVM] = [HPostVM]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "第五页"
        self.navigationBar.isHidden = true
        self.tupleView.delegate = self
        self.view.addSubview(self.tupleView)
        
        sourceData.forEach { item in
            let postVM = HPostVM()
            postVM.post = item
            postVM.imageUrls = ["11", "22", "33", "44"]
            postVM.videoUrl = "11"
            postList.append(postVM)
        }
        
    }

}


extension HMainController7 {
    func numberOfItemsInSection(_ section: Any) -> Any {
        return postList.count
    }
    func tupleHeader(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseHeader(HTupleBaseApex.self, nil, true, indexPath) as! HTupleBaseApex
        cell.backgroundColor = UIColor.green
    }
    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HPengCell.self, indexPath.stringValue, true, indexPath) as! HPengCell
        cell.backgroundColor = .yellow
        guard indexPath.row < postList.count else { return }
        
        cell.layoutView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 赋值model
        let postVM = postList[indexPath.row]
        cell.postVM = postVM
    }

}

extension HMainController7: HWaterfallMutiSectionDelegate {
    func waterInsetForSection( _ section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    func waterSizeForHeaderInSection(_ section: Int) -> CGSize {
        return CGSize(width: self.view.width, height: 50)
    }
    func waterHeightForItemAtIndexPath(_ indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        if let cell = tupleView.cell(for: indexPath) as? HPengCell {
            let contentSize = cell.tupleView.contentSize
            return contentSize.height
        }
        return 100
    }
    func waterNumberOfColumnsInSection( _ section: Int) -> Int {
        return 2
    }
    func waterLineSpacingForSection( _ section: Int) -> CGFloat {
        return 16.0
    }
    func waterInteritemSpacingForSection( _ section: Int) -> CGFloat {
        return 15.0
    }
}

class HPengCell: HTupleBaseCell, HTupleViewDelegate {
    
    // 帖子model
    private var _postVM: HPostVM?
    var postVM: HPostVM! {
        get { return _postVM }
        set {
            if _postVM?.post != newValue.post {
                _postVM = newValue
                tupleView.reloadTupleData()
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
        self.layoutView.addArrangedSubview(tupleView)
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

extension HPengCell {
    
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
    func tupleExa0_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HTupleBaseCell.self, indexPath.stringValue, true, indexPath) as! HTupleBaseCell
        let frame = cell.layoutViewBounds
        
        var headerView = cell.layoutView.viewWithTag(121314) as? HPostHeader
        if headerView == nil {
            headerView = HPostHeader(frame: frame)
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

extension HPengCell {
    
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
    func tupleExa1_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        switch indexPath.row {
        case 0: //内容
            if postVM.postExtend == .extend {
                let cell = tuple.reuseCell(HTupleLabelCell.self, indexPath.stringValue + "notExtended", true, indexPath) as! HTupleLabelCell
                cell.label.font = UIFont.font(ofSize: 14, weight: .regular)
                cell.label.textColor = UIColor(hex: "#17191E")
                cell.label.numberOfLines = 3
                cell.label.text = postVM.post
            } else {
                let cell = tuple.reuseCell(HTupleLabelCell.self, indexPath.stringValue + "isExtended", true, indexPath) as! HTupleLabelCell
                cell.label.font = UIFont.font(ofSize: 14, weight: .regular)
                cell.label.textColor = UIColor(hex: "#17191E")
                cell.label.numberOfLines = 0
                cell.label.text = postVM.post
            }
        case 1: //更多
            let cell = tuple.reuseCell(HTupleViewCell.self, indexPath.stringValue, true, indexPath) as! HTupleViewCell
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
                    self.tupleView.reloadData()
                }
            }
        default:
            break
        }

    }
    
}

extension HPengCell {
    
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

extension HPengCell {
    
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
        return CGSize(width: postImageSize, height: postImageSize)
    }
    
    @objc
    func tupleExa3_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cell = tuple.reuseCell(HTupleViewCell.self, indexPath.stringValue, true, indexPath) as! HTupleViewCell
            let frame = cell.layoutViewBounds
            cell.buttonView.frame = frame
            cell.buttonView.backgroundColor = .red
            cell.buttonView.text = "图片"
            cell.buttonView.cornerRadius = 8.0
            cell.buttonView.isUserInteractionEnabled = true
            cell.buttonView.pressed = { (sender, data) in
                NSLog("图片")
            }
            
        } else if indexPath.row == 1 {
            
            let cell = tuple.reuseCell(HTupleButtonCell.self, indexPath.stringValue, true, indexPath) as! HTupleButtonCell
            cell.buttonView.backgroundColor = .red
            cell.buttonView.text = "图片"
            cell.buttonView.cornerRadius = 8.0
            cell.buttonView.isUserInteractionEnabled = true
            cell.buttonView.pressed = { (sender, data) in
                NSLog("图片")
            }

        }  else if indexPath.row == 2 {
            
            let cell = tuple.reuseCell(HTupleButtonCell.self, indexPath.stringValue, true, indexPath) as! HTupleButtonCell
            
            //四张图片时由于布局的特殊性，多添加了一个item
            if let count = postVM.imageUrls?.count, count == 4 {
                cell.buttonView.isUserInteractionEnabled = false
            } else {
                cell.buttonView.backgroundColor = .red
                cell.buttonView.isUserInteractionEnabled = true
                cell.buttonView.text = "图片"
                cell.buttonView.cornerRadius = 8.0
                cell.buttonView.pressed = { (sender, data) in
                    NSLog("图片")
                }
            }
            
        } else {
            
            let cell = tuple.reuseCell(HTupleButtonCell.self, indexPath.stringValue, true, indexPath) as! HTupleButtonCell
            cell.buttonView.backgroundColor = .red
            cell.buttonView.isUserInteractionEnabled = true
            cell.buttonView.text = "图片"
            cell.buttonView.cornerRadius = 8.0
            
            //四张图片时由于布局的特殊性，多添加了一个item
            if let count = postVM.imageUrls?.count, count == 4 {
                
                cell.buttonView.pressed = { (sender, data) in
                    //let row = indexPath.row - 1
                    NSLog("图片")
                }
                
            } else {
                
                cell.buttonView.pressed = { (sender, data) in
                    //let row = indexPath.row
                    NSLog("图片")
                }
            }
            
        }

    }
    
}

extension HPengCell {
    
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
    func tupleExa4_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HTupleButtonCell.self, indexPath.stringValue, true, indexPath) as! HTupleButtonCell
        cell.buttonView.backgroundColor = .red
        cell.buttonView.text = "视频"
        cell.buttonView.cornerRadius = 8.0
        cell.buttonView.pressed = { (sender, data) in
            NSLog("视频")
        }
    }
    
}

extension HPengCell {
    
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
    func tupleExa5_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HTupleBaseCell.self, indexPath.stringValue, true, indexPath) as! HTupleBaseCell
        let frame = cell.layoutViewBounds
        
        var footerView = cell.layoutView.viewWithTag(131415) as? HPostFooter
        if footerView == nil {
            footerView = HPostFooter(frame: frame)
            footerView!.tag = 131415
            footerView!.likeButton.pressed = { (sender, data) in
                NSLog("like")
            }
            
            footerView!.commentButton.pressed = { (sender, data) in
                NSLog("comment")
                self.viewController?.navigationController?.pushViewController(HPostCommentVC(), animated: true)
            }
            
            footerView!.shareButton.pressed = { (sender, data) in
                NSLog("share")
            }
            
            footerView!.moreButton.pressed = { (sender, data) in
                NSLog("more")
            }
            cell.layoutView.addSubview(footerView!)
        }
        footerView!.likeButton.text = "喜欢"
        footerView!.commentButton.text = "评论"
        footerView!.shareButton.text = "分享"
        footerView!.moreButton.text = "更多"
    }
    
}
