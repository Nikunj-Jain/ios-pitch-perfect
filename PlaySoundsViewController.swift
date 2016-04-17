//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Nikunj Jain on 05/02/16.
//  Copyright © 2016 Nikunj Jain. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var stopButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var audioPlayer2: AVAudioPlayer!
    var recievedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: recievedAudio.getfilePathURL())
        audioPlayer2 = try! AVAudioPlayer(contentsOfURL: recievedAudio.getfilePathURL())
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: recievedAudio.getfilePathURL())
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowly(sender: UIButton) {
        
        playAudio(0.5)

    }

    @IBAction func playFaster(sender: UIButton) {
        
        playAudio(2.0)
        
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
        
    }
    
    
    
    // Used the following blog as a guide for playEcho:
    // http://sandmemory.blogspot.in/2014/12/how-would-you-add-reverbecho-to-audio.html
    @IBAction func playEcho(sender: UIButton) {
    
        stopAllAudio()
        
        audioPlayer.currentTime = 0.00
        audioPlayer.volume = 1.00
        audioPlayer.rate = 1.0
        audioPlayer.play()
        
        let delay: NSTimeInterval = 0.2
        var playTime: NSTimeInterval
        playTime = audioPlayer2.deviceCurrentTime + delay

        audioPlayer2.currentTime = 0.00
        audioPlayer2.volume = 0.7
        audioPlayer2.playAtTime(playTime)
        
        stopButton.hidden = false
    
    }
    
    @IBAction func playReverb(sender: UIButton) {
        
        stopAllAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverb.wetDryMix = 50
        audioEngine.attachNode(reverb)
        
        audioEngine.connect(audioPlayerNode, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        audioPlayerNode.play()
        stopButton.hidden = false

        
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        
        stopAllAudio()
        
        audioPlayer.currentTime = 0.00
        stopButton.hidden = true
        
    }
    
    func playAudio(speed: Float) {
        
        stopAllAudio()
        
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.00
        audioPlayer.volume = 1.0
        audioPlayer.play()
        stopButton.hidden = false
        
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        
        stopAllAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        audioPlayerNode.play()
        stopButton.hidden = false
        
    }
    
    func stopAllAudio() {
        
        audioPlayer.stop()
        audioPlayer2.stop()
        audioEngine.stop()
        audioEngine.reset()
        
    }

}
