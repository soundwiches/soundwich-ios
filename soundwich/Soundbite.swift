//
//  Soundbite.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/29/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import Foundation




class Soundbite {
    var audioData:NSData?

    var url: String
    var channel: Int
    
    // Both start and end are relative to the start of the timeline:
    var start: Float = 0
    var end: Float = 0
    
    // Both clipStart and clipEnd are relative to the start of this Timespec
    var clipStart: Float = 0
    var clipEnd: Float = 0
    
    func duration() -> Float {
        return end - start
    }
    
    func clipDuration() -> Float {
        return clipEnd - clipStart
    }
    
    init(url:String, channel:Int, duration:Float) {
        self.start = 0
        self.end = duration
        self.clipEnd = duration
        self.channel = channel
        self.url = url
    }
    
    init(sourceSoundbite:Soundbite) {
        self.url = sourceSoundbite.url
        self.channel = sourceSoundbite.channel
        self.start = sourceSoundbite.start
        self.end = sourceSoundbite.end
        self.clipStart = sourceSoundbite.clipStart
        self.clipEnd = sourceSoundbite.clipEnd
    }
    
}