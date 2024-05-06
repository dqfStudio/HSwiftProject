//
//  MessageInfo.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/6.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

public struct MessageInfo: Codable, Hashable {
    var clientMsgID: String?
    var serverMsgID: String?
    var createTime: TimeInterval = 0
    var sendTime: TimeInterval = 0
//    var sessionType: ConversationType = .c2c
//    var sendID: String?
//    var recvID: String?
//    var handleMsg: String?
//    var msgFrom: MessageLevel = .user
//    var contentType: MessageContentType = .unknown
//    var platformID: Int = 0
//    var senderNickname: String?
//    var senderFaceUrl: String?
//    var groupID: String?
//    var content: String?
//    /// 消息唯一序列号
//    var seq: Int = 0
//    var isRead: Bool = false
//    var status: MessageStatus = .undefine
//    var attachedInfo: String?
//    var ex: String?
//    var offlinePushInfo: OfflinePushInfo = .init()
//    var pictureElem: PictureElem?
//    var soundElem: SoundElem?
//    var videoElem: VideoElem?
//    var fileElem: FileElem?
//    var mergeElem: MergeElem?
//    var atElem: AtElem?
//    var locationElem: LocationElem?
//    var quoteElem: QuoteElem?
//    var customElem: CustomElem?
//    var notificationElem: NotificationElem?
//    var faceElem: FaceElem?
//    var attachedInfoElem: AttachedInfoElem?
//    var sender_platform_id: String?
    
    var isPlaying = false
    var isExistTranslate = false
    var textIsExpand: Bool = false
    
    /// Hashable
    public static func == (lhs: MessageInfo, rhs: MessageInfo) -> Bool {
        lhs.clientMsgID == rhs.clientMsgID
    }
    
}

public enum MessageContentType: Int, Codable {
    case unknown = -1

    // MARK: 消息类型

    case text = 101
    case image = 102
    case audio = 103
    case video = 104
    case file = 105
    /// @消息
    case at = 106
    /// 合并消息
    case merge = 107
    /// 名片消息
    case card = 108
    case location = 109
    case custom = 110
    /// 撤回消息回执
    case revokeReciept = 111
    /// C2C单聊已读回执
    case C2CReciept = 112
    /// 正在输入状态
    case typing = 113
    case quote = 114
    /// 动图消息
    case face = 115
    /// 群聊已读回执
    case groupHasReadReceipt = 116
    /// Advanced消息
    case advancedText = 117
    /// 撤回消息类型-新
    case advancedRevoke = 118
    
    /// 系统通知类型
    case systemNoti = 121

    // MARK: 通知类型

    case friendAppApproved = 1201
    case friendAppRejected
    case friendApplication
    case friendAdded
    case friendDeleted
    /// 设置好友备注通知
    case friendRemarkSet
    case blackAdded
    case blackDeleted
    /// 会话免打扰设置通知
    case conversationOptChange = 1300
    case userInfoUpdated = 1303
    /// 会话通知
    case conversationNotification = 1307
    /// 会话不通知
    case conversationNotNotification
    case groupCreated = 1501
    /// 更新群信息通知
    case groupInfoSet = 1502
    case joinGroupApplication = 1503
    case memberQuit = 1504
    case groupAppAccepted = 1505
    case groupAppRejected = 1506
    /// 群主更换通知
    case groupOwnerTransferred = 1507
    case memberKicked = 1508
    case memberInvited = 1509
    case memberEnter = 1510
    /// 解散群通知
    case dismissGroup = 1511
    case memberMutedNotification = 1512 //群成员被禁言
    case memberUnMutedNotification = 1513 //群成员被解除禁言
    /// 阅后即焚
    case privateMessage = 1701
    
    // 自定义消息类型-对方把我加入了黑名单
    case isBeInBlacklist = 2001
    // 自定义消息类型-用于显示时间
    case sendTime = 2002
    // 自定义消息类型-用户非对方好友情况下，给出提示
    case isNotFriend = 2003

    var abstruct: String? {
        switch self {
        case .image:
            return "[图片]".localized()
        case .audio:
            return "[语音]".localized()
        case .video:
            return "[视频]".localized()
        case .file:
            return "[文件]".localized()
        case .card:
            return "[名片]".localized()
        case .location:
            return "[定位]".localized()
        case .face:
            return "[自定义表情]".localized()
        default:
            return nil
        }
    }
}
