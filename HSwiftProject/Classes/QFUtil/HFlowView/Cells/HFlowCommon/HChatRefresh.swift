////
////  HChatRefresh.swift
////  HSwiftProject
////
////  Created by owner on 2024/5/10.
////  Copyright © 2024 wind. All rights reserved.
////
//
//import MJRefresh
//
//enum HChatRefreshHeaderStyle : Int {
//    case gray = 0
//    case white = 1
//}
//
//enum HChatRefreshFooterStyle : Int {
//    case style1 = 0
//    case style2 = 1
//}
//
//class HChatRefresh : NSObject {
//    static func refreshHeaderWithStyle(_ style: HChatRefreshHeaderStyle, refreshingBlock: @escaping MJRefreshComponentAction) -> MJRefreshHeader {
//        switch (style) {
//        case HChatRefreshHeaderStyle.gray:
//            let header: MJRefreshNormalHeader = MJRefreshNormalHeader(refreshingBlock: refreshingBlock)
//            header.isAutomaticallyChangeAlpha = true
//            header.lastUpdatedTimeLabel?.isHidden = true
//            header.stateLabel?.isHidden = true
//            if #available(iOS 13.0, *) {
//                header.loadingView?.style = UIActivityIndicatorView.Style.medium
//            }else {
//                header.loadingView?.style = UIActivityIndicatorView.Style.gray
//            }
//            return header
//        case HChatRefreshHeaderStyle.white:
//            let header: MJRefreshNormalHeader = MJRefreshNormalHeader(refreshingBlock: refreshingBlock)
//            header.isAutomaticallyChangeAlpha = true
//            header.lastUpdatedTimeLabel?.isHidden = true
//            header.stateLabel?.isHidden = true
//            if #available(iOS 13.0, *) {
//                header.loadingView?.style = UIActivityIndicatorView.Style.medium
//            }else {
//                header.loadingView?.style = UIActivityIndicatorView.Style.white
//            }
//            return header
//        }
//    }
//    
//    static func refreshFooterWithStyle(_ style: HChatRefreshFooterStyle, refreshingBlock: @escaping MJRefreshComponentAction) -> MJRefreshFooter {
//        switch (style) {
//        case HChatRefreshFooterStyle.style1:
//            let footer: MJRefreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingBlock: refreshingBlock)
//            footer.setTitle("暂无更多数据", for: MJRefreshState.noMoreData)
//            footer.setTitle("", for: MJRefreshState.idle)
//            footer.isRefreshingTitleHidden = true
//            return footer
//        case HChatRefreshFooterStyle.style2:
//            let footer: MJRefreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingBlock: refreshingBlock)
//            footer.setTitle("我们也是有底线的", for: MJRefreshState.noMoreData)
//            footer.setTitle("", for: MJRefreshState.idle)
//            footer.isRefreshingTitleHidden = true
//            return footer
//        }
//    }
//}
