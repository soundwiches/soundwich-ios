//
//  SoundwichStore.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/29/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import Foundation
import Parse
import RealmSwift

class SoundwichStore {
    static let CLASS_NAME = "Soundwich"

    static var soundwiches:[Soundwich] = []

    static func get(id:String, callback:(Soundwich?, NSError?) -> ()) {
        
        let query = PFQuery(className: CLASS_NAME)
        
        query.getObjectInBackgroundWithId(id) { (object, error) -> Void in
            
            if error != nil {
                return callback(nil, error)
            }
            
            if let o = object {
                let soundwich = toSoundwich(o)
                return callback(soundwich, nil)
            }
            
            callback(nil, NSError(domain: "Parse", code: 1, userInfo: nil))
        }
    }
    
    static func getAll(callback:([Soundwich]?, NSError?) -> ()) {
        
        let query = PFQuery(className: CLASS_NAME)

        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if error != nil {
                return callback(nil, error)
            }

            let soundwiches = objects?.map({ (object:PFObject) -> Soundwich in
                let soundwich = toSoundwich(object)
                return soundwich
            })

            callback(soundwiches, error)
        }
    }
    
    static func add(soundwich:Soundwich, callback:(Soundwich?, NSError?) -> ()) {
        let obj = toPFObject(soundwich)
        
        obj.saveInBackgroundWithBlock { (result, error) -> Void in
            if error != nil {
                return callback(nil, error)
            }

            soundwich.id = obj.objectId
            callback(soundwich, nil)
        }
    }
    
    static func remove(soundwich:Soundwich) {
        // find the soundwich in soundwiches and delete it
        
        let object = toPFObject(soundwich)
        
        object.deleteInBackground()
    }

    static func update(soundwich:Soundwich) {
        // find the soundwich in soundwiches and update it
    }
    
    static func toSoundwich(obj:PFObject) -> Soundwich {
        let id = obj.objectId
        let title = obj.objectForKey("title") as! String
        let duration = obj.objectForKey("duration") as? Float
        let audioUrl = obj.objectForKey("audioUrl") as? String
        let audioData = obj.objectForKey("audioData") as? NSData

        let soundwich = Soundwich(title: title)
        soundwich.id = id
        soundwich.duration = duration
        soundwich.audioUrl = audioUrl
        soundwich.audioData = audioData

        return soundwich
    }

    static func toPFObject(soundwich:Soundwich) -> PFObject {
        let obj = PFObject(className: CLASS_NAME)
        
        obj.setObject(soundwich.title, forKey: "title")
        
        if let d = soundwich.duration {
            obj.setObject(d, forKey: "duration")
        }

        if let a = soundwich.audioUrl {
            obj.setObject(a, forKey: "audioUrl")
        }
        
        if let data = soundwich.audioData {
            let filename = "audioFile"
            let file = PFFile(name:filename, data:data)
            obj.setObject(file, forKey: "audioData")
        }
        
        return obj
    }
}