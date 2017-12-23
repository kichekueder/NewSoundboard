//
//  SoundVC.swift
//  NewSoundBoard
//
//  Created by Tom Munhoven on 22/12/2017.
//  Copyright © 2017 Tom Munhoven. All rights reserved.
//

import UIKit
import AVFoundation

class SoundVC: UIViewController {
    
    
    @IBOutlet weak var RecordBtn: UIButton!
    @IBOutlet weak var PlayBtn: UIButton!
    @IBOutlet weak var AddBtn: UIButton!
    @IBOutlet weak var SoundNameTF: UITextField!
    
    var audioRecorder: AVAudioRecorder?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupRecorder()
        
        // Do any additional setup after loading the view.
    }
    
    func setupRecorder() {
        
        // create URL for audio file
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            
            // create settings for audio file
            
            let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            let audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            print("####### \(audioURL) #######")
            
            // create setting for audio recorder
            
            var settings: [String:Any] = [:]
            settings[AVFormatIDKey] = kAudioFileMPEG4Type
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            
            // create AudioRecorder object
            
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            audioRecorder?.prepareToRecord()
            
        } catch let error as NSError {
            
            print(error.description)
            print(error.localizedDescription)
            print(error.debugDescription)
            
        }
        
    }
    
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder != nil , audioRecorder!.isRecording {

            // Stop Recording
            audioRecorder!.stop()

            // Change button title to Record
            RecordBtn.setTitle("Record", for: .normal)
            
        } else if audioRecorder != nil {
            
            // Start Recording
            audioRecorder!.record()
            
            // CHange button to Stop
            
            RecordBtn.setTitle("Stop", for: .normal)
            
        } else {
            
            print("####### audioRecorder object is nil #######")
            
        }
        
    }
    
    @IBAction func playTapped(_ sender: Any) {
        
        
        
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        
        
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
