//
//  HTupleStackView.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/6.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HTupleStackView: UIStackView, HTupleViewDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: self.bounds)
        tupleView.backgroundColor = .clear
        tupleView.disableBounce()
        return tupleView
    }()
    
    func reloadTupleData() {
        self.tupleView.reloadTupleData()
    }
    
    override func removeFromSuperview() {
        if self.superview != nil {
            super.removeFromSuperview()
            self.tupleView.signalToAllHeader(nil, {
                self.tupleView.signalToAllItems(nil, { })
            })
            self.tupleView.releaseTupleBlock()
        }
    }

}
