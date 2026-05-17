//
//  HPostVC.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/9.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HPostVC: HViewController, HTupleViewDelegate {
    
    lazy var tupleView: HTupleView = {
        var frame = UIScreen.bound
        frame.size.height -= UIScreen.topBarHeight + (UIScreen.bottomBarHeight + 10)
        return HTupleView.tupleFrame {
            return frame
        } mode: {
            return .delegate
        } layout: {
            return HTupleViewLayout(.vertical, .manual)
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
            postVM.imageUrls = [
                "https://picsum.photos/seed/1/400/600",
                "https://picsum.photos/seed/2/600/400",
                "https://picsum.photos/seed/3/300/300",
            ]
            postVM.videoUrl = "11"
            postList.append(postVM)
        }
        
        self.tupleView.reloadData()
        
    }
    
    func numberOfItemsInSection(_ section: Any) -> Any {
        return postList.count
    }
    
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        let item = self.postList[indexPath.item]
        let cellWidth = self.tupleView.width(forSection: indexPath.section)
        let cellHeight = HTupleLayout.getPost(item: item, tuple: tupleView, cellWidth: cellWidth, at: indexPath)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        let cell = tuple.reuseCell(HPostCustomViewCell.self, nil, false, indexPath) as! HPostCustomViewCell
        cell.backgroundColor = .yellow
        
        guard indexPath.row < postList.count else { return }
        let postVM = postList[indexPath.row]
        cell.updateData(item: postVM, cellWidth: tuple.width, indexPath: indexPath)
    }
    
    func willDisplayCell(_ cell: HTupleBaseCell, atIndexPath indexPath: IndexPath) {
        if indexPath.row != postList.count - 1 {
            cell.setBottomLine(withColor: .red, paddingLeft: 16, paddingRight: 16)
        } else {
            cell.bottomLineLayer?.removeFromSuperlayer()
        }
    }

}
