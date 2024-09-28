//
//  HActiveController.swift
//  HSwiftProject
//
//  Created by owner on 2023/7/17.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HActiveController: HBaseController {

    override var title: String? {
        didSet {
            guard self.isViewLoaded else { return }
            self.navigationItem.titleItem.text = title
        }
    }

    // Navigation bar
    var navigationBar: UINavigationBar? {
        return self.navigationController?.navigationBar
    }
    
    // Navigation item
    override var navigationItem: UINavigationItem {
        let naviItem = super.navigationItem
        naviItem.leftItem.pressedBlock = { [weak self] in
            self?.leftNaviItemPressed()
        }
        naviItem.rightItem.pressedBlock = { [weak self] in
            self?.rightNaviItemPressed()
        }
        return naviItem
    }

    /// Navigation bar status control
    override func setNeedsNavigationBarAppearanceUpdate() {
        self.navigationBar?.isHidden = self.prefersNavigationBarHidden
        self.navigationBar?.backgroundColor = self.preferredNavigationBarColor
        self.navigationItem.leftItem.image = UIImage(named: "hvc_back_icon")
    }

}
