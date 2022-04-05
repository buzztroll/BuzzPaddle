//
//  SpeechManager.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 10/1/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import AVFoundation


class SpeechManager : NSObject, AVSpeechSynthesizerDelegate {
    var speechSynthesizer = AVSpeechSynthesizer()
    let audioSession = AVAudioSession.sharedInstance()
    let mUserDefaults = BuzzSpeedUserDefaults()
    
    override init() {
        super.init()
        speechSynthesizer.delegate = self
    }
    
    func speechSynthesizer(_: AVSpeechSynthesizer, didFinish: AVSpeechUtterance) {
        if speechSynthesizer.isSpeaking {
            return
        }
        speechSynthesizer.stopSpeaking(at: .word)
        do {
            try audioSession.setActive(false)
        }
        catch {
            BuzzLog(message: "Failed to duck the audio")
        }
    }

    func start() {
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.duckOthers)
            try audioSession.setActive(true)
        }
        catch {
            BuzzLog(message: "Failed to duck the audio")
        }
    }
    
    func saySomething(theSay : String) {
        let aSpeechUtterance = AVSpeechUtterance(string: theSay)
        
        var aVoice = AVSpeechSynthesisVoice(language: "en-US")
        let aVoiceName = mUserDefaults.getVoiceName()
        if aVoiceName != "Default US" {
            for voice in AVSpeechSynthesisVoice.speechVoices() {
                if #available(iOS 9.0, *) {
                    if voice.name == aVoiceName {
                        aVoice = voice
                    }
                }
            }
        }
    
        aSpeechUtterance.voice = aVoice
        speechSynthesizer.speak(aSpeechUtterance)
    }
    
    func stop() {
    }
}
