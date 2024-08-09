//
//  HViewController.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/16.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HViewController: HBaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add custom navigation bar
        self.view.addSubview(self.navigationBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.bringSubviewToFront(self.navigationBar)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //Reset the frame of the top bar
        if self.orientation != UIDevice.current.orientation {
            self.orientation = UIDevice.current.orientation
            // Refresh the navigation bar
            let width = self.view.width
            let height = UIScreen.topBarHeight
            let frame = CGRect(x: 0, y: 0, width: width, height: height)
            self.navigationBar.frame = frame
        }
    }
    
    override var title: String? {
        didSet {
            guard self.isViewLoaded else { return }
            self.navigationBar.titleItem.text = title
        }
    }
    
    // Navigation bar
    lazy var navigationBar: HNavigationBar = {
        let width = self.view.width
        let height = UIScreen.topBarHeight
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let naviBar = HNavigationBar(frame: frame)
        naviBar.leftItem.pressedBlock = { [weak self] in
            self?.leftNaviItemPressed()
        }
        naviBar.rightItem.pressedBlock = { [weak self] in
            self?.rightNaviItemPressed()
        }
        return naviBar
    }()
    
    /// Navigation bar status control
    override func setNeedsNavigationBarAppearanceUpdate() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationBar.isHidden = self.prefersNavigationBarHidden
        self.navigationBar.backgroundColor = self.preferredNavigationBarColor
        self.navigationBar.lineBarColor = self.preferredNavigationLineBarColor
        self.navigationBar.leftItem.image = UIImage(named: "hvc_back_icon")
    }

}
