//
//  MessageCellAble.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/6.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

protocol MessageCellAble: UITableViewCell {
    func setMessage(model: MessageInfo, extraInfo: ExtraInfo?)

    var delegate: MessageDelegate? { get set }
}

protocol MessageDelegate: AnyObject {
    func didTapMessageCell(cell: UITableViewCell, with message: MessageInfo)
    func didLongPressBubbleView(cell: UITableViewCell, bubbleView: UIView, with message: MessageInfo)
    func didTapResendBtn(with message: MessageInfo)
    func didTapAvatar(with message: MessageInfo)
    func didLongPressAvatar(with message: MessageInfo)
    func didDoubleTapMessageCell(cell: UITableViewCell, with message: MessageInfo)
    func didTapQuoteView(cell: UITableViewCell, with message: MessageInfo)
    func didTapUrl(with message: String) //点击链接
//    func didTapURLCard(cell: UITableViewCell, message: MessageInfo, url: String?, type: MessageURLType, linkParam: MessageURLProtocol?) //点击链接卡片
//    func didTapTranslateCard(cell: UITableViewCell, message: MessageInfo, translateItem: ChatTranslateResultItem)
//    func didLongPressTranslateCard(translateView: UIView, message: MessageInfo, translateItem: ChatTranslateResultItem)
    func didTapExpend(cell: UITableViewCell, with message: MessageInfo)
    func reloadTableView(cell: UITableViewCell?)
}

struct ExtraInfo {
    let isC2C: Bool
//    let translateItem: ChatTranslateResultItem?
}

enum MessageCell {
    static let allCells: [UITableViewCell.Type] = [
        MessageBaseRightTableViewCell.self
//        MessageTextLeftTableViewCell.self,
//        MessageTextRightTableViewCell.self,
//        MessageAudioLeftTableViewCell.self,
//        MessageAudioRightTableViewCell.self,
//        MessageVideoLeftTableViewCell.self,
//        MessageVideoRightTableViewCell.self,
//        MessageBusinessCardLeftTableViewCell.self,
//        MessageBusinessCardRightTableViewCell.self,
//        MessageImageLeftTableViewCell.self,
//        MessageImageRightTableViewCell.self,
//        MessageQuoteLeftTableViewCell.self,
//        MessageQuoteRightTableViewCell.self,
//        MessageTimeOrTipsTableViewCell.self,
//        MessageTransferRightCell.self,
//        MessageTransferLeftCell.self,
//        MessageRedPacketsRightCell.self,
//        MessageRedPacketsLeftCell.self,
//        MessageVideoCallRightCell.self,
//        MessageVideoCallLeftCell.self
    ]

//    static let rightCellsMap: [MessageContentType: MessageCellAble.Type] = [
//        .text: MessageTextRightTableViewCell.self,
//        .at: MessageTextRightTableViewCell.self,
//        .audio: MessageAudioRightTableViewCell.self,
//        .video: MessageVideoRightTableViewCell.self,
//        .card: MessageBusinessCardRightTableViewCell.self,
//        .quote: MessageQuoteRightTableViewCell.self,
//        .image: MessageImageRightTableViewCell.self,
//        .custom: MessageTransferRightCell.self //转账
//    ]

//    static let leftCellsMap: [MessageContentType: MessageCellAble.Type] = [
//        .text: MessageTextLeftTableViewCell.self,
//        .at: MessageTextLeftTableViewCell.self,
//        .audio: MessageAudioLeftTableViewCell.self,
//        .video: MessageVideoLeftTableViewCell.self,
//        .card: MessageBusinessCardLeftTableViewCell.self,
//        .quote: MessageQuoteLeftTableViewCell.self,
//        .image: MessageImageLeftTableViewCell.self,
//        .custom: MessageTransferLeftCell.self //转账
//    ]

    static func getCellType(by message: MessageInfo?, isRight: Bool) -> MessageCellAble.Type {
        return MessageBaseRightTableViewCell.self
    }
//    static func getCellType(by message: MessageInfo, isRight: Bool) -> MessageCellAble.Type {
//        if isRight {
//            if message.contentType == .custom {
//                if message.customElem?.ext == CustomElemExt.transfer.rawValue {
//                    return MessageTransferRightCell.self
//                } else if message.customElem?.ext == CustomElemExt.call.rawValue {
//                    return MessageVideoCallRightCell.self
//                } else if message.customElem?.ext == CustomElemExt.redPackets.rawValue, GlobalSwitch.share.redPacket {
//                    return MessageRedPacketsRightCell.self
//                } else {
//                    return MessageTimeOrTipsTableViewCell.self
//                }
//            } else {
//                // 如果是at+引用，这显示引用cell
//                if message.contentType == .at, message.atElem?.quoteMessage != nil {
//                    return MessageQuoteRightTableViewCell.self
//                } else {
//                    let cellType = rightCellsMap[message.contentType] ?? MessageTimeOrTipsTableViewCell.self
//                    return cellType
//                }
//            }
//        }
//        
//        if message.contentType == .custom {
//            if message.customElem?.ext == CustomElemExt.transfer.rawValue {
//                return MessageTransferLeftCell.self
//            } else if message.customElem?.ext == CustomElemExt.call.rawValue {
//                return MessageVideoCallLeftCell.self
//            } else if message.customElem?.ext == CustomElemExt.redPackets.rawValue, GlobalSwitch.share.redPacket {
//                return MessageRedPacketsLeftCell.self
//            } else {
//                return MessageTimeOrTipsTableViewCell.self
//            }
//        } else if message.contentType == .systemNoti { //系统通知类型
//            return MessageTextLeftTableViewCell.self
//        } else {
//            // 如果是at+引用，这显示引用cell
//            if message.contentType == .at, message.atElem?.quoteMessage != nil {
//                return MessageQuoteLeftTableViewCell.self
//            } else {
//                let cellType = leftCellsMap[message.contentType] ?? MessageTimeOrTipsTableViewCell.self
//                return cellType
//            }
//        }
//    }
}
