//
//  SoundwichFeedCell.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/28/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

protocol SoundwichFeedCellDelegate {
    func onEditTapped(soundwich:Soundwich, sender: AnyObject);
}

class SoundwichFeedCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    var delegate: SoundwichFeedCellDelegate?

    var soundwich: Soundwich! {
        didSet {
            self.titleLabel.text = soundwich.title
        }
    }
    
    @IBAction func onEditTapped(sender: AnyObject) {
        delegate?.onEditTapped(soundwich, sender: sender)
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