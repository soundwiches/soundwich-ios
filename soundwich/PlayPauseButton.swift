//
//  PlayPauseButton.swift
//  soundwich
//
//  Created by Matt Hayes on 10/19/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class PlayPauseButton: UIButton {

    let pauseButtonImage = UIImage(named: "Pause Button Light")
    let pauseButtonDisabledImage = UIImage(named: "Pause Button Light Disabled")

    let playButtonImage = UIImage(named: "Play Button Light")
    let playButtonDisabledImage = UIImage(named: "Play Button Light Disabled")

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addTarget(
            self,
            action: "onTouchDown:",
            forControlEvents: .TouchDown
        )

        addTarget(
            self,
            action: "onTouchUp:",
            forControlEvents: [
                .TouchUpInside,
                .TouchUpOutside
            ]
        )

        setupPlayButton()
    }

    func onTouchDown(sender: UIButton) {
        sender.highlighted = false
    }

    func onTouchUp(sender: UIButton) {
        sender.highlighted = false
        selected = !selected
        selected
            ? setupPauseButton()
            : setupPlayButton()
    }

    func setupPauseButton() {
        setImage(
            pauseButtonImage,
            forState: .Normal
        )

        setImage(
            pauseButtonImage,
            forState: .Selected
        )

        setImage(
            pauseButtonDisabledImage,
            forState: .Disabled
        )
    }

    func setupPlayButton() {
        setImage(
            playButtonImage,
            forState: .Normal
        )

        setImage(
            playButtonImage,
            forState: .Selected
        )

        setImage(
            playButtonDisabledImage,
            forState: .Disabled
        )
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
