//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Oleksandr Iaroshenko on 04.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // Magic values
    private struct Defaults {
        static let RecordingFileName = "record"
        static let ExtensionDelimiter = "."
        static let Extension = "wav"
        static let StopRecordingSegue = "Stop Recording"
        static let TapToRecord = "tap to record"
        static let RecordingInProgress = "recording"
    }

    // Button with microphone, press to record audio
    @IBOutlet weak var microphoneButton: UIButton!
    // Label that is show when the recording is in process
    @IBOutlet weak var recordingLabel: UILabel!
    // Stop button that appears after recording button is clicked
    @IBOutlet weak var stopButton: UIButton!

    // Audio recorder
    var audioRecorder: AVAudioRecorder?
    // Recorded audio
    var recordedAudio: RecordedAudio?

    // Action happens when the record button is pressed
    @IBAction func recordAudio(sender: UIButton) {
        // Change the state of the buttons
        microphoneButton.enabled = false
        recordingLabel.text = Defaults.RecordingInProgress
        stopButton.hidden = false

        // Record audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String

        let recordingFileNameWithExtension = Defaults.RecordingFileName + Defaults.ExtensionDelimiter + Defaults.Extension
        let pathArray = [dirPath, recordingFileNameWithExtension]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)

        // Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        // Initialize audio recorder and start recording
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder!.delegate = self
        audioRecorder!.meteringEnabled = true
        audioRecorder!.prepareToRecord()
        audioRecorder!.record()
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            // Create a model (recorded audio)
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent, filePathURL: recorder.url)
            // Move to the next scene
            performSegueWithIdentifier(Defaults.StopRecordingSegue, sender: recorder)
        }
    }

    // Action happens when the stop button is clicked
    @IBAction func stopRecording(sender: UIButton) {
        microphoneButton.enabled = true
        stopButton.hidden = true

        audioRecorder?.stop()
    }

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        // Change the state of the buttons to defaults when the view appears on the screen
        microphoneButton.enabled = true
        recordingLabel.text = Defaults.TapToRecord
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Defaults.StopRecordingSegue {
            if let playSoundsVC = segue.destinationViewController as? PlaySoundsViewController {
                playSoundsVC.recordedAudio = recordedAudio
            }
        }
    }
}