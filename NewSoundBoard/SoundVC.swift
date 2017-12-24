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
    
    
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var soundNameTF: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecorder()
        playBtn.isEnabled = false
        addBtn.isEnabled = false
        
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
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            // create setting for audio recorder
            
            var settings: [String:Any] = [:]
            settings[AVFormatIDKey] = kAudioFormatMPEG4AAC
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            
            // create AudioRecorder object
            
            if let unwrappedAudioURL = audioURL {
                
                audioRecorder = try AVAudioRecorder(url: unwrappedAudioURL, settings: settings)
                audioRecorder?.prepareToRecord()
                
            }
            
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
            
            // Change button title to Record and enable play and add buttons
            recordBtn.setTitle("Record", for: .normal)
            playBtn.isEnabled = true
            addBtn.isEnabled = true
            
        } else if audioRecorder != nil {
            
            // Start Recording
            audioRecorder!.record()
            
            // Change button to Stop
            
            recordBtn.setTitle("Stop", for: .normal)
            
        } else {
            
            print("####### audioRecorder object is nil #######")
            
        }
        
    }
    
    @IBAction func playTapped(_ sender: Any) {
        
        do {
            
            if let unwrappedAudioURL = audioURL {
                
                try  audioPlayer = AVAudioPlayer(contentsOf: unwrappedAudioURL)
                
            }
            
            if let unwrappedAudioPlayer = audioPlayer {
                
                unwrappedAudioPlayer.play()
                
            }
            
        } catch let error as NSError {
            
            print(error.description)
            print(error.debugDescription)
            print(error.localizedDescription)
            
        }
        
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        if soundNameTF.text == nil || soundNameTF.text == "" {
            
            addBtn.setTitle("Name sound, then tap again.", for: .normal)
            
        } else {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let sound = Sound(context: context)
            
            sound.name = soundNameTF.text
            
            if let unwrappedAudioURL = audioURL {
                
                do {
                    
                    sound.audio = try NSData(contentsOf: unwrappedAudioURL) as Data
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    navigationController?.popViewController(animated: true)
                    
                } catch let error as NSError {
                    
                    print(error.description)
                    print(error.debugDescription)
                    print(error.localizedDescription)
                    
                }
                
            }
            
        }
        
        
        
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
