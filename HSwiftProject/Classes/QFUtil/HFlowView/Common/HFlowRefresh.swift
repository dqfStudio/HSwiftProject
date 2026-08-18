//
//  HFlowRefresh.swift
//  HSwiftProject
//
//  Created by owner on 2024/10/21.
//  Copyright © 2024 wind. All rights reserved.
//

import MJRefresh

enum HFlowRefreshHeaderStyle: Int {
    case gray = 0
    case white = 1
}

/// style1：Auto footer，停在底部会自动触发；style2：Back footer，需上拉。
enum HFlowRefreshFooterStyle: Int {
    case style1 = 0
    case style2 = 1
}

class HFlowRefresh: NSObject {

    static func refreshHeaderWithStyle(_ style: HFlowRefreshHeaderStyle, block: @escaping MJRefreshComponentAction, isAutomaticallyChangeAlpha: Bool = true) -> MJRefreshHeader {
        switch style {
        case .gray:
            let header = MJRefreshNormalHeader(refreshingBlock: block)
            header.isAutomaticallyChangeAlpha = isAutomaticallyChangeAlpha
            header.lastUpdatedTimeLabel?.isHidden = true
            header.stateLabel?.isHidden = true
            if #available(iOS 13.0, *) {
                header.loadingView?.style = .medium
            } else {
                header.loadingView?.style = .gray
            }
            return header
        case .white:
            let header = MJRefreshNormalHeader(refreshingBlock: block)
            header.isAutomaticallyChangeAlpha = isAutomaticallyChangeAlpha
            header.lastUpdatedTimeLabel?.isHidden = true
            header.stateLabel?.isHidden = true
            if #available(iOS 13.0, *) {
                header.loadingView?.style = .medium
            } else {
                header.loadingView?.style = .white
            }
            return header
        }
    }

    static func refreshFooterWithStyle(_ style: HFlowRefreshFooterStyle, block: @escaping MJRefreshComponentAction) -> MJRefreshFooter {
        switch style {
        case .style1:
            let footer = MJRefreshAutoNormalFooter(refreshingBlock: block)
            footer.setTitle("暂无更多数据", for: .noMoreData)
            footer.setTitle("", for: .idle)
            footer.isRefreshingTitleHidden = true
            return footer
        case .style2:
            let footer = MJRefreshBackNormalFooter(refreshingBlock: block)
            footer.setTitle("我们也是有底线的", for: .noMoreData)
            footer.setTitle("", for: .idle)
            return footer
        }
    }

    static func customRefreshHeader(block: @escaping MJRefreshComponentAction, customView: UIView) -> MJRefreshHeader {
        let header = MJRefreshNormalHeader(refreshingBlock: block)
        header.addSubview(customView)
        return header
    }

    static func customRefreshFooter(block: @escaping MJRefreshComponentAction, customView: UIView) -> MJRefreshFooter {
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: block)
        footer.addSubview(customView)
        return footer
    }
}
