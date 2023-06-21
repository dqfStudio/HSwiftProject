//
//  AppDelegate+SoundService.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/24.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit
import AVFoundation

extension AppDelegate {

    var audioPlayer: AVAudioPlayer? {
        get {
            var audioPlayer = objc_getAssociatedObject(self, #function) as? AVAudioPlayer
            if audioPlayer == nil {
                audioPlayer = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "music", withExtension: "mp3")!)
                audioPlayer!.numberOfLoops = -1
                audioPlayer!.prepareToPlay()
                self.audioPlayer = audioPlayer
            }
            return audioPlayer
        }
        set { objc_setAssociatedObject(self, #function, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    
    var musicVolume: Float {
        get { return objc_getAssociatedObject(self, #function) as? Float ?? AVAudioSession.sharedInstance().outputVolume }
        set { objc_setAssociatedObject(self, #function, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    //播放音效
    func startPlayMusic() {
        audioPlayer?.volume = musicVolume
        if !(audioPlayer?.isPlaying ?? true) {
            audioPlayer?.play()
        }
    }
    
    //暂停播放背景音乐
    func pausePlayMusic() {
        if audioPlayer?.isPlaying ?? false {
            audioPlayer?.pause()
        }
    }
    
    //停止播放背景音乐
    func stopPlayMusic() {
        if audioPlayer?.isPlaying ?? false {
            audioPlayer?.stop()
        }
    }
}
