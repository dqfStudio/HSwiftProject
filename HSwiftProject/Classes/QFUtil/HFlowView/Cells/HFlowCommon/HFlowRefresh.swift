//
//  HFlowRefresh.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/25.
//  Copyright © 2019 wind. All rights reserved.
//

import MJRefresh

enum HFlowRefreshHeaderStyle : Int {
    case gray = 0
    case white = 1
}

enum HFlowRefreshFooterStyle : Int {
    case style1 = 0
    case style2 = 1
}

class HFlowRefresh : NSObject {
    static func refreshHeaderWithStyle(_ style: HFlowRefreshHeaderStyle, refreshingBlock: @escaping MJRefreshComponentAction) -> MJRefreshHeader {
        switch (style) {
        case HFlowRefreshHeaderStyle.gray:
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
        case HFlowRefreshHeaderStyle.white:
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
    
    static func refreshFooterWithStyle(_ style: HFlowRefreshFooterStyle, refreshingBlock: @escaping MJRefreshComponentAction) -> MJRefreshFooter {
        switch (style) {
        case HFlowRefreshFooterStyle.style1:
            let footer: MJRefreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingBlock: refreshingBlock)
            footer.setTitle("暂无更多数据", for: MJRefreshState.noMoreData)
            footer.setTitle("", for: MJRefreshState.idle)
            footer.isRefreshingTitleHidden = true
            return footer
        case HFlowRefreshFooterStyle.style2:
            let footer: MJRefreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingBlock: refreshingBlock)
            footer.setTitle("我们也是有底线的", for: MJRefreshState.noMoreData)
            footer.setTitle("", for: MJRefreshState.idle)
            footer.isRefreshingTitleHidden = true
            return footer
        }
    }
}
