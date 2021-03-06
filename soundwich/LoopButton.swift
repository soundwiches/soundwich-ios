//
//  LoopButton.swift
//  soundwich
//
//  Created by Matt Hayes on 10/19/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class LoopButton: UIButton {

    let loopButtonImage = UIImage(named: "Loop Button Light")
    let loopButtonDisabledImage = UIImage(named: "Loop Button Light Disabled")

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setImage(
            loopButtonDisabledImage,
            forState: .Normal
        )

        setImage(
            loopButtonDisabledImage,
            forState: .Disabled
        )

        setImage(
            loopButtonImage,
            forState: .Selected
        )

        addTarget(
            self,
            action: "onTouchUpInside:",
            forControlEvents: .TouchUpInside
        )

        addTarget(
            self,
            action: "onTouchDown:",
            forControlEvents: .TouchDown
        )
    }

    func onTouchDown(sender: UIButton) {
        sender.highlighted = false
    }

    func onTouchUpInside(sender: UIButton) {
        sender.highlighted = false
        sender.selected = !sender.selected
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
