//
//  AudioTests.swift
//  WakyZzz
//
//  Created by Gabriel Balta on 11/10/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import XCTest
@testable import WakyZzz

class AudioTests: XCTestCase {

    func testAudio() {
        let audioPlayer = AudioPlayerManager()
        
        // Testing sound.mp3
        audioPlayer.playSound(evilOn: false)
        XCTAssert(audioPlayer.player.isPlaying == true, "Audio failed to play standard sound file")
        audioPlayer.stopSound()
        XCTAssert(audioPlayer.player.isPlaying == false, "Audio failed to stop")
        
        // Testing evilSound.mp3
        audioPlayer.playSound(evilOn: true)
        XCTAssert(audioPlayer.player.isPlaying == true, "Audio failed to play evil sound file")
        audioPlayer.stopSound()
        XCTAssert(audioPlayer.player.isPlaying == false, "Audio failed to stop")
    }

}
