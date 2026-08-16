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
        view.addSubview(navigationBar)
        navigationBar.titleItem.text = title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.bringSubviewToFront(navigationBar)
    }
    
    override var title: String? {
        didSet {
            guard isViewLoaded else { return }
            navigationBar.titleItem.text = title
        }
    }
    
    // Navigation bar
    lazy var navigationBar: HNavigationBar = {
        let width = view.width
        let height = UIScreen.topBarHeight
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        return HNavigationBar(frame: frame)
    }()
    
    override var managesSystemNavigationBar: Bool {
        true
    }
    
    override var prefersSystemNavigationBarHidden: Bool {
        true
    }
    
    /// Navigation bar status control
    override func setNeedsNavigationBarAppearanceUpdate() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationBar.isHidden = prefersNavigationBarHidden
        navigationBar.backgroundColor = preferredNavigationBarColor
        navigationBar.lineBarColor = prefersNavigationLineBarHidden ? .clear : preferredNavigationLineBarColor
        navigationBar.leftItem.isHidden = prefersNavigationLeftItemHidden
        configureBackItem(navigationBar.leftItem, style: .normal)
    }

}
