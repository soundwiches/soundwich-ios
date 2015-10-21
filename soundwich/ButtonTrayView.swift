//
//  ButtonTrayView.swift
//  soundwich
//
//  Created by Matt Hayes on 10/19/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit
import AVFoundation


protocol MessagesFromButtonTrayDelegate {
    func recordingDidComplete(url:NSURL, duration:Double)
}


class ButtonTrayView: UIView, AVAudioRecorderDelegate {

    let loopButton = LoopButton(frame: CGRect(x: 24, y: 26, width: 68, height: 68))
    let recordButton = RecordButton(frame: CGRect(x: 110, y: 10, width: 100, height: 100))
    let playPauseButton = PlayPauseButton(frame: CGRect(x: 228, y: 26, width: 68, height: 68))
    
    var receiverOfButtonTrayEvents : MessagesFromButtonTrayDelegate?
    
    var timelineView : TimelineView?

    // Where we're going to put the soundbites.
    let documentDirectory = NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory,
        .UserDomainMask,
        true
    )[0]

    let recorderSettings = [
        AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatAppleLossless),
        AVSampleRateKey: 44100.0,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey: AVAudioQuality.Max.rawValue,
        AVEncoderBitRateKey: 128000
    ]
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupButtons()
        setupSession()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupButtons()
        setupSession()
    }

    func setupButtons() {
        // print("setupButtons")
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

    func setupSession() {
        // print("setupRecording")
        let session = AVAudioSession.sharedInstance()
        session.requestRecordPermission({ (granted) -> Void in
            if granted {
                // print("granted")

                // Ignore errors by piping them to _.
                _ = try? session.setCategory(
                    AVAudioSessionCategoryPlayAndRecord,
                    withOptions: [.DefaultToSpeaker]
                )
            } else {
                // print("not granted")
            }
        })
    }

    func setupRecorder() {
        let path = documentDirectory.stringByAppendingString("/soundbite-\(NSDate().timeIntervalSince1970).m4a")

        recorder = try? AVAudioRecorder(URL: NSURL(fileURLWithPath: path), settings: recorderSettings)
        if let recorder = recorder {
            recorder.delegate = self
            recorder.meteringEnabled = true
            recorder.prepareToRecord()
        }
    }

    func setupPlayer() {
        guard let recorder = recorder else { return }
        player = try? AVAudioPlayer(contentsOfURL: recorder.url)
//        if let player = player {
//            player.delegate = self
//            player.meteringEnabled = true
//            player.prepareToPlay()
//        }
    }

    // MARK: - Touch Handlers
    func onTouchDownRecord(sender: UIButton) {
        loopButton.enabled = false
        playPauseButton.enabled = false

        setupRecorder()
        if let recorder = recorder {
            if let timelineView = timelineView {
                // Immediate hard-reset to LHS
                timelineView.moveScrubberHairline(0, animationDuration: 0)
                // ... followed by a long slow ride to RHS
                timelineView.moveScrubberHairline(8, animationDuration: 8)
            }
            recorder.record()
            // print("recorder.recording", recorder.recording)
        }
    }
    
    func onTouchUpRecord(sender: UIButton) {
        loopButton.enabled = true
        playPauseButton.enabled = true
        
        if let recorder = recorder {
            recorder.stop()
            if let timelineView = timelineView {
                timelineView.moveScrubberHairline(0, animationDuration: 0)
            }
            // print("recorder.stopped", !recorder.recording)
            setupPlayer()
            if (player!.duration < 0.75) {
                recorder.deleteRecording()
            } else {
                player!.data?.writeToFile(recorder.url.path!, atomically: true) 
                if let receiverOfButtonTrayEvents = receiverOfButtonTrayEvents {
                    receiverOfButtonTrayEvents.recordingDidComplete(recorder.url, duration: Double(player!.duration))
                }
            }
        }
    }

    // MARK: - AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        // print("audioRecorderDidFinishRecording:", flag)
    }

    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        // print("audioRecorderEncodeErrorDidOccur:", error)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
