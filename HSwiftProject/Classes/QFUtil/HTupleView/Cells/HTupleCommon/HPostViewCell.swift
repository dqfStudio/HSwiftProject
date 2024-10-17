//
//  HPostViewCellCell.swift
//  HPostViewCell
//
//  Created by owner on 2024/5/26.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HPostViewCell: HTupleTmplCell, HTupleViewDelegate {
    
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

extension HPostViewCell {
    
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
        let cell = tuple.reuseCell(HTupleTmplCell.self, indexPath.stringValue, true, indexPath) as! HTupleTmplCell
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

extension HPostViewCell {
    
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

extension HPostViewCell {
    
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

extension HPostViewCell {
    
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

extension HPostViewCell {
    
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

extension HPostViewCell {
    
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
        let cell = tuple.reuseCell(HTupleTmplCell.self, indexPath.stringValue, true, indexPath) as! HTupleTmplCell
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

class HPostCustomViewCell: HTupleTmplCell {
    
    lazy var postMaskView: HPostMaskView = {
        return HPostMaskView()
    }()
    
    lazy var postHeaderView: HPostHeaderView = {
        return HPostHeaderView()
    }()
    
    lazy var postTextView: HPostTextView = {
        return HPostTextView()
    }()
    lazy var postImageView: HPostImageView = {
        return HPostImageView()
    }()
    lazy var postVideoView: HPostVideoView = {
        return HPostVideoView()
    }()
    
    lazy var postFooterView: HPostFooterView = {
        return HPostFooterView()
    }()
    
    override func initUI() {
        self.contentView.addSubview(postHeaderView)
        self.contentView.addSubview(postTextView)
        self.contentView.addSubview(postImageView)
        self.contentView.addSubview(postVideoView)
        self.contentView.addSubview(postFooterView)
//        self.contentView.addSubview(postMaskView)
    }
    
