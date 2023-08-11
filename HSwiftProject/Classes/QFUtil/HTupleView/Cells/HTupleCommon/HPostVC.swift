//
//  HPostVC.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/9.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HPostVC: HTupleController {
    
    var sourceData: [String] = ["放假啦束带结发拉屎会计法拉数据发来的撒放假了打撒发给垃圾粉了",
                                "我饿付了款静电纺丝啦",
                                "电风扇两地分居啊射流风机撒冷风机打死了封疆大吏酸辣粉家里的撒放假了手打见风使舵附件丽都水岸就发了打撒就发了打撒开发激发来撒娇飞力达快捷方式独立开发阿萨德浪费萨拉丁发撒老大饭卡手打理发手打拉法基撒发啦",
                                "sfadsklfdaslfjdslaf",
                                "weejeffljfljl",
                                "jdflsakjfljsaflkjsal"]
    
    var postList: [HPostVM] = [HPostVM]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.leftItem.isHidden = true
        self.title = "推荐列表"
        self.tupleView.delegate = self
        self.tupleView.tupleStatus = .block
        
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

    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleBaseCell.self, indexPath.stringValue, true) as! HTupleBaseCell
        cell.backgroundColor = .yellow
        guard indexPath.row < postList.count else { return }
        
        // 添加postCell
        var postCell = cell.viewWithTag(131214) as? HPostView
        if postCell == nil {
            postCell = HPostView(frame: .zero)
            postCell!.tag = 131214
            cell.addSubview(postCell!)
        }
        
        // 赋值model
        let postVM = postList[indexPath.row]
        postCell!.postVM = postVM
        postCell!.tuple = self.tupleView
        
        // 获取cell高度
        let cellHeight = postCell!.postVM.cellHeight
        
        // 重设postCell frame
        if postCell!.height != cellHeight {
            postCell!.frame = CGRect(x: 0, y: 0, width: self.tupleView.width, height: cellHeight)
            postCell!.reloadTupleData()
        }
        
        // 设置cell大小
        cell.sizeBlock = {
            return CGSize(width: self.tupleView.width, height: cellHeight)
        }
    }
    
    func willDisplayCell(_ cell: UICollectionViewCell, atIndexPath indexPath: IndexPath) {
        // 添加间隔线
        if indexPath.row != sourceData.count - 1 {
            cell.setBottomLine(withColor: .red, paddingLeft: 16, paddingRight: 16)
        } else {
            cell.bottomLineLayer?.removeFromSuperlayer()
        }
    }

}
