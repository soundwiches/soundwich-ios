//
//  Soundwich.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/28/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import Foundation


enum SoundwichError: ErrorType {
    case ChannelAlreadyInUse
}

    
class Soundwich {
    var id:String?
    var title:String!
    var duration:Float?
    var soundbites:[Soundbite]
    
    let channelCount = 8
    
    init(title:String) {
        self.title = title
        self.soundbites = [ ]
    }

    
    // Returns -1 if no available channel
    func allAvailableChannels() -> Set<Int> {
        var availableChannels = Set<Int>()
        for index in 0...(channelCount-1) {
            availableChannels.insert(index)
        }
        for sb in soundbites {
            availableChannels.remove(sb.channel)
        }

        return availableChannels
    }
    
    
    // Returns -1 if no available channel
    func nextAvailableChannel() -> Int {
        let availableChannels = allAvailableChannels()
        
        // The only way to get the first item from a Swift Set is to iterate??  Really?
        for item in availableChannels {
            return item
        }
        
        return -1
    }

    
    // Throws an exception if the new sb's channel is already in use!
    func addSoundbite(sb : Soundbite) throws {
        // Check to make sure the new soundbite is using an available channel
        if self.allAvailableChannels().contains(sb.channel) {
            soundbites.append(sb)
        } else {
            throw SoundwichError.ChannelAlreadyInUse
        }
    }
    
}