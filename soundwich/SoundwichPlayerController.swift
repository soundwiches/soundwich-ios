//
//  SoundwichPlayerController.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/30/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import Foundation
import AVFoundation

// from http://www.rockhoppertech.com/blog/swift-avfoundation/#audiofile
class SoundwichPlayerController : NSObject {
    
    /// The player.
    var avPlayer:AVAudioPlayer?

    func playURL(url:NSURL) {
        
        do {
            try self.avPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Error creating av audio player")
        }
        
        if avPlayer == nil {
            print("Error playing")
        }
        
        avPlayer?.delegate = self
        avPlayer?.prepareToPlay()
        avPlayer?.volume = 1.0
        avPlayer?.play()
    }
    
    /**
    Uses AvAudioPlayer to play a sound file.
    The player instance needs to be an instance variable. Otherwise it will disappear before playing.
    */
    func playNSData(data:NSData) {
        
        do {
            try self.avPlayer = AVAudioPlayer(data: data)
        } catch {
            print("Error creating av audio player")
        }
        
        if avPlayer == nil {
            print("Error playing")
        }
        
        avPlayer?.delegate = self
        avPlayer?.prepareToPlay()
        avPlayer?.volume = 1.0
        avPlayer?.play()
    }
    
    func stopAVPLayer() {
        if (avPlayer?.playing ?? false) {
            avPlayer?.stop()
        }
    }
    
    func toggleAVPlayer() {
        if (avPlayer?.playing ?? false) {
            avPlayer?.pause()
        } else {
            avPlayer?.play()
        }
    }
}

// MARK: AVAudioPlayerDelegate
extension SoundwichPlayerController : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing \(flag)")
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("\(error!.localizedDescription)")
    }
}