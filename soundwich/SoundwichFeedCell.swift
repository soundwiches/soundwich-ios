//
//  SoundwichFeedCell.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/28/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

protocol SoundwichFeedCellDelegate {
    func onPlaying(soundwich:Soundwich, sender: AnyObject);
    func onPause(soundwich:Soundwich, sender: AnyObject);
}

class SoundwichFeedCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var starttTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!

    var delegate: SoundwichFeedCellDelegate?
    var isPlaying = false

    var soundwich: Soundwich! {
        didSet {
            self.titleLabel.text = soundwich.title
        }
    }
    
    @IBAction func onPlayTapped(sender: AnyObject) {
        if (isPlaying) {
            isPlaying = false
            playButton.setImage(UIImage(named: "Play Button Dark"), forState: UIControlState.Normal)
            delegate?.onPause(soundwich, sender: sender)
        } else {
            isPlaying = true
            playButton.setImage(UIImage(named: "Pause Button Dark"), forState: UIControlState.Normal)
            delegate?.onPlaying(soundwich, sender: sender)
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