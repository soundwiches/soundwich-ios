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

    let recorderSettings = [
        AVFormatIDKey: kAudioFormatAppleLossless,
        AVSampleRateKey: 44100.0,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey: AVAudioQuality.Max.rawValue,
        AVEncoderBitRateKey: 128000
    ]
    var recorder: AVAudioRecorder?

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
            action: "onTouchDownRecord:",
            forControlEvents: .TouchDown
        )

        recordButton.addTarget(
            self,
            action: "onTouchUpRecord:",
            forControlEvents: [
                .TouchUpInside,
                .TouchUpOutside
            ]
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

    // MARK: - Touch Handlers
    func onTouchDownRecord(sender: UIButton) {
        loopButton.enabled = false
        playPauseButton.enabled = false

        let directories = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory,
            domainMask: .UserDomainMask,
            expandTilde: true
        )
        let documentDirectory = directories[0]
        let path = documentDirectory.stringByAppendingPathComponent("track1.m4a")

        recorder = try? AVAudioRecorder(URL: NSURL(fileURLWithPath: path), settings: recorderSettings)
        if let recorder = recorder {
            recorder.delegate = self
            recorder.meteringEnabled = true
            recorder.prepareToRecord()
        }
    }

    func onTouchUpRecord(sender: UIButton) {
        loopButton.enabled = true
        playPauseButton.enabled = true
    }

    // MARK: - AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("\n\n\n", "audioRecorderDidFinishRecording:", flag)
    }

    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        print("\n\n\n", "audioRecorderEncodeErrorDidOccur:", error)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
