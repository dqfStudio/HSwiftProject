//
//  HGameCategoryVC.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/14.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HGameCategoryVC : HViewController, HTupleViewDelegate {
    
    lazy var tupleView: HTupleView = {
        let tupleView = HTupleView.splitFrame {
            var frame = UIScreen.bound
            frame.y += UIScreen.topBarHeight
            frame.height -= UIScreen.topBarHeight
            return frame
        } mode: {
            return .delegate
        } exclusiveSections: {
            return [0, 1, 2]
        } layout: {
            return HTupleViewLayout(.vertical, .manual)
        }
        return tupleView
    }()
    
    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            self.tupleView.releaseTupleBlock()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "分类"
        self.tupleView.delegate = self
        self.view.addSubview(self.tupleView)
    }
    
    @objc
    func tuple0_numberOfSectionsInTupleView() -> Any {
        return 3
    }

}
