//
//  SoundwichEditorViewController.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/25/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class SoundwichEditorViewController: UIViewController {
    var soundwich:Soundwich?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        self.title = soundwich?.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data
    func add() {
        if let s = soundwich {
            SoundwichStore.add(s)
        }
    }
    
    func update() {
        if let s = soundwich {
            SoundwichStore.update(s)
        }
    }
}
