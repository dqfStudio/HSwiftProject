//
//  HPostCommentVC.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/11.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HPostCommentVC: HViewController, HTupleViewDelegate {
    
    lazy var tupleView: HTupleView = {
        var frame = UIScreen.bound
        frame.origin.y += UIScreen.topBarHeight
        frame.size.height -= UIScreen.topBarHeight + (UIScreen.bottomBarHeight + 10)
        return HTupleView(frame: frame)
    }()
    
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
        self.view.addSubview(self.tupleView)
        
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
        if let cell = tupleView.header(for: section) as? HPostCommentViewApex {
            let contentSize = cell.tupleView.contentSize
            return CGSize(width: tupleView.bounds.width, height: contentSize.height)
        }
        return CGSize(width: tupleView.bounds.width, height: 100)
    }
    
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        if let cell = tupleView.cell(for: indexPath) as? HPostCommentViewCell {
            let contentSize = cell.tupleView.contentSize
            return CGSize(width: tupleView.bounds.width, height: contentSize.height)
        }
        return CGSize(width: tupleView.bounds.width, height: 100)
    }
    
    func tupleHeader(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseHeader(HPostCommentViewApex.self, "\(indexPath.section)", true, indexPath) as! HPostCommentViewApex
        cell.backgroundColor = .yellow
        guard indexPath.section < postList.count else { return }

        cell.layoutView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 赋值model
        let postVM = postList[indexPath.section]
        cell.postVM = postVM
    }

    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HPostCommentViewCell.self, "\(indexPath.section)-\(indexPath.row)", true, indexPath) as! HPostCommentViewCell
        cell.backgroundColor = UIColor.green
        guard indexPath.row < postList.count else { return }

        cell.layoutView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 赋值model
        let postVM = postList[indexPath.row]
        cell.postVM = postVM
    }
    
    func willDisplayCell(_ cell: HTupleTmplCell, atIndexPath indexPath: IndexPath) {
        // 添加间隔线
        if indexPath.row != 3 - 1 {
            cell.setBottomLine(color: .red, paddingLeft: 76, paddingRight: 16)
        } else {
            cell.removeBottomLine()
        }
    }

}
