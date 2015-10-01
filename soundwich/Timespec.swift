//
//  Class_Timespec.swift
//  SoundEditor
//
//  Created by David Sklar on 9/30/15.
//  Copyright © 2015 David Sklar. All rights reserved.
//


struct Timespec {
    
    // Both start and end are relative to the start of the timeline:
    var start: Float = 0
    var end: Float = 0
    
    // Both clipStart and clipEnd are relative to the start of this Timespec
    var clipStart: Float = 0
    var clipEnd: Float = 0
    
    init(start: Float, end: Float) {
        self.start = start
        self.end = end
    }
    
    init(start: Float, end: Float, clipStart: Float, clipEnd: Float) {
        self.start = start
        self.end = end
        self.clipStart = clipStart
        self.clipEnd = clipEnd
    }
    
    func duration() -> Float {
        return end - start
    }
    
    func clipDuration() -> Float {
        return clipEnd - clipStart
    }
}
