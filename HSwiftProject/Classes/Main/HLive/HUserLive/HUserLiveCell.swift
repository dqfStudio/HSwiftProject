//
//  HUserLiveCell.swift
//  HSwiftProject
//
//  Created by Wind on 18/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

class HUserLiveBgCell : HTupleImageCell {

    private var _effectView: UIVisualEffectView?
    var effectView: UIVisualEffectView {
        if _effectView == nil {
            let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
            _effectView = UIVisualEffectView(effect: blur)
            _effectView!.alpha = 0.9
            _effectView!.frame = self.imageView.bounds
        }
        return _effectView!
    }
    
    private var _activityIndicator: UIActivityIndicatorView?
    var activityIndicator: UIActivityIndicatorView {
        if _activityIndicator == nil {
            _activityIndicator = UIActivityIndicatorView(frame: self.bounds)
            _activityIndicator!.style = .whiteLarge
        }
        return _activityIndicator!
    }
    
    //cell初始化是调用的方法
    override func initUI() {
        super.initUI()
        self.imageView.setImageWithName("live_bg_icon")
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
    
    private var _liveLeftView: UIView?
    var liveLeftView: UIView {
        if (_liveLeftView == nil) {
            _liveLeftView = UIView(frame: self.bounds)
            _liveLeftView!.backgroundColor = UIColor.clear
            _liveLeftView!.isHidden = true
            let swipeGesture = UISwipeGestureRecognizer(target: self, action:  #selector(leftSwipped))
            swipeGesture.direction = .left
            _liveLeftView!.addGestureRecognizer(swipeGesture)
        }
        return _liveLeftView!
    }
    
    private var _liveRightView: HTupleView?
    var liveRightView: HTupleView {
        if (_liveRightView == nil) {
            _liveRightView = HTupleView.tupleFrame({
                return self.bounds
            }, exclusiveSections: {
                return [0, 1, 2]
            })
            _liveRightView!.backgroundColor = UIColor.clear
            _liveRightView!.disableBounce()
//            let swipeGesture = UISwipeGestureRecognizer(target: self, action:  #selector(rightSwipped))
//            swipeGesture.direction = .right
//            _liveRightView!.addGestureRecognizer(swipeGesture)
        }
        return _liveRightView!
    }

    //cell初始化是调用的方法
    override func initUI() {
        super.initUI()
        self.backgroundColor = UIColor.clear
        self.liveRightView.delegate = self
        self.addSubview(self.liveRightView)
        self.addSubview(self.liveLeftView)
        // 隐藏模态效果
        self.effectView.isHidden = true
        
        //设置liveRightView release key
        self.liveRightView.releaseTupleKey = KLiveRoomReleaseTupleKey
        
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
