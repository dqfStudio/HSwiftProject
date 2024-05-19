//
//  HMainController3.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HMainController3: HViewController, HTupleViewDelegate {

    lazy var tupleView: HTupleView = {
        let tupleView = HTupleView.splitFrame({
            var frame = UIScreen.bound
            frame.origin.y += UIScreen.topBarHeight
            frame.size.height -= UIScreen.topBarHeight
            return frame
        }, mode: {
            return .delegate
        }, exclusiveSections: {
            return [0, 1, 2]
        }, layout: {
            return HTupleViewLayout(.vertical, .manual)
        })
        return tupleView
    }()

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            self.tupleView.releaseTupleBlock()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "第三页"
        self.navigationBar.leftItem.isHidden = true
        self.tupleView.delegate = self
        self.view.addSubview(self.tupleView)
    }

    @objc
    func tuple0_numberOfSectionsInTupleView() -> Any {
        return 3
    }

}
