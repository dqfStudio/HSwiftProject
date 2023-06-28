//
//  HTupleViewBannerCell.swift
//  HSwiftProject
//
//  Created by Wind on 2020/2/21.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

typealias HTupleViewBannerCellBlock = (_ index: Int) -> Void

class HTupleViewBannerCell : HTupleBaseCell, HCycleScrollViewDelegate {
    
    private lazy var cycleScrollView: HCycleScrollView = {
        let scrollView = HCycleScrollView.cycleScrollViewWithFrame(self.bounds, delegate: self, placeholderImage: UIImage(named: "HCyclePlaceholder"))
        scrollView.pageControlAliment = .Center
        scrollView.currentPageDotColor = .white
        return scrollView
    }()
    
    var imageUrlArr: NSArray? {
        didSet {
            if imageUrlArr != oldValue {
                self.cycleScrollView.imageURLStringsGroup = imageUrlArr
            }
        }
    }
    
    var selectedBannerBlock: HTupleViewBannerCellBlock?

    override func relayoutSubviews() {
        HLayoutTupleCell(self.cycleScrollView)
    }

    override func initUI() {
        self.layoutView.addSubview(self.cycleScrollView)
    }

    /// HCycleScrollViewDelegate
    func cycleScrollView(_ cycleScrollView: HCycleScrollView, didSelectItemAtIndex index: Int) {
        guard let selectedBannerBlock = self.selectedBannerBlock else { return }
        selectedBannerBlock(index)
    }

}
