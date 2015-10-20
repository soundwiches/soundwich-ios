//
//  SoundwichFeedCell.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/28/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

protocol SoundwichFeedCellDelegate {
    func onPlayTapped(soundwich:Soundwich, sender: AnyObject);
}

class SoundwichFeedCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    var delegate: SoundwichFeedCellDelegate?
    var isPlaying = false
    
    @IBOutlet weak var playButton: UIButton!
    
    var soundwich: Soundwich! {
        didSet {
            self.titleLabel.text = soundwich.title
        }
    }
    
    @IBAction func onPlayTapped(sender: AnyObject) {
        delegate?.onPlayTapped(soundwich, sender: sender)
        
        if (isPlaying) {
            isPlaying = false
            playButton.setImage(UIImage(named: "Play Button Dark"), forState: UIControlState.Normal)
        } else {
            isPlaying = true
            playButton.setImage(UIImage(named: "Pause Button Dark"), forState: UIControlState.Normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false
    }
}