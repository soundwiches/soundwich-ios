//
//  SoundwichStore.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/29/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import Foundation

class SoundwichStore {
    static var soundwiches:[Soundwich] = [Soundwich(title: "1"), Soundwich(title: "2")]
    
    static func getAll() -> [Soundwich] {
        return soundwiches
    }
    
    static func add(soundwich:Soundwich) {
        soundwiches.append(soundwich)
    }
    
    static func update(soundwich:Soundwich) {
        // find the soundwich in soundwiches and update it
    }
}