//
//  HMainController6.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HMainController6: HFlowController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationBar.isHidden = true
        self.flowView.delegate = self
        self.topExtendedLayout = false
    }

}
