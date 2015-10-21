//
//  SoundwichEditorViewController.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/25/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit
import AVFoundation

class SoundwichEditorViewController: UIViewController, MessagesFromTimelineDelegate, MessagesFromButtonTrayDelegate, SoundwichPlayerControllerDelegate
{
    var soundwich:Soundwich?
    
    @IBOutlet weak var timelineView: TimelineView!
    @IBOutlet weak var buttonTrayView: ButtonTrayView!

    var players: [AVAudioPlayer?]?

    var timer: NSTimer?
    var currentTime = 0.0
    var totalTime = 0.0

    let playerController = SoundwichPlayerController()
    var shouldPlayerLoop: Bool {
        get { return buttonTrayView.loopButton.selected }
        set(newValue) { buttonTrayView.loopButton.selected = newValue }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.clipsToBounds = true

        playerController.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = soundwich?.title
        timelineView.registerDelegate(self)
        
        buttonTrayView.receiverOfButtonTrayEvents = self
        buttonTrayView.soundwich = soundwich
        
        // Recreate the soundbiteview objects for any already-present soundbites
        if let soundwich = soundwich {
            for sb in soundwich.soundbites {
                try! timelineView.createSoundbiteView(sb)
            }
        }
        
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
    func updateDB() {
        if let s = soundwich {
            SoundwichStore.update(s, callback:{(error) in
                if (error != nil) {
                    NSLog("Error Updating.")
                }
            })
        }
    }

    func loadSoundwich() {
        if let s = soundwich {
            for soundbite in s.soundbites {
                NSLog("Loading soundbite for soundwich")
                try! timelineView.createSoundbiteView(soundbite)
            }
        }
    }

    // MARK: - Touch Handlers
    func onTouchUpInsidePlayPause(sender: UIButton) {
        guard let soundbites = soundwich?.soundbites else { return }

        if sender.state == UIControlState.Selected {
            playerController.playAll(soundbites)
        } else {
            playerController.pauseAll()
        }
    }

    func onUpdate(time: Double) {
        timelineView.constraintScrubberX.constant = (timelineView.bounds.width / 8.0) * CGFloat(time)
    }

    func onFinished() {
        buttonTrayView.playPauseButton.setupPlayButton()
        buttonTrayView.playPauseButton.selected = false
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
                
                updateDB()
            }
        }
    }
    
    
    
    
    // =================================================
    
    // Required protocol "MessagesFromTimelineDelegate"
    
    func soundbiteTimespecDidChange(name:String, newSpec:Soundbite) {
        try! soundwich!.registerTimespecChange(newSpec)
        updateDB()
    }

    func userMovedScrubber(newPositionInSeconds:Float, interactionHasEnded:Bool) {
        
    }
    
    func soundbiteDeleteRequested(name:String) {
        let components = name.characters.split { $0 == "/" } .map { String($0) }
        let last = "/" + components[components.count - 1]
        print("soundbiteDeleteRequested: \(last)")

        do {
            try soundwich!.deleteSoundbite(name)
            try timelineView.deleteSoundbite(name)
        }
        catch {
            // Absurdity!!!  We really don't expect this!!  The databases have become insane/outofsync!  Help!!!
        }
    }
    
    
    func soundbiteDuplicateRequested(name:String) {
        if let soundwich = soundwich {
            
            let goodChannel = soundwich.nextAvailableChannel()
            if goodChannel < 0 {
                print("Error: cannot do duplicate because the tracks are all full.")
                return
            }
            
            
            let idxOfSrc = soundwich.getSoundbiteIndexByURL(name)
            if idxOfSrc >= 0 {
                let srcOfCopy = soundwich.soundbites[idxOfSrc]
                
                let fileManager = NSFileManager.defaultManager()
                
                
                let documentDirectory = NSSearchPathForDirectoriesInDomains(
                    .DocumentDirectory,
                    .UserDomainMask,
                    true
                    )[0]
                let path = documentDirectory.stringByAppendingString("/soundbite-\(NSDate().timeIntervalSince1970).m4a")
                
                let nameURL = NSURL(string: name)!
                let pathURL = NSURL(fileURLWithPath: path)
                
                do {
                    try fileManager.copyItemAtURL(nameURL, toURL: pathURL)
                } catch let error as NSError {
                    print("error: \(error)\n")
                    return
                }
                
                let newSoundbite = Soundbite(url: String(pathURL), channel: goodChannel, duration: srcOfCopy.duration())
                newSoundbite.audioData = srcOfCopy.audioData
                
                try! soundwich.addSoundbite(newSoundbite)
                try! timelineView.createSoundbiteView(newSoundbite)
                
                updateDB()
            }
        }
    }


}
