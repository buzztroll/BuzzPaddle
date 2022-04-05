//
//  TimeBasedUpdateFilter.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/25/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import AVFoundation
import CoreLocation


class TimeBaseUpdateFilter : EventFilter
{
    var mInterval : Double
    var mNextUpdate : Double
    var mElapsedTime : Double
    let mEventStringConsumer : EventStringConsumer
    
    init(theInterval: Double, theEventConsumer: EventStringConsumer) {
        mEventStringConsumer = theEventConsumer
        mNextUpdate = theInterval
        mInterval = theInterval
        mElapsedTime = 0.0
    }
    
    func start() {
        mNextUpdate = mInterval
        mElapsedTime = 0.0
    }
    
    func timeUpdate(theElapsedTime : Double) {
        self.mElapsedTime = theElapsedTime
        
        if theElapsedTime > mNextUpdate {
            mNextUpdate += mInterval
            tic()
        }
    }
    
    func locationUpdate(theLocation : [CLLocation]) {
        // This one doesn't use it
    }
    
    func tic() {
        let aSay = getSayString()
        mEventStringConsumer.incomingString(theValue: aSay)
    }
    
    func getSayString() -> String {
        NSLog("Base class should not be used here")
        return ""
    }
    
    func stop() {
    }
}
