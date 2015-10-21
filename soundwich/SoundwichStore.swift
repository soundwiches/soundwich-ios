//
//  SoundwichStore.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/29/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import Foundation
import Parse
//import RealmSwift

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
    
    static func remove(soundwich:Soundwich, callback:(NSError?) -> ()) {

        let query = PFQuery(className: CLASS_NAME)
        if let idKey = soundwich.id {
            query.getObjectInBackgroundWithId(idKey) { (object, error) -> Void in
                
                if error != nil {
                    return callback(error)
                }
                
                if let o = object {
                    o.deleteInBackground()
                    return callback(nil)
                }
                
                callback(nil)
            }
        }
    }
    
    static func removeAll() {
        let query = PFQuery(className: CLASS_NAME)
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error) -> Void in
            
            objects?.forEach({ (object:PFObject) -> () in
                object.deleteInBackground()
            })
        }
    }

    static func update(soundwich:Soundwich, callback:(NSError?) -> ()) {
        let query = PFQuery(className: CLASS_NAME)
        if let idKey = soundwich.id {
            query.getObjectInBackgroundWithId(idKey) { (object, error) -> Void in
                
                if error != nil {
                    return callback(error)
                }
                
                if let o = object {
                    o.setObject(soundwich.title, forKey: "title")
                    
                    if let d = soundwich.duration {
                        o.setObject(d, forKey: "duration")
                    }
                    
                    let xs = soundwich.soundbites
                    for (index, value) in xs.enumerate() {
                        NSLog("setting soundbite for soundwich")

                        o.setObject(value.url, forKey: "url\(index)")
                        
                        o.setObject(value.channel, forKey: "channel\(index)")
                        o.setObject(value.start, forKey: "start\(index)")
                        o.setObject(value.end, forKey: "end\(index)")
                        
                        o.setObject(value.clipStart, forKey: "clipStart\(index)")
                        o.setObject(value.clipEnd, forKey: "clipEnd\(index)")
                    }
                    
                    o.saveInBackground()

                    return callback(nil)
                }
                
                callback(nil)
            }
        }
    }
    
    static func toSoundwich(obj:PFObject) -> Soundwich {
        let id = obj.objectId
        let title = obj.objectForKey("title") as! String
        let duration = obj.objectForKey("duration") as? Float

        let soundwich = Soundwich(title: title)
        soundwich.id = id
        soundwich.duration = duration
        
        for index in 0...7 {
            let channel = obj.objectForKey("channel\(index)") as? Int
            let start = obj.objectForKey("start\(index)") as? Float
            let end = obj.objectForKey("end\(index)") as? Float
            let clipStart = obj.objectForKey("clipStart\(index)") as? Float
            let clipEnd = obj.objectForKey("clipEnd\(index)") as? Float
            let url = obj.objectForKey("url\(index)") as? String
            
            let soundbite = Soundbite(url: url ?? "", channel: channel ?? 0, duration: 1)
            
            soundbite.channel = channel ?? 0
            soundbite.start = start ?? 0
            soundbite.end = end ?? 0
            soundbite.clipStart = clipStart ?? 0
            soundbite.clipEnd = clipEnd ?? 0
            
            if (end != nil) {
                soundwich.soundbites.append(soundbite)
            }
        }
        
        
        return soundwich
    }

    static func toPFObject(soundwich:Soundwich) -> PFObject {
        let obj = PFObject(className: CLASS_NAME)
        
        obj.setObject(soundwich.title, forKey: "title")
        
        if let d = soundwich.duration {
            obj.setObject(d, forKey: "duration")
        }
        
        let xs = soundwich.soundbites
        for (index, value) in xs.enumerate() {
            obj.setObject(value.url, forKey: "url\(index)")
            obj.setObject(value.channel, forKey: "channel\(index)")
            obj.setObject(value.start, forKey: "start\(index)")
            obj.setObject(value.end, forKey: "end\(index)")
            
            obj.setObject(value.clipStart, forKey: "clipStart\(index)")
            obj.setObject(value.clipEnd, forKey: "clipEnd\(index)")
        }
    
        return obj
    }
}