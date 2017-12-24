//
//  ViewController.swift
//  NewSoundBoard
//
//  Created by Tom Munhoven on 22/12/2017.
//  Copyright © 2017 Tom Munhoven. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sounds: [Sound] = []
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            
            sounds = try context.fetch(Sound.fetchRequest())
            tableView.reloadData()
            
        } catch let error as NSError {
            
            print(error.description)
            print(error.debugDescription)
            print(error.localizedDescription)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let sound = sounds[indexPath.row]
        cell.textLabel?.text = sound.name
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sound = sounds[indexPath.row]
        
        if let unwrappedSound = sound.audio {
            
            do {
                
                audioPlayer = try AVAudioPlayer(data: unwrappedSound)
                audioPlayer?.play()
                
            } catch let error as NSError {
                
                print(error.description)
                print(error.debugDescription)
                print(error.localizedDescription)
                
            }
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let sound = sounds[indexPath.row]
            context.delete(sound)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                
                sounds = try context.fetch(Sound.fetchRequest())
                tableView.reloadData()
                
            } catch let error as NSError {
                
                print(error.description)
                print(error.debugDescription)
                print(error.localizedDescription)
                
            }
            
        }
        
    }
    
}
