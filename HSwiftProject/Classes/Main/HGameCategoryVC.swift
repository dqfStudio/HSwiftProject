//
//  HGameCategoryVC.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/14.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HGameCategoryVC : HViewController, HTupleViewDelegate {
    
    private var _tupleView: HTupleView?
    var tupleView: HTupleView {
        if _tupleView == nil {
            var frame: CGRect = UIScreen.bound
            frame.y += UIScreen.topBarHeight
            frame.height -= UIScreen.topBarHeight
            _tupleView = HTupleView.tupleFrame({ () -> CGRect in
                return frame
            }, exclusiveSections: { () -> NSArray in
                return [0, 1, 2]
            })
        }
        return _tupleView!
    }
    
    override func vcWillDisappear(_ type: HVCDisappearType) {
        if (type == .pop || type == .dismiss) {
            self.tupleView.releaseTupleBlock()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.leftNaviButton.isHidden = true
        self.title = "分类"
        self.tupleView.delegate = self
        self.view.addSubview(self.tupleView)
    }
    
    @objc
    func tuple0_numberOfSectionsInTupleView() -> Any {
        return 3
    }

}
