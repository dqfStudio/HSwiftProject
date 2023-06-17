//
//  HMainController2.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HMainController2: HViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let toolbar = HScrollbar(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 40))

        toolbar.titleColor = .blue
        toolbar.titleFont = UIFont.font(ofSize: 14, weight: .regular)
        toolbar.titleBGColor = .green

        toolbar.titleSelectedColor = .red
        toolbar.titleSelectedFont = UIFont.font(ofSize: 17, weight: .regular)
        toolbar.titleSelectedBGColor = .yellow

        toolbar.items = ["item1", "item2", "item3", "item4", "item5", "item6"]
        toolbar.itemWidth = UIScreen.width / 6

        toolbar.isScrollEnabled = false

        toolbar.selectedIndex = 1

        toolbar.selectedBlock = { index in
            NSLog(index)
        }

        toolbar.cornerRadius = 20
        self.view.addSubview(toolbar)
        
    }

}
