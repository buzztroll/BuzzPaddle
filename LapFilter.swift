//
//  LapFilter.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/25/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import AVFoundation
import CoreLocation


class LapFilter : EventFilter {
    let mEventConsumer : EventStringConsumer
    var mLapCounter : Int
    let mPrefix : String
    
    init(theEventConsumer: EventStringConsumer, prefix : String) {
        mEventConsumer = theEventConsumer
        mLapCounter = 0
        mPrefix = prefix
    }
    
    func start() {
        mLapCounter = 0
    }
    
    func stop() {
    }
    
    func tic() {
        mLapCounter += 1
    }
    
    func timeUpdate(theElapsedTime : Double) {
    }
    
    func locationUpdate(theLocation : [CLLocation]) {
    }
    
    func getSayString() -> String {
        return String(format: "\(mPrefix) %d", mLapCounter)
    }
}
