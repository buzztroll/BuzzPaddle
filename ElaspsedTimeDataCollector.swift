//
//  ElaspsedTimeDataCollector.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/26/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import CoreLocation


class ElapsedTimeDataCollector : DataCollectorInterface {
    var mElapsedTime : Double = 0.0

    override func start() throws {
       try super.start()
        mElapsedTime = 0.0
    }
    
    override func stop() throws {
        try super.stop()
    }
    
    override func lap() throws {
        try super.lap()
    }
    
    override func timeUpdate(theElapsedTime : Double) throws {
        try super.timeUpdate(theElapsedTime: theElapsedTime)
        mElapsedTime = theElapsedTime
    }
    
    override func locationUpdate(theLocation : [CLLocation]) throws {
        try super.locationUpdate(theLocation: theLocation)
    }
    
    func getTimeString(theElapsedTime : Double, theLongForm : Bool) -> String {
        var aElapsedTime = theElapsedTime
        
        let hours = UInt8(aElapsedTime / 3600.00)
        aElapsedTime -= (TimeInterval(hours) * 3600)
        let minutes = UInt8(aElapsedTime / 60.0)
        aElapsedTime -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(aElapsedTime)
        aElapsedTime -= TimeInterval(seconds)
        let fract = UInt8(aElapsedTime * 10)
        
        if !theLongForm {
            return String(format: "%02d:%02d:%02d.%d", hours, minutes, seconds, fract)
        }
        var aLongForm = "Elapsed time: "
        
        if hours > 0 {
            let strHours = String(format: "%d", hours)
            aLongForm.append(strHours)
            if hours == 1 {
                aLongForm.append(" hour ")
            }
            else {
                aLongForm.append(" hours ")
            }
        }
        if minutes > 0 {
            let strMinutes = String(format: "%d", minutes)
            aLongForm.append(strMinutes)
            if minutes == 1 {
                aLongForm.append(" minute ")
            }
            else {
                aLongForm.append(" minutes ")
            }
        }
        let strSeconds = String(format: "%d", seconds)
        aLongForm.append(strSeconds)
        aLongForm.append(" seconds.")
        
        return aLongForm
    }
    
    public override func getSayString() -> String {
        return getTimeString(theElapsedTime: mElapsedTime, theLongForm: true)
    }
    
    public override func getUIString() -> String {
        return getTimeString(theElapsedTime: mElapsedTime, theLongForm: false)
    }
}

class LifetimeTimeCollector : ElapsedTimeDataCollector {
    let mUserData = BuzzSpeedUserDefaults()
    var mLifetimeBase = 0.0

    override func start() throws {
        mLifetimeBase = mUserData.getLifetimeTime()
        try super.start()
    }
    
    override func timeUpdate(theElapsedTime : Double) throws {
        try super.timeUpdate(theElapsedTime: theElapsedTime)
        mUserData.setLifetimeTime(theTime: mLifetimeBase + theElapsedTime)
    }
    
    public override func getSayString() -> String {
        return getTimeString(theElapsedTime: mLifetimeBase + mElapsedTime, theLongForm: true)
    }
    
    public override func getUIString() -> String {
        return getTimeString(theElapsedTime: mLifetimeBase + mElapsedTime, theLongForm: false)
    }
}
