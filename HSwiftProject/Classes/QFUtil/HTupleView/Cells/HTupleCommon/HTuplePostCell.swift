//
//  HTuplePostCell.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/8.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

private var edgeSpace = 16.0
private var lineSpace = 16.0

private var imageSpace = 8.0
private var imageSize = 60.0
private var videoSize = 90.0

private var extendSpace = 28.0
private var translateSpace = 28.0

private var textHeightOmit = 60.0

class HTuplePostCell: UIStackView, HTupleViewDelegate {
    
    var postVM: HTuplePostVM!
    
    // 父类tuple view
    weak var tuple: HTupleView?
    
    // 文字内容
//    var content: String? {
//        didSet {
//            if let ct = content, ct.count > 0 {
//                postVM.textHeight = ct.heightWithFont(UIFont.font(ofSize: 14, weight: .regular), constrainedToWidth: UIScreen.width - 32)
//                // 是否显示更多信息
//                postVM.extend = (postVM.textHeight > textHeightOmit)
//                // 是否需要翻译
//                postVM.translate = true
//
//            } else {
//                // 是否显示更多信息
//                postVM.extend = false
//                // 是否需要翻译
//                postVM.translate = false
//            }
//        }
//    }
    
    // 是否显示更多信息
//    var extend: Bool = false
//
//    // 是否显示更多信息
//    var isExtended: Bool = false
//
//    // 是否需要翻译
//    var translate: Bool = false
//
//    // 是否已经翻译过了
//    var isTranslated: Bool = false
//
//    // 图片
//    var imageUrls: [String]?
//
//    // 视频
//    var videoUrl: String?
//
//    // text高度
//    var textHeight: CGFloat = 0.0
    
    // cell高度
//    var cellHeight: CGFloat {
//        var tmpHeight = 0.0
//        // text高度
//        if postVM.extend, !postVM.isExtended {
//            tmpHeight += textHeightOmit + lineSpace
//        } else {
//            tmpHeight += postVM.textHeight + lineSpace
//        }
//        // 是否需要翻译
//        if postVM.translate {
//            // 是否已经翻译过了
//            if postVM.isTranslated {
//                tmpHeight += postVM.textHeight
//            } else {
//                tmpHeight += translateSpace
//            }
//        }
//        // 视频
//        if let count = postVM.imageUrls?.count, count > 0 {
//            let cc = ceil(CGFloat((count - 1) / 2))
//            let height = (cc + 1) * imageSize + cc * imageSpace
//            tmpHeight += height + lineSpace
//        }
//        // 视频
//        if postVM.videoUrl?.count ?? 0 > 0 {
//            tmpHeight += videoSize + lineSpace
//        }
//        return tmpHeight
//    }
    
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
        return UIEdgeInsets(top: 24, left: edgeSpace, bottom: 0, right: edgeSpace)
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
//        if content?.count ?? 0 > 0 {
//            items += 1
//            // 是否显示更多信息
//            if extend, !isExtended {
//                items += 1
//            }
//        }
        if postVM.post?.count ?? 0 > 0 {
            items += 1
            // 是否显示更多信息
            if postVM.extend, !postVM.isExtended {
                items += 1
            }
        }
        return items
    }
    
    @objc
    func tupleExa1_insetForSection(_ section: Any) -> Any {
//        if content?.count ?? 0 > 0 {
//            return UIEdgeInsets(top: lineSpace, left: edgeSpace, bottom: 0, right: edgeSpace)
//        } else {
//            return UIEdgeInsets(top: 0, left: edgeSpace, bottom: 0, right: edgeSpace)
//        }
        if postVM.post?.count ?? 0 > 0 {
            return UIEdgeInsets(top: lineSpace, left: edgeSpace, bottom: 0, right: edgeSpace)
        } else {
            return UIEdgeInsets(top: 0, left: edgeSpace, bottom: 0, right: edgeSpace)
        }
    }
    
    @objc
    func tupleExa1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        
        var row = indexPath.row
        //更多不显示、翻译显示
        if row > 0, !postVM.extend, postVM.translate {
            if !postVM.isExtended {
                row += 1
            }
        }
        
        switch row {
        case 0:
            if postVM.extend, !postVM.isExtended {
                return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: textHeightOmit)
            } else {
                return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postVM.textHeight)
            }
        case 1:
            return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: extendSpace)
        default:
            break
        }
        return CGSize(width: self.tupleView.width, height: self.tupleView.height)
    }
    
    @objc
    func tupleExa1_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        
        var row = indexPath.row
        //更多不显示、翻译显示
        if row > 0, !postVM.extend, postVM.translate {
            if !postVM.isExtended {
                row += 1
            }
        }
        
        switch row {
        case 0: //内容
            if postVM.extend, !postVM.isExtended {
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
            let width = "显示更多".widthWithFont(UIFont.font(ofSize: 14, weight: .regular), constrainedToHeight: extendSpace - 8.0)

            cell.buttonView.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
            cell.buttonView.textFont = UIFont.font(ofSize: 14, weight: .regular)
            cell.buttonView.textColor = UIColor(hex: "#3879FC")
            cell.buttonView.text = "显示更多"
            cell.buttonView.pressed = { (sender, data) in
                self.postVM.isExtended = true
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
        if postVM.extend, postVM.isExtended {
            if postVM.translate {
                items += 1
            }
        } else if !postVM.extend {
            if postVM.translate {
                items += 1
            }
        }
        
//        if !extend || isExtended {
//            if translate {
//                items += 1
//            }
//        }
        
//        if !extend, translate {
//            items += 1
//        }
        return items
    }
    
    @objc
    func tupleExa2_insetForSection(_ section: Any) -> Any {
        // 是否需要翻译
//        if !extend, translate {
//            return UIEdgeInsets(top: 8, left: edgeSpace, bottom: 0, right: edgeSpace)
//        } else {
//            return UIEdgeInsets(top: 0, left: edgeSpace, bottom: 0, right: edgeSpace)
//        }
        if postVM.extend, postVM.isExtended {
            if postVM.translate {
                return UIEdgeInsets(top: 8, left: edgeSpace, bottom: 0, right: edgeSpace)
            }
        } else if !postVM.extend {
            if postVM.translate {
                return UIEdgeInsets(top: 8, left: edgeSpace, bottom: 0, right: edgeSpace)
            }
        }
//        if !extend || isExtended {
//            if translate {
//                return UIEdgeInsets(top: 8, left: edgeSpace, bottom: 0, right: edgeSpace)
//            }
//        }
        return UIEdgeInsets(top: 0, left: edgeSpace, bottom: 0, right: edgeSpace)
    }
    
    @objc
    func tupleExa2_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        // 是否已经翻译过了
//        if isTranslated {
//            return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: textHeight)
//        } else {
//            return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: translateSpace - 8.0)
//        }
        
//        if extend, isExtended {
//            if isTranslated {
//                return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: textHeight)
//            } else {
//                return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: translateSpace - 8.0)
//            }
//        } else if !extend {
//            if isTranslated {
//                return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: textHeight)
//            } else {
//                return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: translateSpace - 8.0)
//            }
//        } else {
//            if isTranslated {
//                return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: textHeight)
//            } else {
//                return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: translateSpace - 8.0)
//            }
//        }
        
        if postVM.extend, postVM.isExtended {
            if postVM.translate {
                if postVM.isTranslated {
                    return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postVM.textHeight)
                } else {
                    return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: translateSpace - 8.0)
                }
            }
        } else if !postVM.extend {
            if postVM.translate {
                if postVM.isTranslated {
                    return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: postVM.textHeight)
                } else {
                    return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: translateSpace - 8.0)
                }
            }
        }
        
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: translateSpace - 8.0)
        
