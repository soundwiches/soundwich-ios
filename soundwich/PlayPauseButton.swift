//
//  PlayPauseButton.swift
//  soundwich
//
//  Created by Matt Hayes on 10/19/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class PlayPauseButton: UIView {

    var pauseButton = UIButton(frame: CGRect(x: 0, y: 0, width: 68, height: 68))
    var pauseButtonImage = UIImage(named: "Pause Button Light")
    var pauseButtonDisabledImage = UIImage(named: "Pause Button Light Disabled")

    var playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 68, height: 68))
    var playButtonImage = UIImage(named: "Play Button Light")
    var playButtonDisabledImage = UIImage(named: "Play Button Light Disabled")

    var enabled = true {
        didSet {
            pauseButton.enabled = self.enabled
            playButton.enabled = self.enabled
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupPauseButton()
        setupPlayButton()

        addSubview(playButton)
    }

    func setupPauseButton() {
        pauseButton.setImage(
            pauseButtonImage,
            forState: .Normal
        )

        pauseButton.setImage(
            pauseButtonDisabledImage,
            forState: .Disabled
        )

        pauseButton.addTarget(
            self,
            action: "onTouchUpInside:",
            forControlEvents: .TouchUpInside
        )

        pauseButton.addTarget(
            self,
            action: "onTouchDown:",
            forControlEvents: .TouchDown
        )
    }

    func setupPlayButton() {
        playButton.setImage(
            playButtonImage,
            forState: .Normal
        )

        playButton.setImage(
            playButtonDisabledImage,
            forState: .Disabled
        )

        playButton.addTarget(
            self,
            action: "onTouchUpInside:",
            forControlEvents: .TouchUpInside
        )

        playButton.addTarget(
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
        sender.removeFromSuperview()
        switch (sender) {
        case pauseButton:
            addSubview(playButton)
            break
        case playButton:
            addSubview(pauseButton)
            break
        default:
            // Do nothing.
            return
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
