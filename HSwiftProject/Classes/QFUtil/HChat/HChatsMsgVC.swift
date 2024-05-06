//
//  HChatsMsgVC.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/6.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HChatsMsgVC: HViewController {
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.alwaysBounceVertical = true
        table.keyboardDismissMode = .onDrag
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.tableFooterView = UIView()
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        
        for cellType in MessageCell.allCells {
            table.register(cellType.self, forCellReuseIdentifier: cellType.className)
        }
//        table.mj_header = FCDIYPullHeader(refreshingBlock: { [weak self, weak v] in
//            self?.viewModel.loadMoreMessages(completion: {
//                v?.mj_header?.endRefreshing()
//                self?.scrollToMsgId(msgId: self?.topMsgId ?? "", positon: .top)
//                self?.topMsgId = self?.viewModel.messagesRelay.value.first?.clientMsgID
//                
//            })
//        })
//        table.mj_footer = FCDIYPullFooter(refreshingBlock: { [weak self, weak v] in
//            self?.viewModel.loadLatestMessage(completion: { [weak self] in
//                v?.mj_footer?.endRefreshing()
//                self?.tableView.reloadData()
//                self?.bottomMsgId = self?.viewModel.messagesRelay.value.last?.clientMsgID
//            })
//        })
//        (v.mj_footer as? FCDIYPullFooter)?.canShowLoading(false)
//        table.contentInset.bottom = kTableViewContentInsetBottom
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add custom navigation bar
        self.view.addSubview(self.tableView)
//        self.view.addSubview(tableView)
//        self.view.addSubview(chatBarBackgroundView)

//        chatBarBackgroundView.backgroundColor = .itemBg2
//        chatBarBackgroundView.snp.makeConstraints { make in
//            make.height.equalTo(StandardUI.btnH48)
//            make.width.equalToSuperview()
//            make.top.equalTo(chatBar.snp.bottom)
//        }

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
//            make.left.right.equalToSuperview()
//            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
//            bottomConstraint = make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-ChatToolBar.defaultHeight).constraint
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HChatsMsgVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.viewModel.messagesRelay.value.count
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard self.viewModel.messagesRelay.value.count > indexPath.row else {
//            return UITableViewCell()
//        }
//        var item = self.viewModel.messagesRelay.value[indexPath.row]
//        let isRight = item.isSelf
//        var cellType = MessageCell.getCellType(by: item, isRight: isRight)
//        // 判断被添加好友时的cell显示
//        if isRight, item.contentType == .friendAdded { //他人发送好友申请，此时的发送好友请求者是“对方”，做好消息cell显示处理
//            item.content = String(format: "您已添加了「%@」为好友，现在可以开始聊天了".localized(), self.viewModel.conversation.showName ?? "")
//        } else if !isRight, item.contentType == .friendAdded { //我发送好友申请
//            cellType = MessageTextLeftTableViewCell.self
//            item.content = "我通过了你的朋友验证请求，现在我们可以开始聊天了".localized()
//            item.senderFaceUrl = self.viewModel.conversation.faceURL
//        }

//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellType.className") as! MessageCellAble
        let cellType = MessageCell.getCellType(by: nil, isRight: true)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.className) as! MessageBaseRightTableViewCell
//        cell.backgroundColor = UIColor.bg
//        let isC2C = self.viewModel.conversation.conversationType == .c2c
//        let extraInfo = ExtraInfo(isC2C: isC2C, translateItem: nil)
//        cell.setMessage(model: item, extraInfo: extraInfo)
//        cell.delegate = self
        
        cell.nameLabel.text = "连接法兰束带结发酸辣粉较大司法局萨达林枫；垃圾啊圣诞快乐富家大室；发家史代理费；久啊圣诞快乐发； 阿德及时反馈几点撒；发来得及挖方；领导撒娇了；我饿甲方；离开家发三；代理费觉得"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard self.viewModel.messagesRelay.value.count > indexPath.row else { return }
//        let item = self.viewModel.messagesRelay.value[indexPath.row]
//        let isRight = item.isSelf
//        let cellType = MessageCell.getCellType(by: item, isRight: isRight)
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.className)
//        if let cell = cell as? MessageImageLeftTableViewCell {
//            cell.imageContentView.kf.cancelDownloadTask()
//            cell.avatarImageView.kf.cancelDownloadTask()
//        } else if let cell = cell as? MessageImageRightTableViewCell {
//            cell.imageContentView.kf.cancelDownloadTask()
//            cell.avatarImageView.kf.cancelDownloadTask()
//        } else {
//            if isRight {
//                (cell as? MessageBaseRightTableViewCell)?.avatarImageView.kf.cancelDownloadTask()
//            } else {
//                (cell as? MessageBaseLeftTableViewCell)?.avatarImageView.kf.cancelDownloadTask()
//            }
//        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        self.chatBar.textInputView.resignFirstResponder()
//        self.isAtBottom = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let height = self.tableView.bounds.height
//        let contentOffsetY = self.tableView.contentOffset.y
//        let bottomOffset = self.tableView.contentSize.height - contentOffsetY
//        if bottomOffset <= height {
//            self.isAtBottom = true
//        }
    }
}