    func updateData(item: HPostVM, cellWidth: CGFloat, indexPath: IndexPath) {
        
        // postHeaderView
        self.postHeaderView.makeFrame {
            return CGRect(x: 0, y: 0, width: cellWidth, height: 48)
        }
        self.postHeaderView.avatarButton.backgroundColor = .red
        self.postHeaderView.nameLabel.makeFrame {
            return CGRect(x: 58, y: 0, width: 300, height: 24)
        }
        self.postHeaderView.nameLabel.text = "postVM.name"
        self.postHeaderView.dateLabel.makeFrame {
            return CGRect(x: 58, y: 26, width: 300, height: 22)
        }
        self.postHeaderView.dateLabel.text = "postVM.date"
        
        // postTextView
        self.postTextView.textView.text = item.post
        self.postTextView.textView.font = UIFont.font(ofSize: 14, weight: .regular)
        self.postTextView.textView.textContainer.lineFragmentPadding = 0
        self.postTextView.textView.textContainerInset = UIEdgeInsets.zero
        self.postTextView.textView.isUserInteractionEnabled = false
        self.postTextView.textView.isScrollEnabled = false
        self.postTextView.textView.isEditable = false
        self.postTextView.textView.isSelectable = true
        self.postTextView.textView.backgroundColor = .blue
        
        let textHeight = self.postTextView.textView.textHeight(with: cellWidth)
        self.postTextView.makeFrame {
            var frame = CGRect.zero
            frame.y = self.postHeaderView.maxY + 10
            frame.width = cellWidth
            frame.height = textHeight
            return frame
        }
        
        // postImageView
        self.postImageView.makeFrame {
            var frame = CGRect.zero
            frame.y = self.postTextView.maxY + 10
            frame.width = cellWidth
            frame.height = 110
            return frame
        }
        self.postImageView.buttonView1.backgroundColor = .red
        self.postImageView.buttonView1.makeFrame {
            var frame = CGRect.zero
            frame.width = 100
            frame.height = 50
            return frame
        }
        
        self.postImageView.buttonView2.backgroundColor = .red
        self.postImageView.buttonView2.makeFrame {
            var frame = CGRect.zero
            frame.x = 110
            frame.width = 100
            frame.height = 50
            return frame
        }
        
        self.postImageView.buttonView3.backgroundColor = .red
        self.postImageView.buttonView3.makeFrame {
            var frame = CGRect.zero
            frame.y = 60
            frame.width = 100
            frame.height = 50
            return frame
        }
        
        self.postImageView.buttonView4.backgroundColor = .red
        self.postImageView.buttonView4.makeFrame {
            var frame = CGRect.zero
            frame.x = 110
            frame.y = 60
            frame.width = 100
            frame.height = 50
            return frame
        }
        
        // postVideoView
        self.postVideoView.backgroundColor = .red
        self.postVideoView.makeFrame {
            var frame = CGRect.zero
            frame.y = self.postImageView.maxY + 10
            frame.width = cellWidth
            frame.height = 80
            return frame
        }
        
        // postFooterView
        self.postFooterView.likeButton.text = "喜欢"
        self.postFooterView.commentButton.text = "评论"
        self.postFooterView.shareButton.text = "分享"
        self.postFooterView.moreButton.text = "更多"
        self.postFooterView.makeFrame {
            var frame = CGRect.zero
            frame.y = self.postVideoView.maxY + 10
            frame.width = cellWidth
            frame.height = 40
            return frame
        }
        
        if let tuple = self.tuple as? HTupleView {
            tuple.cellHeights[indexPath.row] = self.postFooterView.maxY
            tuple.reloadIfNeeded()
        }

    }

}

class HPostMaskView: UIView {
//    lazy var maskView: UIView = {
//        return UIView()
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
//        self.addSubview(maskView)
//        maskView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

class HPostHeaderView: UIView {
    lazy var avatarButton: HWebButtonView = {
        let frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        let button = HWebButtonView(frame: frame)
        button.cornerRadius = 8
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let x = avatarButton.maxX + 12
        let w = self.width - x
        let h = 24.0
        let frame = CGRect(x: x, y: 0, width: w, height: h)
        let label = UILabel(frame: frame)
        label.textColor = UIColor(hex: "#17191E")
        label.font = UIFont.font(ofSize: 17.0, weight: .medium)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let x = avatarButton.maxX + 12
        let y = nameLabel.maxY + 4
        let w = self.width - x
        let h = 20.0
        let frame = CGRect(x: x, y: y, width: w, height: h)
        let label = UILabel(frame: frame)
        label.textColor = UIColor(hex: "#9B9FA8")
        label.font = UIFont.font(ofSize: 14.0, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(avatarButton)
        self.addSubview(nameLabel)
        self.addSubview(dateLabel)
    }
}

class HPostTextView: UIView {
    lazy var textView: UITextView = {
        return UITextView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(textView)
        textView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

class HPostImageView: UIView {
    lazy var buttonView1: HWebButtonView = {
        return HWebButtonView()
    }()
    lazy var buttonView2: HWebButtonView = {
        return HWebButtonView()
    }()
    lazy var buttonView3: HWebButtonView = {
        return HWebButtonView()
    }()
    lazy var buttonView4: HWebButtonView = {
        return HWebButtonView()
    }()
    
    lazy var buttonView5: HWebButtonView = {
        return HWebButtonView()
    }()
    lazy var buttonView6: HWebButtonView = {
        return HWebButtonView()
    }()
    lazy var buttonView7: HWebButtonView = {
        return HWebButtonView()
    }()
    lazy var buttonView8: HWebButtonView = {
        return HWebButtonView()
    }()
    lazy var buttonView9: HWebButtonView = {
        return HWebButtonView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(buttonView1)
        self.addSubview(buttonView2)
        self.addSubview(buttonView3)
        self.addSubview(buttonView4)
        self.addSubview(buttonView5)
        self.addSubview(buttonView6)
        self.addSubview(buttonView7)
        self.addSubview(buttonView8)
        self.addSubview(buttonView9)
    }
}

class HPostVideoView: UIView {
    lazy var buttonView: HWebButtonView = {
        return HWebButtonView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(buttonView)
        buttonView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

class HPostFooterView: UIStackView {
    
    lazy var likeButton: HWebButtonView = {
        let button = HWebButtonView(frame: .zero)
        //button.imagePosition = .left
        //button.imageSpace = 4.0
        button.textColor = UIColor(hex: "#727781")
        button.textFont = UIFont.font(ofSize: 12.0, weight: .medium)
        //button.setImage(UIImage(named: "square_post_like"), for: .normal)
        //button.setImage(UIImage(named: "square_post_like_sel"), for: .selected)
        return button
    }()
    
    lazy var commentButton: HWebButtonView = {
        let button = HWebButtonView(frame: .zero)
        //button.imagePosition = .left
        //button.imageSpace = 4.0
        button.textColor = UIColor(hex: "#727781")
        button.textFont = UIFont.font(ofSize: 12.0, weight: .medium)
        //button.setImage(UIImage(named: "square_post_comment"), for: .normal)
        return button
    }()
    
    lazy var shareButton: HWebButtonView = {
        let button = HWebButtonView(frame: .zero)
        //button.imagePosition = .left
        //button.imageSpace = 4.0
        button.textColor = UIColor(hex: "#727781")
        button.textFont = UIFont.font(ofSize: 12.0, weight: .medium)
        //button.setImage(UIImage(named: "square_post_share"), for: .normal)
        return button
    }()
    
    lazy var moreButton: HWebButtonView = {
        let button = HWebButtonView(frame: .zero)
        button.textColor = UIColor(hex: "#727781")
        button.textFont = UIFont.font(ofSize: 12.0, weight: .medium)
        //button.setImage(UIImage(named: "square_post_more"), for: .normal)
        return button
    }()
    
    required init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        self.addArrangedSubview(likeButton)
        self.addArrangedSubview(commentButton)
        self.addArrangedSubview(shareButton)
        self.addArrangedSubview(moreButton)
        self.distribution = .equalSpacing
    }
    
}
