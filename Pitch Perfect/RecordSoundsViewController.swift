//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Nikunj Jain on 03/02/16.
//  Copyright © 2016 Nikunj Jain. All rights reserved.
//

import UIKit
import AVFoundation



class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var isPaused = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordingLabel.text = "Tap to record"
        recordingLabel.hidden = false
        micButton.enabled = true
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        
        print("in recordAudio")
        if(stopButton.hidden == true) {
            recordingLabel.text = "Recording..."
            stopButton.hidden = false
            pauseButton.hidden = false
            micButton.enabled = false
        }
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

        let recordingName = "myAudio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
//        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            recordedAudio = RecordedAudio(fileURL: recorder.url, audioTitle: recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        } else {
            
            print("Recording failed")
            recordingLabel.text = "Tap to record"
            micButton.enabled = true
            stopButton.hidden = true
            pauseButton.hidden = true
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
    
        audioRecorder.pause()
        pauseButton.hidden = true
        resumeButton.hidden = false
        recordingLabel.text = "Recording paused"
    
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        
        audioRecorder.record()
        resumeButton.hidden = true
        pauseButton.hidden = false
        recordingLabel.text = "Recording..."
        
    }
    
    
    @IBAction func stopRecording(sender: UIButton) {
    
        if (stopButton.hidden == false){
            recordingLabel.hidden = true
            stopButton.hidden = true
            pauseButton.hidden = true
            micButton.enabled = true
        }
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

    }
    
    
}