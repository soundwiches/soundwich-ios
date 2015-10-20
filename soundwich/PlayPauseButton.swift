//
//  PlayPauseButton.swift
//  soundwich
//
//  Created by Matt Hayes on 10/19/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class PlayPauseButton: UIView {

    let pauseButton = UIButton(frame: CGRect(x: 0, y: 0, width: 68, height: 68))
    let pauseButtonImage = UIImage(named: "Pause Button Light")
    let pauseButtonDisabledImage = UIImage(named: "Pause Button Light Disabled")

    let playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 68, height: 68))
    let playButtonImage = UIImage(named: "Play Button Light")
    let playButtonDisabledImage = UIImage(named: "Play Button Light Disabled")

    var enabled = true {
        didSet {
            pauseButton.enabled = self.enabled
            playButton.enabled = self.enabled
        }
    }

    var isPlaying: Bool {
        get {
            return playButton.superview == nil
        }
        set(newValue) {
            if newValue {
                addSubview(pauseButton)
                if playButton.superview != nil {
                    playButton.removeFromSuperview()
                }
            } else {
                addSubview(playButton)
                if pauseButton.superview != nil {
                    pauseButton.removeFromSuperview()
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupPauseButton()
        setupPlayButton()

        isPlaying = false
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
        isPlaying = sender == playButton
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
