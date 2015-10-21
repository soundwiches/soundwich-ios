//
//  SoundwichEditorViewController.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/25/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class SoundwichEditorViewController: UIViewController, MessagesFromTimelineDelegate, MessagesFromButtonTrayDelegate
{
    var soundwich:Soundwich?
    
    @IBOutlet weak var timelineView: TimelineView!
    @IBOutlet weak var buttonTrayView: ButtonTrayView!
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.clipsToBounds = true
        
        // Do any additional setup after loading the view, typically from a nib.        
        self.title = soundwich?.title
        timelineView.registerDelegate(self)
        
        buttonTrayView.receiverOfButtonTrayEvents = self
        
        /*
        // Sklar's testing of the timeline soundbites
        try! timelineView.createSoundbite("0", channelIndex:0, spec: Timespec(start:0, end:3, clipStart:0, clipEnd:3))
        try! timelineView.createSoundbite("1", channelIndex:1, spec: Timespec(start:0, end:4, clipStart:0, clipEnd:4))
        try! timelineView.createSoundbite("2", channelIndex:2, spec: Timespec(start:0, end:7, clipStart:1, clipEnd:6))
        try! timelineView.createSoundbite("3", channelIndex:3, spec: Timespec(start:0, end:8, clipStart:1, clipEnd:7))
        
        timelineView.moveScrubberHairline(4)
        */
        
        timelineView.setNeedsLayout()

        buttonTrayView.playPauseButton.addTarget(
            self,
            action: "onTouchUpInsidePlayPause:",
            forControlEvents: .TouchUpInside
        )
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
        guard let soundwich = soundwich else { return }
    }
    
    
    // Required protocol "MessagesFromButtonTrayDelegate"

    func recordingDidComplete(url: NSURL, duration: Double) {
        let newSoundbite = Soundbite(url: String(url), channel: 0, duration: Float(duration))
        // soundwich.addSoundbite
        try! timelineView.createSoundbiteView(newSoundbite)
    }
    
    
    // Required protocol "MessagesFromTimelineDelegate"
    
    func soundbiteTimespecDidChange(name:String, newSpec:Soundbite) {
        
    }

    func userMovedScrubber(newPositionInSeconds:Float, interactionHasEnded:Bool) {
        
    }
    
    func soundbiteDeleteRequested(name:String) {
        
    }
    
    func soundbiteDuplicateRequested(name:String) {
        
    }

}
