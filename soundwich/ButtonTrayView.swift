//
//  ButtonTrayView.swift
//  soundwich
//
//  Created by Matt Hayes on 10/19/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class ButtonTrayView: UIView {

    var loopButton = LoopButton(frame: CGRect(x: 24, y: 26, width: 68, height: 68))
    var recordButton = RecordButton(frame: CGRect(x: 113, y: 13, width: 96, height: 96))
    var playPauseButton = PlayPauseButton(frame: CGRect(x: 228, y: 26, width: 68, height: 68))

    override func didMoveToSuperview() {
        backgroundColor = UIColor(white: 44.0/255.0, alpha: 1.0)

        addSubview(loopButton)
        addSubview(recordButton)
        addSubview(playPauseButton)

        recordButton.addTarget(
            self,
            action: "onTouchDown:",
            forControlEvents: .TouchDown
        )

        recordButton.addTarget(
            self,
            action: "onTouchUpInside:",
            forControlEvents: .TouchUpInside
        )
    }

    func onTouchDown(sender: UIButton) {
        playPauseButton.enabled = false
    }

    func onTouchUpInside(sender: UIButton) {
        playPauseButton.enabled = true
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
