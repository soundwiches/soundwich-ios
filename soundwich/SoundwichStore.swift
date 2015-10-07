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
    //let realm = Realm()

    static var soundwiches:[Soundwich] = [Soundwich(title: "1"), Soundwich(title: "2")]

    static func get(id:String, callback:Soundwich -> ()) {
        
        let query = PFQuery(className: CLASS_NAME)
        
        query.getObjectInBackgroundWithId(id) { (obj, error) -> Void in
            let soundwich = toSoundwich(obj!)
            callback(soundwich)
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

    }

    static func update(soundwich:Soundwich) {
        // find the soundwich in soundwiches and update it
    }

    static func toSoundwich(obj:PFObject) -> Soundwich {
        let title = obj.objectForKey("title") as! String
        
        let soundwich = Soundwich(title: title)
        
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
        
        return obj
    }
}