//
//  HUserLiveCell.swift
//  HSwiftProject
//
//  Created by Wind on 18/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

class HUserLiveBgCell : HTupleImageCell {

    lazy var effectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.alpha = 0.9
        effectView.frame = self.imageView.bounds
        return effectView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: self.bounds)
        indicator.style = .whiteLarge
        return indicator
    }()
    
    //cell初始化是调用的方法
    override func initUI() {
        super.initUI()
        self.imageView.setImage(named: "live_bg_icon")
        //添加模态效果
        self.imageView.addSubview(self.effectView)
        //添加转圈等待效果
        self.addSubview(self.activityIndicator)
    }
    //用于子类更新子视图布局
    override func relayoutSubviews() {
        HLayoutTupleCell(self.imageView)
        HLayoutTupleCell(self.effectView)
        HLayoutTupleCell(self.activityIndicator)
    }
}


class HUserLiveCell : HUserLiveBgCell, HTupleViewDelegate {
    
    lazy var liveLeftView: UIView = {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .clear
        view.isHidden = true
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipped))
        swipeGesture.direction = .left
        view.addGestureRecognizer(swipeGesture)
        return view
    }()
    
    lazy var liveRightView: HTupleView = {
        let view = HTupleView.splitFrame {
            return self.bounds
        } mode: {
            return .delegate
        } exclusiveSections: {
            return [0, 1, 2]
        } layout: {
            return HTupleViewLayout(.vertical, .manual)
        }
        view.backgroundColor = .clear
        view.disableBounce()
//        let swipeGesture = UISwipeGestureRecognizer(target: self, action:  #selector(rightSwipped))
//        swipeGesture.direction = .right
//        view.addGestureRecognizer(swipeGesture)
        return view
    }()

    //cell初始化是调用的方法
    override func initUI() {
        super.initUI()
        self.backgroundColor = .clear
        self.liveRightView.delegate = self
        self.addSubview(self.liveRightView)
        self.addSubview(self.liveLeftView)
        // 隐藏模态效果
        self.effectView.isHidden = true
        
        //设置liveRightView release key
        self.liveRightView.releaseTupleKey = kLiveRoomReleaseTupleKey
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action:  #selector(rightSwipped))
        swipeGesture.direction = .right
        self.addGestureRecognizer(swipeGesture)
    }
    //用于子类更新子视图布局
    override func relayoutSubviews() {
        super.relayoutSubviews()
        HLayoutTupleCell(self.liveLeftView)
        HLayoutTupleCell(self.liveRightView)
    }

    @objc
    private func leftSwipped() {
        UIView.animate(withDuration: 0.3) {
            self.liveRightView.frame = self.liveRightView.bounds
        } completion: { finished in
            self.liveLeftView.isHidden = true
            self.tuple?.isScrollEnabled = true
        }
    }

    @objc
    private func rightSwipped() {
        UIView.animate(withDuration: 0.3) {
            var frame = self.liveRightView.bounds
            frame.origin.x = self.liveRightView.width
            self.liveRightView.frame = frame
        } completion: { finished in
            self.liveLeftView.isHidden = false
            self.tuple?.isScrollEnabled = false
        }
    }

    @objc
    func tuple0_numberOfSectionsInTupleView() -> Any {
        return 3
    }

}
