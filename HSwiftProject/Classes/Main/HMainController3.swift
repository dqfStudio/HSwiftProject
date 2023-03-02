//
//  HMainController3.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HMainController3: HViewController, HTupleViewDelegate {

    private var _tupleView: HTupleView?
    var tupleView: HTupleView {
        if _tupleView == nil {
            var frame = UIScreen.bound
            frame.origin.y += UIDevice.topBarHeight
            frame.size.height -= UIDevice.topBarHeight
            _tupleView = HTupleView.tupleFrame({ () -> CGRect in
                return frame
            }, exclusiveSections: { () -> NSArray in
                return [0, 1, 2]
            })
        }
        return _tupleView!
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == HVCDisappearType.pop || type == HVCDisappearType.dismiss {
            self.tupleView.releaseTupleBlock()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.leftNaviButton.isHidden = true
        self.title = "第三页"
        self.tupleView.delegate = self
        self.view.addSubview(self.tupleView)
    }

    @objc
    func tuple0_numberOfSectionsInTupleView() -> Any {
        return 3
    }

}
