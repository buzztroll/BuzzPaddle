//
//  SpeedNowCollector.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/26/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import CoreLocation


class SpeedNowCollector : DataCollectorInterface {
    var mLastSpeed : Double = 0.0
    let mUserData = BuzzSpeedUserDefaults()
    
    override func locationUpdate(theLocation : [CLLocation]) throws {
        try super.locationUpdate(theLocation: theLocation)
        if let aLast = theLocation.last {
            mLastSpeed = aLast.speed
        }
    }
    
    override func start() throws {
        try super.start()
        mLastSpeed = 0.0
    }
    
    func getRate() -> Double {
        return mLastSpeed
    }
    
    public override func getSayString() -> String {
        let aRate = mUserData.convertRawRate(theMetersPerSec: getRate())
        let aLabel = mUserData.getRateSayString()
        return String(format: "Current speed %5.1f \(aLabel).", aRate)
    }
    
    public override func getUIString() -> String {
        let aRate = mUserData.convertRawRate(theMetersPerSec: getRate())
        return String(format: "%5.1f", aRate)
    }
}

class BestSpeedCollector : DataCollectorInterface {
    var mBestSpeed : Double = 0.0
    let mUserData = BuzzSpeedUserDefaults()

    override func locationUpdate(theLocation : [CLLocation]) throws {
        try super.locationUpdate(theLocation: theLocation)
        for l in theLocation {
            if l.speed > mBestSpeed {
                mBestSpeed = l.speed
            }
        }
    }
    
    override func start() throws {
        try super.start()
        mBestSpeed = 0.0
    }
    
    func getRate() -> Double {
        return mBestSpeed
    }
    
    public override func getSayString() -> String {
        let aRate = mUserData.convertRawRate(theMetersPerSec: getRate())
        let aLabel = mUserData.getRateSayString()
        return String(format: "Best speed %5.1f \(aLabel).", aRate)
    }
    
    public override func getUIString() -> String {
        let aRate = mUserData.convertRawRate(theMetersPerSec: getRate())
        return String(format: "%5.1f", aRate)
    }
}

class BestLapSpeedCollector : BestSpeedCollector {
    var mLastLapBestSpeed = 0.0
    
    override func lap() throws {
        mLastLapBestSpeed = mBestSpeed
        mBestSpeed = 0.0
    }
    
    public override func getSayString() -> String {
        let aRate = mUserData.convertRawRate(theMetersPerSec: getRate())
        let aLabel = mUserData.getRateSayString()
        return String(format: "Best lap speed %5.1f \(aLabel).", aRate)
    }
    
    public override func getUIString() -> String {
        let aRate = mUserData.convertRawRate(theMetersPerSec: getRate())
        return String(format: "%5.1f", aRate)
    }
}

