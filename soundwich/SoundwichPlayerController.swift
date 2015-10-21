//
//  SoundwichPlayerController.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/30/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import Foundation
import AVFoundation

protocol SoundwichPlayerControllerDelegate {
    var shouldPlayerLoop: Bool { get set }
    func onUpdate(time: Double)
    func onFinished()
}

// from http://www.rockhoppertech.com/blog/swift-avfoundation/#audiofile
class SoundwichPlayerController: NSObject, AVAudioPlayerDelegate {
    var delegate:SoundwichPlayerControllerDelegate?

    var soundbites: [Soundbite]?
    var players: [AVAudioPlayer?]?

    var timer: NSTimer?
    var currentTime = 0.0
    var totalTime = 0.0

//    /// The player.
//    var avPlayer:AVAudioPlayer?
//
//    func playURL(url:NSURL) {
//        
//        do {
//            try self.avPlayer = AVAudioPlayer(contentsOfURL: url)
//        } catch {
//            print("Error creating av audio player")
//        }
//        
//        if avPlayer == nil {
//            print("Error playing")
//        }
//        
//        avPlayer?.delegate = self
//        avPlayer?.prepareToPlay()
//        avPlayer?.volume = 1.0
//        avPlayer?.play()
//    }
//    
//    /**
//    Uses AvAudioPlayer to play a sound file.
//    The player instance needs to be an instance variable. Otherwise it will disappear before playing.
//    */
//    func playNSData(data:NSData) {
//        
//        do {
//            try self.avPlayer = AVAudioPlayer(data: data)
//        } catch {
//            print("Error creating av audio player")
//        }
//        
//        if avPlayer == nil {
//            print("Error playing")
//        }
//        
//        avPlayer?.delegate = self
//        avPlayer?.prepareToPlay()
//        avPlayer?.volume = 1.0
//        avPlayer?.play()
//    }
//    
//    func stopAVPLayer() {
//        if (avPlayer?.playing ?? false) {
//            avPlayer?.stop()
//        }
//    }
//    
//    func toggleAVPlayer() {
//        if (avPlayer?.playing ?? false) {
//            avPlayer?.pause()
//        } else {
//            avPlayer?.play()
//        }
//    }

    func playAll(soundbites: [Soundbite]) {
        currentTime = 0.0
        totalTime = 0.0

        self.soundbites = soundbites
        players = soundbites.map({ (bite) -> AVAudioPlayer? in
            let url = NSURL(string: bite.url)

            if let player = try? AVAudioPlayer(contentsOfURL: url!) {
                player.delegate = self

                print("bite:", bite.start)
                player.playAtTime(player.deviceCurrentTime + Double(bite.start))

                totalTime = max(totalTime, Double(bite.end))
                return player
            }

            return nil
        })

        if let timer = timer {
            timer.invalidate()
        }

        timer = NSTimer.scheduledTimerWithTimeInterval(
            1 / 60,
            target: self,
            selector: "onTimer:",
            userInfo: nil,
            repeats: true
        )
    }

    func pauseAll() {
        players?.forEach({ (player) -> () in
            guard let player = player else { return }
            player.stop()
        })
        finishAll()
    }

    func finishAll() {
        if let timer = timer {
            timer.invalidate()
        }
        self.soundbites = []
        delegate?.onFinished()
    }

    func onTimer(timer: NSTimer) {
        currentTime += timer.timeInterval

        // print("currentTime: \(currentTime), totalTime: \(totalTime), percentage: \(currentTime / totalTime)")

        delegate?.onUpdate(currentTime)
        if currentTime >= totalTime {
            loopOrDont()
        }
    }

    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        guard let players = players else { return }

        let done = players.reduce(true) { (done, player) -> Bool in
            // print("done: \(done)\nplaying: \((player?.playing)!)\nurl: \((player?.url)!.lastPathComponent)\n")
            return done && !(player?.playing)!
        }

        if done {
            loopOrDont()
        }
    }

    func loopOrDont() {
        if let delegate = delegate {
            if delegate.shouldPlayerLoop {
                playAll(soundbites!)
            } else {
                finishAll()
            }
        }
    }

    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        // print("audioPlayerDecodeErrorDidOccur:", error)
    }
}

// MARK: AVAudioPlayerDelegate
//extension SoundwichPlayerController : AVAudioPlayerDelegate {
//    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
//        print("finished playing \(flag)")
//        delegate?.onFinished()
//    }
//    
//    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
//        print("\(error!.localizedDescription)")
//    }
//}