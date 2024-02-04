//
//  HPostCommentVC.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/11.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HPostCommentVC: HTupleController {
    
    var sourceData: [String] = ["放假啦束带结发拉屎会计法拉数据发来的撒放假了打撒发给垃圾粉了",
                                "我饿付了款静电纺丝啦",
                                "电风扇两地分居啊射流风机撒冷风机打死了封疆大吏酸辣粉家里的撒放假了手打见风使舵附件丽都水岸就发了打撒就发了打撒开发激发来撒娇飞力达快捷方式独立开发阿萨德浪费萨拉丁发撒老大饭卡手打理发手打拉法基撒发啦啦啦啦啦啦啦啦",
                                "sfadsklfdaslfjdslaf",
                                "weejeffljfljl",
                                "jdflsakjfljsaflkjsal"]
    
    var postList: [HPostCommentVM] = [HPostCommentVM]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评论列表"
        self.tupleView.delegate = self
        
        sourceData.forEach { item in
            let postVM = HPostCommentVM()
            postVM.post = item
            postList.append(postVM)
        }
        
    }
    
    func numberOfSectionsInTupleView() -> Any {
        return postList.count
    }

    func numberOfItemsInSection(_ section: Any) -> Any {
        return 3
    }
    
    func sizeForHeaderInSection(_ section: Any) -> Any {
        let section = section as! Int
        guard section < postList.count else { return CGSize.zero }
        let postVM = postList[section]
        return CGSize(width: self.tupleView.width, height: postVM.cellHeight)
    }
    
    func tupleHeader(_ headerBlock: Any, inSection section: Any) {
        let section = section as! Int
        let headerBlock = headerBlock as! HTupleHeader
        let cell = headerBlock(HTupleBaseApex.self, "\(section)", true) as! HTupleBaseApex
        cell.backgroundColor = .yellow
        guard section < postList.count else { return }
        
        // 添加postCell
        var postCell = cell.viewWithTag(131214) as? HPostCommentView
        if postCell == nil {
            postCell = HPostCommentView(frame: .zero)
            postCell!.tag = 131214
            cell.addSubview(postCell!)
        }
        
        // 赋值model
        let postVM = postList[section]
        postCell!.postVM = postVM
        postCell!.tuple = self.tupleView
        
        // 获取cell高度
        let cellHeight = postVM.cellHeight
        
        // 重设postCell frame
        if postCell!.height != cellHeight {
            postCell!.frame = CGRect(x: 0, y: 0, width: self.tupleView.width, height: cellHeight)
            postCell!.reloadTupleData()
        }
    }

    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(HTupleBaseCell.self, indexPath.stringValue, true) as! HTupleBaseCell
        cell.backgroundColor = .green
        guard indexPath.row < postList.count else { return }

        // 添加postCell
        var postCell = cell.viewWithTag(131215) as? HPostCommentView
        if postCell == nil {
            postCell = HPostCommentView(frame: .zero)
            postCell!.tag = 131215
            cell.addSubview(postCell!)
        }

        // 赋值model
        let postVM = postList[indexPath.row]
        postCell!.postVM = postVM
        postCell!.tuple = self.tupleView

        // 获取cell高度
        let cellHeight = postVM.cellHeight

        // 重设postCell frame
        if postCell!.height != cellHeight {
            postCell!.frame = CGRect(x: 60, y: 0, width: self.tupleView.width - 60, height: cellHeight)
            postCell!.reloadTupleData()
        }

        // 设置cell大小
//        cell.sizeBlock = {
//            return CGSize(width: self.tupleView.width, height: cellHeight)
//        }
    }
    
    func willDisplayCell(_ cell: HTupleBaseCell, atIndexPath indexPath: IndexPath) {
        // 添加间隔线
        if indexPath.row != 3 - 1 {
            cell.setBottomLine(withColor: .red, paddingLeft: 76, paddingRight: 16)
        } else {
            cell.bottomLineLayer?.removeFromSuperlayer()
        }
    }

}
