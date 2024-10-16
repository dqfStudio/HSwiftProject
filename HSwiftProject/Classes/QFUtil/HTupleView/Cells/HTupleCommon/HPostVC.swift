//
//  HPostVC.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/9.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HPostVC: HViewController, HTupleViewDelegate {
    
//    lazy var tupleView: HTupleView = {
//        var frame = UIScreen.bound
//        frame.size.height -= UIScreen.topBarHeight + (UIScreen.bottomBarHeight + 10)
//        return HTupleView(frame: frame)
//    }()
    lazy var tupleView: HTupleView = {
        var frame = UIScreen.bound
        frame.size.height -= UIScreen.topBarHeight + (UIScreen.bottomBarHeight + 10)
        return HTupleView.tupleFrame {
            return frame
        } mode: {
            return .delegate
        } layout: {
            return HTupleViewLayout(.vertical, .automatic)
        }
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
        self.navigationBar.isHidden = true
        self.tupleView.delegate = self
        self.view.addSubview(self.tupleView)
        self.tupleView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        sourceData.forEach { item in
            let postVM = HPostVM()
            postVM.post = item
            postVM.imageUrls = ["11", "22", "33", "44"]
            postVM.videoUrl = "11"
            postList.append(postVM)
        }
        
    }

    func numberOfItemsInSection(_ section: Any) -> Any {
        return postList.count
    }
    
//    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
//        if let cell = tupleView.cell(for: indexPath) as? HPostViewCell {
//            return cell.tupleView.contentSize
//        }
//        return CGSize(width: tupleView.bounds.width, height: 100)
//    }
//    
//    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
//        let cell = tuple.reuseCell(HPostViewCell.self, indexPath.stringValue, true, indexPath) as! HPostViewCell
//        cell.backgroundColor = .yellow
//        guard indexPath.row < postList.count else { return }
//        // 赋值model
//        let postVM = postList[indexPath.row]
//        cell.postVM = postVM
//    }
    
    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HPostCustomViewCell.self, indexPath.stringValue, true, indexPath) as! HPostCustomViewCell
        cell.backgroundColor = .yellow
        let cellWidth = tuple.width
        
        guard indexPath.row < postList.count else { return }
        // 赋值model
        let postVM = postList[indexPath.row]

        // postHeaderView
        cell.postHeaderView.avatarButton.backgroundColor = .red
        cell.postHeaderView.nameLabel.frame = CGRect(x: 58, y: 0, width: 300, height: 24)
        cell.postHeaderView.nameLabel.text = "postVM.name"
        cell.postHeaderView.dateLabel.frame = CGRect(x: 58, y: 26, width: 300, height: 22)
        cell.postHeaderView.dateLabel.text = "postVM.date"
        cell.postHeaderView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(cellWidth)
            make.height.equalTo(48)
        }
        
        
        // postTextView
        cell.postTextView.textView.text = postVM.post
        cell.postTextView.textView.font = UIFont.font(ofSize: 14, weight: .regular)
        cell.postTextView.textView.textContainer.lineFragmentPadding = 0
        cell.postTextView.textView.textContainerInset = UIEdgeInsets.zero
        cell.postTextView.textView.isUserInteractionEnabled = false
        cell.postTextView.textView.isScrollEnabled = false
        cell.postTextView.textView.isEditable = false
        cell.postTextView.textView.isSelectable = true
        
        let textHeight = cell.postTextView.textView.textHeight(with: cellWidth)
        cell.postTextView.snp.makeConstraints { make in
            make.top.equalTo(cell.postHeaderView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.width.equalTo(cellWidth)
            make.height.equalTo(textHeight)
        }
        
        
        cell.postImageView.buttonView1.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        cell.postImageView.buttonView1.backgroundColor = .red
        
        cell.postImageView.buttonView2.frame = CGRect(x: 110, y: 0, width: 100, height: 50)
        cell.postImageView.buttonView2.backgroundColor = .red
        
        if indexPath.row == 1 || indexPath.row == 3 {
            cell.postImageView.buttonView3.frame = CGRect(x: 0, y: 60, width: 100, height: 50)
            cell.postImageView.buttonView3.backgroundColor = .red
            
            cell.postImageView.buttonView4.frame = CGRect(x: 110, y: 60, width: 100, height: 50)
            cell.postImageView.buttonView4.backgroundColor = .red
            
            // postImageView
            cell.postImageView.snp.makeConstraints { make in
                make.top.equalTo(cell.postTextView.snp.bottom).offset(10)
                make.left.right.equalToSuperview()
                make.width.equalTo(cellWidth)
                make.height.equalTo(110)
            }
        }else {
            // postImageView
            cell.postImageView.snp.makeConstraints { make in
                make.top.equalTo(cell.postTextView.snp.bottom).offset(10)
                make.left.right.equalToSuperview()
                make.width.equalTo(cellWidth)
                make.height.equalTo(50)
            }
        }
        
        
        // postVideoView
        cell.postVideoView.backgroundColor = .red
        
        cell.postVideoView.snp.makeConstraints { make in
            make.top.equalTo(cell.postImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.width.equalTo(cellWidth)
            make.height.equalTo(80)
        }
        
        
        // postFooterView
        cell.postFooterView.likeButton.text = "喜欢"
        cell.postFooterView.commentButton.text = "评论"
        cell.postFooterView.shareButton.text = "分享"
        cell.postFooterView.moreButton.text = "更多"
        
        cell.postFooterView.snp.makeConstraints { make in
            make.top.equalTo(cell.postVideoView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.width.equalTo(cellWidth)
            make.height.equalTo(40)
        }
        
        if indexPath.row == 0 || indexPath.row == 2 {
            cell.postMaskView.backgroundColor = .blue
            cell.postMaskView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(cell.postTextView.snp.top)
                make.width.equalTo(self.tupleView.width)
                make.bottom.equalTo(cell.postVideoView.snp.bottom)
            }
        }
        
        // contentView
        cell.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self.tupleView.width)
            make.bottom.equalTo(cell.postFooterView.snp.bottom)
        }
        
    }
    
    func willDisplayCell(_ cell: HTupleBaseCell, atIndexPath indexPath: IndexPath) {
        // 添加间隔线
        if indexPath.row != sourceData.count - 1 {
            cell.setBottomLine(withColor: .red, paddingLeft: 16, paddingRight: 16)
        } else {
            cell.bottomLineLayer?.removeFromSuperlayer()
        }
    }

}
