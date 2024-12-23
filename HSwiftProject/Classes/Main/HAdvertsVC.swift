//
//  HAdvertsVC.swift
//  HSwiftProject
//
//  Created by owner on 2024/12/21.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit
import AVFoundation

class HAdvertsVC: HViewController, HTupleViewDelegate {
    
    lazy var promptButton: HWebButtonView = {
        var frame = CGRect(x: 8, y: 50, width: UIScreen.width - 16, height: 280)
        let button = HWebButtonView(frame: frame)
        button.textFont = UIFont.font(ofSize: 34, weight: .medium)
        button.backgroundColor = .red
        button.textColor = .yellow
        button.text = "go"
        button.pressed = { [weak self] (sender, data) in
            guard let self = self else { return }
            self.promptButton.text = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.promptButton.text = "3"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.promptButton.text = "2"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.promptButton.text = "1"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.play()
                        }
                    }
                }
            }
        }
        return button
    }()
    
    lazy var videoView: VideoPlayerView = {
        let videoView = VideoPlayerView()
        videoView.contentMode = .scaleAspectFit
        return videoView
    }()
    
    lazy var tupleView: HTupleView = {
        let tupleView = HTupleView.splitFrame {
            return UIScreen.bound
        } mode: {
            return .delegate
        } exclusiveSections: {
            return []
        } layout: {
            return HTupleViewLayout(.vertical, .manual)
        }
        return tupleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional.tup after loading the view.
        self.navigationBar.isHidden = true
        self.tupleView.delegate = self
        self.view.addSubview(self.tupleView)
        self.view.addSubview(promptButton)
        
        videoView.stateDidChanged = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .none, .loading:
                self.promptButton.isHidden = true
                self.promptButton.text = ""
            case .playing:
                self.promptButton.isHidden = true
                self.promptButton.text = ""
            case .paused:
                self.promptButton.isHidden = false
                self.promptButton.text = "done"
                self.videoView.pause(reason: .userInteraction)
            case .error:
                self.promptButton.isHidden = false
                self.promptButton.text = "error"
            }
        }
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            tupleView.releaseTupleBlock()
        }
    }

    func play() {
        if let videoURL = Bundle.main.url(forResource: "video", withExtension: "mov") {
            videoView.play(for: videoURL)
            videoView.isAutoReplay = false
        }
    }
    
    func pause() {
        videoView.pause(reason: .userInteraction)
    }
}
