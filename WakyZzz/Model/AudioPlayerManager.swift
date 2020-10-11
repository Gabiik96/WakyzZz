//
//  AudioPlayerManager.swift
//  WakyZzz
//
//  Created by Gabriel Balta on 08/10/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import AVFoundation

class AudioPlayerManager {
    
    var player: AVAudioPlayer!

    func playSound(evilOn: Bool) {
        let soundName = evilOn ? "evilsound" : "sound"
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.numberOfLoops = 10
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        player?.stop()
    }
    
}
