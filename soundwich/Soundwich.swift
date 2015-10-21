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
    case NameUnknown
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
        for item in availableChannels.sort() {
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
    
    
    func getSoundbiteIndexByURL(url: String) throws -> Int {
        var retval = 0
        for sb in soundbites {
            if sb.url == url {
                return retval
            } else {
                retval += 1
            }
        }
        throw SoundwichError.NameUnknown
    }
    
    
    func deleteSoundbite(url: String) throws {
        let idx = try? self.getSoundbiteIndexByURL(url)
        if let idx = idx {
            self.soundbites.removeAtIndex(idx)
            do {
                try NSFileManager.defaultManager().removeItemAtPath(url)
            }catch{
                print("LEAK:  Unable to delete m4a file: " + url)
            }
        }
        else {
            throw SoundwichError.NameUnknown
        }
    }
    
    
    
    func registerTimespecChange(new : Soundbite) throws {
        
    }
    
}