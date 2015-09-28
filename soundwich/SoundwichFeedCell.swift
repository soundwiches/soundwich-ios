//
//  SoundwichFeedCell.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/28/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class SoundwichFeedCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    var soundwich: Soundwich! {
        didSet {
            self.titleLabel.text = soundwich.title
        }
    }
}