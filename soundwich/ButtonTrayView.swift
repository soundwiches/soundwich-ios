//
//  ButtonTrayView.swift
//  soundwich
//
//  Created by Matt Hayes on 10/19/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit
import AVFoundation

class ButtonTrayView: UIView, AVAudioRecorderDelegate {

    let loopButton = LoopButton(frame: CGRect(x: 24, y: 26, width: 68, height: 68))
    let recordButton = RecordButton(frame: CGRect(x: 113, y: 13, width: 96, height: 96))
    let playPauseButton = PlayPauseButton(frame: CGRect(x: 228, y: 26, width: 68, height: 68))

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupButtons()
        setupRecording()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupButtons()
        setupRecording()
    }

    func setupButtons() {
        // print("\n\n\n", "setupButtons")
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

    func setupRecording() {
        // print("\n\n\n", "setupRecording")
        let session = AVAudioSession.sharedInstance()
        if session.respondsToSelector("requestRecordPermission:") {
            session.requestRecordPermission({ (granted) -> Void in
                if granted {
                    // print("\n\n\n", "granted")

                    // Ignore errors by piping them to _.
                    _ = try? session.setCategory(
                        AVAudioSessionCategoryPlayAndRecord,
                        withOptions: [.DefaultToSpeaker]
                    )
                } else {
                    // print("\n\n\n", "not granted")
                }
            })
        }
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
