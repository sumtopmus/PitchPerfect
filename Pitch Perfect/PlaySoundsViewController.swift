//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Oleksandr Iaroshenko on 04.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    // Default constants
    private struct Defaults {
        static let NormalRate: Float = 1.0
        static let SlowRate: Float = 0.5
        static let FastRate: Float = 2.0
        static let NormalPitch: Float = 1.0
        static let PitchShift: Float = 1000
        static let HighPitch: Float = NormalPitch + PitchShift
        static let LowPitch: Float = NormalPitch - PitchShift
    }

    // Instancec of audio engine to add effects
    private var audioEngine = AVAudioEngine()
    // Actual audio file
    private var audioFile: AVAudioFile!
    // Recorded audio (passed to VC as Model)
    var recordedAudio: RecordedAudio! {
        didSet {
            audioFile = AVAudioFile(forReading: recordedAudio.filePathURL, error: nil)
        }
    }

    // Play audio slow on snail button pressed
    @IBAction func playAudioSlowly(sender: UIButton) {
        playAudio(rate: Defaults.SlowRate)
    }

    // Play audio fast on rabbit button pressed
    @IBAction func playAudioFast(sender: UIButton) {
        playAudio(rate: Defaults.FastRate)
    }

    // Play audio with chipmunk effect
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudio(pitch: Defaults.HighPitch)
    }

    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudio(pitch: Defaults.LowPitch)
    }

    // MARK: - Playing audio engine

    // Play audio with given pitch
    private func playAudio(#pitch: Float) {
        playAudio(pitch: pitch, rate: Defaults.NormalRate)
    }

    // Play audio with given rate
    private func playAudio(#rate: Float) {
        playAudio(pitch: Defaults.NormalPitch, rate: rate)
    }

    // Play audio with given pitch and rate
    private func playAudio(#pitch: Float, rate: Float) {
        audioEngine.stop()
        audioEngine.reset()

        var audioPlayer = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayer)

        var timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        timePitch.rate = rate
        audioEngine.attachNode(timePitch)

        audioEngine.connect(audioPlayer, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)

        audioPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)

        audioEngine.startAndReturnError(nil)
        
        audioPlayer.play()
    }

    // Stop audio on stop button pressed
    @IBAction func stopAudio(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
    }

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
