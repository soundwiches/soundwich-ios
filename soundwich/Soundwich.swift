//
//  Soundwich.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/28/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import Foundation

class Soundwich {
    var id:String?
    var title:String!
    var audioUrl:String?
    var duration:Float?
    var soundbites:[Soundbite]?
    
    init(title:String) {
        self.title = title
    }
}