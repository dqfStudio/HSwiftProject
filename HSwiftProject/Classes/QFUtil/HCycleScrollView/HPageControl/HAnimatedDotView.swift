//
//  HAnimatedDotView.swift
//  HSwiftProject
//
//  Created by wind on 2020/2/20.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

let kHAnimateDuration = 1.0

class HAnimatedDotView: HAbstractDotView {

    private var _dotColor: UIColor?
    var dotColor: UIColor? {
        get {
            return _dotColor
        }
        set {
            _dotColor = newValue
            self.layer.borderColor = dotColor?.cgColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialization()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialization()
    }
    private func initialization() {
        _dotColor = UIColor.white
        self.backgroundColor   = UIColor.clear
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
    }
    override func changeActivityState(_ active: Bool) {
        if active {
            self.animateToActiveState()
        } else {
            self.animateToDeactiveState()
        }
    }
    private func animateToActiveState() {
        UIView.animate(withDuration: kHAnimateDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: -20, options: .curveLinear, animations: {
            self.backgroundColor = self._dotColor
            self.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }, completion: nil)
    }
    private func animateToDeactiveState() {
        UIView.animate(withDuration: kHAnimateDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.backgroundColor = UIColor.clear
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
