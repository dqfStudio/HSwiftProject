//
//  HMainController2.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HMainController2: HTupleController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.leftNaviButton.isHidden = true
        self.title = "第二页"
        self.tupleView.delegate = self
    }

}
