//
//  RecordButton.swift
//  soundwich
//
//  Created by Matt Hayes on 10/19/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class RecordButton: UIButton {

    let recordButtonImage = UIImage(named: "Record Button")
    let recordButtonSelectedImage = UIImage(named: "Record Button Selected")

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setImage(
            recordButtonImage,
            forState: .Normal
        )

        setImage(
            recordButtonSelectedImage,
            forState: .Highlighted
        )

        addTarget(
            self,
            action: "onTouchUp:",
            forControlEvents: [
                .TouchUpInside,
                .TouchUpOutside
            ]
        )

        addTarget(
            self,
            action: "onTouchDown:",
            forControlEvents: .TouchDown
        )
    }

    func onTouchDown(sender: UIButton) {
        // sender.highlighted = false
    }

    func onTouchUp(sender: UIButton) {
        // sender.highlighted = false
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
