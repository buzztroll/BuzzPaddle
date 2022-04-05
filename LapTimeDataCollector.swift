//
//  LapTimeDataCollector.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/26/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation


class LapTimeDataCollector : ElapsedTimeDataCollector {
    var mLapBaseTime = 0.0
    var mCurrentLapTime = 0.0
    
    override func lap() throws {
        try super.lap()
        mLapBaseTime = mElapsedTime
    }
    
    override func start() throws {
        try super.start()
        mLapBaseTime = 0.0
        mCurrentLapTime = 0.0
    }
    
    public override func getSayString() -> String {
        return getTimeString(theElapsedTime: mCurrentLapTime, theLongForm: true)
    }
    
    public override func getUIString() -> String {
        return getTimeString(theElapsedTime: mCurrentLapTime, theLongForm: false)
    }

    override func timeUpdate(theElapsedTime : Double) throws {
        try super.timeUpdate(theElapsedTime: theElapsedTime)
        mCurrentLapTime = mElapsedTime - mLapBaseTime
    }
}