//        if !extend || isExtended {
//            if isTranslated {
//                return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: textHeight)
//            } else {
//                return CGSize.zero
//            }
//        } else {
//            return CGSize.zero
//        }
        
    }
    
    @objc
    func tupleExa2_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        // 是否已经翻译过了
        if postVM.isTranslated {
            let cell = itemBlock(nil, HTupleLabelCell.self, indexPath.stringValue, true) as! HTupleLabelCell
            cell.label.font = UIFont.font(ofSize: 14, weight: .regular)
            cell.label.textColor = UIColor(hex: "#17191E")
            cell.label.numberOfLines = 0
            cell.label.text = postVM.post
        } else {
            let cell = itemBlock(nil, HTupleViewCell.self, indexPath.stringValue, true) as! HTupleViewCell
            
            let frame = cell.layoutViewBounds
            let width = "翻译内容".widthWithFont(UIFont.font(ofSize: 14, weight: .regular), constrainedToHeight: translateSpace - 8.0)
            
            cell.buttonView.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
            cell.buttonView.textFont = UIFont.font(ofSize: 14, weight: .regular)
            cell.buttonView.textColor = UIColor(hex: "#3879FC")
            cell.buttonView.text = "翻译内容"
            
            cell.buttonView.pressed = { (sender, data) in
                // 是否已经翻译过了
                self.postVM.isTranslated = true
//                self.postVM.translate = false
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
            return UIEdgeInsets(top: lineSpace, left: edgeSpace, bottom: 0, right: edgeSpace)
        } else {
            return UIEdgeInsets(top: 0, left: edgeSpace, bottom: 0, right: edgeSpace)
        }
    }
    
    @objc
    func tupleExa3_minimumLineSpacingForSectionAt(_ section: Any) -> Any {
        return imageSpace
    }
    
    @objc
    func tupleExa3_minimumInteritemSpacingForSectionAt(_ section: Any) -> Any {
        return imageSpace
    }
    
    @objc
    func tupleExa3_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        let width = (self.tupleView.width(forSection: indexPath.section) - 2 * imageSpace) / 3
        return CGSize(width: width, height: imageSize)
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
            return UIEdgeInsets(top: lineSpace, left: edgeSpace, bottom: 0, right: edgeSpace)
        } else {
            return UIEdgeInsets(top: 0, left: edgeSpace, bottom: 0, right: edgeSpace)
        }
    }
    
    @objc
    func tupleExa4_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width(forSection: indexPath.section), height: videoSize)
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
        return UIEdgeInsets(top: lineSpace, left: edgeSpace, bottom: 25, right: edgeSpace)
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
