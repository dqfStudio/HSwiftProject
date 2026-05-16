//
//  HFlowRefresh.swift
//  HSwiftProject
//
//  Created by owner on 2024/10/21.
//  Copyright © 2024 wind. All rights reserved.
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
    static func refreshHeaderWithStyle(_ style: HFlowRefreshHeaderStyle, block: @escaping MJRefreshComponentAction, isAutomaticallyChangeAlpha: Bool = true) -> MJRefreshHeader {
        switch (style) {
        case HFlowRefreshHeaderStyle.gray:
            let header: MJRefreshNormalHeader = MJRefreshNormalHeader(refreshingBlock: block)
            header.isAutomaticallyChangeAlpha = isAutomaticallyChangeAlpha
            header.lastUpdatedTimeLabel?.isHidden = true
            header.stateLabel?.isHidden = true
            if #available(iOS 13.0, *) {
                header.loadingView?.style = UIActivityIndicatorView.Style.medium
            }else {
                header.loadingView?.style = UIActivityIndicatorView.Style.gray
            }
            return header
        case HFlowRefreshHeaderStyle.white:
            let header: MJRefreshNormalHeader = MJRefreshNormalHeader(refreshingBlock: block)
            header.isAutomaticallyChangeAlpha = isAutomaticallyChangeAlpha
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
    
    static func refreshFooterWithStyle(_ style: HFlowRefreshFooterStyle, block: @escaping MJRefreshComponentAction) -> MJRefreshFooter {
        switch (style) {
        case HFlowRefreshFooterStyle.style1:
            let footer: MJRefreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingBlock: block)
            footer.setTitle("暂无更多数据", for: MJRefreshState.noMoreData)
            footer.setTitle("", for: MJRefreshState.idle)
            footer.isRefreshingTitleHidden = true
            return footer
        case HFlowRefreshFooterStyle.style2:
            let footer: MJRefreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingBlock: block)
            footer.setTitle("我们也是有底线的", for: MJRefreshState.noMoreData)
            footer.setTitle("", for: MJRefreshState.idle)
            footer.isRefreshingTitleHidden = true
            return footer
        }
    }
    
    static func customRefreshHeader(block: @escaping MJRefreshComponentAction, customView: UIView) -> MJRefreshHeader {
        let header = MJRefreshHeader(refreshingBlock: block)
        header.addSubview(customView)
        return header
    }
    
    static func customRefreshFooter(block: @escaping MJRefreshComponentAction, customView: UIView) -> MJRefreshFooter {
        let footer = MJRefreshFooter(refreshingBlock: block)
        footer.addSubview(customView)
        return footer
    }
}
