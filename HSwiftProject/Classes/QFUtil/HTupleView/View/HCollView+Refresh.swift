//
//  HCollView+Refresh.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/6.
//  Copyright © 2025 wind. All rights reserved.
//

import MJRefresh

enum HCollRefreshHeaderStyle : Int {
    case gray = 0
    case white = 1
}

enum HCollRefreshFooterStyle : Int {
    case style1 = 0
    case style2 = 1
}

class HCollRefresh: NSObject {
    static func refreshHeaderWithStyle(_ style: HCollRefreshHeaderStyle, refreshingBlock: @escaping MJRefreshComponentAction) -> MJRefreshHeader {
        switch (style) {
        case HCollRefreshHeaderStyle.gray:
            let header: MJRefreshNormalHeader = MJRefreshNormalHeader(refreshingBlock: refreshingBlock)
            header.isAutomaticallyChangeAlpha = true
            header.lastUpdatedTimeLabel?.isHidden = true
            header.stateLabel?.isHidden = true
            if #available(iOS 13.0, *) {
                header.loadingView?.style = UIActivityIndicatorView.Style.medium
            }else {
                header.loadingView?.style = UIActivityIndicatorView.Style.gray
            }
            return header
        case HCollRefreshHeaderStyle.white:
            let header: MJRefreshNormalHeader = MJRefreshNormalHeader(refreshingBlock: refreshingBlock)
            header.isAutomaticallyChangeAlpha = true
            header.lastUpdatedTimeLabel?.isHidden = true
            header.stateLabel?.isHidden = true
            if #available(iOS 13.0, *) {
                header.loadingView?.style = UIActivityIndicatorView.Style.medium
            }else {
                header.loadingView?.style = UIActivityIndicatorView.Style.white
            }
            return header
        }
    }
    
    static func refreshFooterWithStyle(_ style: HCollRefreshFooterStyle, refreshingBlock: @escaping MJRefreshComponentAction) -> MJRefreshFooter {
        switch (style) {
        case HCollRefreshFooterStyle.style1:
            let footer: MJRefreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingBlock: refreshingBlock)
            footer.setTitle("暂无更多数据", for: MJRefreshState.noMoreData)
            footer.setTitle("", for: MJRefreshState.idle)
            footer.isRefreshingTitleHidden = true
            return footer
        case HCollRefreshFooterStyle.style2:
            let footer: MJRefreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingBlock: refreshingBlock)
            footer.setTitle("我们也是有底线的", for: MJRefreshState.noMoreData)
            footer.setTitle("", for: MJRefreshState.idle)
            footer.isRefreshingTitleHidden = true
            return footer
        }
    }
}
