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
        let goodChannel = soundwich?.nextAvailableChannel()
        if goodChannel >= 0 {
            let newSoundbite = Soundbite(url: String(url), channel: goodChannel!, duration: Float(duration))
            try! soundwich!.addSoundbite(newSoundbite)
            try! timelineView.createSoundbiteView(newSoundbite)
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
            // Absurdity!!!  We really don't expect this!!
        }
    }
    
    
    func soundbiteDuplicateRequested(name:String) {
        
    }

}
