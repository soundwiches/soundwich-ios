//
//  SoundwichEditorViewController.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/25/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class SoundwichEditorViewController: UIViewController, MessagesFromTimelineDelegate
{
    var soundwich:Soundwich?
    
    @IBOutlet weak var timelineView: TimelineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        self.title = soundwich?.title
        timelineView.registerDelegate(self)
        
        // Sklar's testing of the timeline soundbites
        try! timelineView.createSoundbite("1", channelIndex:0, spec: Timespec(start:0, end:3, clipStart:0, clipEnd:3))
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
    
    
    
    // Required protocol "MessagesFromTimelineDelegate"
    
    func soundbiteTimespecDidChange(name:String, newSpec:Timespec) {
        
    }
    
    func soundbiteDeleteRequested(name:String) {
        
    }
    
    func soundbiteDuplicateRequested(name:String) {
        
    }
    
    func soundbiteRenameRequested(nameCurrent:String, nameNew:String) {
        
    }
}
