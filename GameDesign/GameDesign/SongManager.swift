//
//  SongManager.swift
//  GameDesign
//
//  Created by Javier Bonilla on 4/29/23.
//

import Foundation
import AVFoundation

class SongManager{
    
    static let shared = SongManager()

    var backgroundMusic: AVAudioPlayer?

    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "powerUP_Background", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)

            backgroundMusic = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = backgroundMusic else { return }

            //setting number of loops to -1 makes the song loop infintely
            player.numberOfLoops = -1
            player.volume = 0.7
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
