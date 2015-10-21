//
//  SoundwichEditorViewController.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/25/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit
import AVFoundation

class SoundwichEditorViewController: UIViewController, AVAudioPlayerDelegate, MessagesFromTimelineDelegate, MessagesFromButtonTrayDelegate
{
    var soundwich:Soundwich?
    
    @IBOutlet weak var timelineView: TimelineView!
    @IBOutlet weak var buttonTrayView: ButtonTrayView!

    var players: [AVAudioPlayer?]?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.clipsToBounds = true
        
        // Do any additional setup after loading the view, typically from a nib.        
        self.title = soundwich?.title
        timelineView.registerDelegate(self)
        
        buttonTrayView.receiverOfButtonTrayEvents = self
        
        timelineView.setNeedsLayout()

        buttonTrayView.playPauseButton.addTarget(
            self,
            action: "onTouchUpInsidePlayPause:",
            forControlEvents: .TouchUpInside
        )
        
        buttonTrayView.timelineView = timelineView

        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.navigationController?.interactivePopGestureRecognizer?.enabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data
    func update() {
        if let s = soundwich {
            SoundwichStore.update(s, callback:{(error) in
                if (error != nil) {
                    NSLog("Error Updating.")
                }
            })
        }
    }


    // MARK: - Touch Handlers
    func onTouchUpInsidePlayPause(sender: UIButton) {
        guard let soundbites = soundwich?.soundbites else { return }

        if sender.state == UIControlState.Selected {
            players = soundbites.map({ (bite) -> AVAudioPlayer? in
                let url = NSURL(string: bite.url)
                let player = try? AVAudioPlayer(contentsOfURL: url!)

                if player != nil {
                    player!.delegate = self
                    player!.playAtTime(player!.deviceCurrentTime + Double(bite.start))
                }

                return player
            })
        } else {
            players?.forEach({ (player) -> () in
                player!.pause()
            })
        }
    }

    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        // print("audioPlayerDidFinishPlaying:", flag)
        guard let players = players else { return }

        let done = players.reduce(true) { (done, player) -> Bool in
            print("done: \(done)\nplaying: \((player?.playing)!)\nurl: \((player?.url)!.lastPathComponent)\n")
            return done && !(player?.playing)!
        }

        if done {
            buttonTrayView.playPauseButton.setupPlayButton()
            buttonTrayView.playPauseButton.selected = false
        }
    }

    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        // print("audioPlayerDecodeErrorDidOccur:", error)
    }

    // Required protocol "MessagesFromButtonTrayDelegate"

    func recordingDidComplete(url: NSURL, duration: Double) {
        if (duration > 0.75) {
            let goodChannel = soundwich?.nextAvailableChannel()
            if goodChannel >= 0 {
                let newSoundbite = Soundbite(url: String(url), channel: goodChannel!, duration: Float(duration))
                
                let data = NSData(contentsOfURL: url)
                newSoundbite.audioData = data
                
                try! soundwich!.addSoundbite(newSoundbite)
                try! timelineView.createSoundbiteView(newSoundbite)
            }
        }
    }
    
    
    
    
    // =================================================
    
    // Required protocol "MessagesFromTimelineDelegate"
    
    func soundbiteTimespecDidChange(name:String, newSpec:Soundbite) {
        try! soundwich!.registerTimespecChange(newSpec)
    }

    func userMovedScrubber(newPositionInSeconds:Float, interactionHasEnded:Bool) {
        
    }
    
    func soundbiteDeleteRequested(name:String) {
        do {
            try soundwich!.deleteSoundbite(name)
            try timelineView.deleteSoundbite(name)
        }
        catch {
            // Absurdity!!!  We really don't expect this!!  The databases have become insane/outofsync!  Help!!!
        }
    }
    
    
    func soundbiteDuplicateRequested(name:String) {
        
        
    }

}
