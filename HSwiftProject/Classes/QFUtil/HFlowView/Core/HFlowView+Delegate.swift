//
//  HFlowView+Delegate.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  把点击、滚动、高度回调转给 flowDelegate。
//

import UIKit

extension HFlowView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        max(flowDelegate?.heightForHeaderInSection?(section) ?? 0, 0)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        max(flowDelegate?.heightForFooterInSection?(section) ?? 0, 0)
    }

    /// 未实现 `heightForRowAtIndexPath` 时用估计高度，不要走 Auto Dimension（frame cell 撑不起 contentView）。
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = flowDelegate?.heightForRowAtIndexPath?(indexPath) {
            return max(height, 0)
        }
        return Constants.defaultEstimatedHeight
    }

    /// 实现了高度回调则 `max(height, 0)`；未实现则用 `defaultEstimatedHeight`。
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = flowDelegate?.heightForRowAtIndexPath?(indexPath) {
            return max(height, 0)
        }
        return Constants.defaultEstimatedHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? HFlowBaseCell {
            cell.willDisplayBlock?()
        }
        flowDelegate?.willDisplayCell?(cell, atIndexPath: indexPath)
        invokeFeature(HFlowFeatureSelector.imageSizeWillDisplay, with: indexPath)
        invokeFeature(HFlowFeatureSelector.prerenderWillDisplay, with: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let apex = view as? HFlowBaseApex {
            apex.willDisplayBlock?()
            flowDelegate?.willDisplayHeader?(apex, atIndexPath: IndexPath(row: 0, section: section))
        }
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let apex = view as? HFlowBaseApex {
            apex.willDisplayBlock?()
            flowDelegate?.willDisplayFooter?(apex, atIndexPath: IndexPath(row: 0, section: section))
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        flowDelegate?.didEndDisplayingCell?(cell, atIndexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = cellForRow(at: indexPath) as? HFlowBaseCell {
            cell.selectBlock?()
        }
        flowDelegate?.didSelectCell?(indexPath)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let should = flowDelegate?.shouldSelectRowAtIndexPath?(indexPath) ?? true
        return should ? indexPath : nil
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let should = flowDelegate?.shouldDeselectRowAtIndexPath?(indexPath) ?? true
        return should ? indexPath : nil
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        flowDelegate?.didDeselectRowAtIndexPath?(indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        flowDelegate?.flowViewDidScroll?(scrollView)
        invokeFeature(HFlowFeatureSelector.refreshDidScroll)
        invokeFeature(HFlowFeatureSelector.prerenderDidScroll)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        flowDelegate?.flowViewDidZoom?(scrollView)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        flowDelegate?.flowViewWillBeginDragging?(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        flowDelegate?.flowViewWillEndDragging?(velocity, targetContentOffset: targetContentOffset)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        flowDelegate?.flowViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        flowDelegate?.flowViewWillBeginDecelerating?(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        flowDelegate?.flowViewDidEndDecelerating?(scrollView)
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        flowDelegate?.flowViewDidScrollToTop?(scrollView)
    }
}
