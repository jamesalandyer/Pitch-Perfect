//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by James Dyer on 5/1/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var customSpeedTextField: UITextField!
    @IBOutlet weak var customPitchTextField: UITextField!
    
    var recordedAudioURL: NSURL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: NSTimer!
    
    var speed: Float = 1
    var pitch: Float = 0
    
    enum ButtonType: Int { case Slow = 0, Fast, Chipmunk, Vader, Echo, Reverb, Custom }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "PLAY"
        
        //Dismiss keyboard when done button
        let keyboard = UIImage(named: "Keyboard.png")
        let navButton = UIButton()
        navButton.setImage(keyboard, forState: .Normal)
        navButton.frame = CGRectMake(0, 0, 30, 30)
        navButton.addTarget(self, action: #selector(dismissKeyboard), forControlEvents: .TouchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = navButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        //Sets the text fields up
        customSpeedTextField.delegate = self
        customSpeedTextField.keyboardType = UIKeyboardType.DecimalPad
        customPitchTextField.delegate = self
        customPitchTextField.keyboardType = UIKeyboardType.DecimalPad
        
        setupAudio()
    }
    
    override func viewDidAppear(animated: Bool) {
        stopButton.enabled = false
        
        let audioLength = "\(Float(Double(self.audioFile.length) / Double(self.audioFile.processingFormat.sampleRate) / 100.0))"
        lengthLabel.text = audioLength
    }
    
    @IBAction func playSoundForButton(sender: AnyObject) {
        switch (ButtonType(rawValue: sender.tag)!) {
        case .Slow:
            playSound(rate: 0.5)
        case .Fast:
            playSound(rate: 1.5)
        case .Chipmunk:
            playSound(pitch: 1000)
        case .Vader:
            playSound(pitch: -1000)
        case .Echo:
            playSound(echo: true)
        case .Reverb:
            playSound(reverb: true)
        case .Custom:
            setCustomValues()
        }
        
        configureUI(.Playing)
        
    }
    
    @IBAction func stopSounds(sender: AnyObject) {
        stopAudio()
    }
    
    func setCustomValues() {
        if let newSpeed = Float(customSpeedTextField.text!) where customSpeedTextField.text != "" {
            speed = newSpeed
        }
        if let newPitch = Float(customPitchTextField.text!) where customPitchTextField.text != "" {
            pitch = newPitch
        }
        playSound(rate: speed, pitch: pitch)
        resetTextFields()
    }
    
    func resetTextFields() {
        customSpeedTextField.text = ""
        customPitchTextField.text = ""
        speed = 1
        pitch = 0
    }
    
    func dismissKeyboard() {
        customSpeedTextField.resignFirstResponder()
        customPitchTextField.resignFirstResponder()
    }
    
}
