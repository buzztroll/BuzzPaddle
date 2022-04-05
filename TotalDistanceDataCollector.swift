//
//  TotalDistanceDataCollector.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/26/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import CoreLocation

class TotalDistanceDataCollector : DataCollectorInterface {
    let mUserData = BuzzSpeedUserDefaults()
    var mDistanceTracker = DistanceTracker()
    
    override func locationUpdate(theLocation: [CLLocation]) throws {
        try super.locationUpdate(theLocation: theLocation)
        mDistanceTracker.locationUpdate(theLocation: theLocation)
    }
    
    override func start() throws {
        try super.start()
        mDistanceTracker.reset()
    }
    
    func getDistance() -> Double {
        return mUserData.convertRawDistance(theMeters: mDistanceTracker.getDistance())
    }
    
    public override func getSayString() -> String {
        let aLabel = mUserData.getDistanceSayString()
        return String(format: "Total distance: %5.1f \(aLabel).", getDistance())
    }
    
    public override func getUIString() -> String {
        return String(format: "%5.1f", getDistance())
    }
}

class AverageSpeedDataCollector : DataCollectorInterface {
    var mDistanceTracker = DistanceTracker()
    let mUserData = BuzzSpeedUserDefaults()
    
    override func locationUpdate(theLocation: [CLLocation]) throws {
        try super.locationUpdate(theLocation: theLocation)
        mDistanceTracker.locationUpdate(theLocation: theLocation)
    }
    
    override func timeUpdate(theElapsedTime: Double) throws {
        mDistanceTracker.timeUpdate(theElapsedTime: theElapsedTime)
    }
    
    override func start() throws {
        try super.start()
        mDistanceTracker.reset()
    }
    
    func getRate() -> Double {
        let aMeters = mDistanceTracker.getDistance()
        let aSecs = mDistanceTracker.getTimeSpan()
        if aSecs <= 0.0 {
            return 0.0
        }
        let aRate = aMeters / aSecs
        return mUserData.convertRawRate(theMetersPerSec: aRate)
    }
    
    public override func getSayString() -> String {
        let aLabel = mUserData.getRateSayString()
        return String(format: "Overall Average speed: %5.1f \(aLabel).", getRate())
    }
    
    public override func getUIString() -> String {
        return String(format: "%5.1f", getRate())
    }
}

class LastLapSpeedDataCollector : DataCollectorInterface {
    let mUserData = BuzzSpeedUserDefaults()
    var mDistanceTracker = DistanceTracker()
    var mLastSpeed = 0.0
    
    override func locationUpdate(theLocation: [CLLocation]) throws {
        try super.locationUpdate(theLocation: theLocation)
        mDistanceTracker.locationUpdate(theLocation: theLocation)
    }
    
    override func start() throws {
        try super.start()
        mDistanceTracker.reset()
    }
    
    override func lap() throws {
        try super.lap()
        mLastSpeed = getRate()
        mDistanceTracker.reset()
    }
    
    func getRate() -> Double {
        let aMeters = mDistanceTracker.getDistance()
        let aSecs = mDistanceTracker.getTimeSpan()
        if aSecs <= 0.0 {
            return 0.0
        }
        return aMeters / aSecs
    }
    
    public override func getSayString() -> String {
        let aLabel = mUserData.getRateSayString()
        let aRate = mUserData.convertRawRate(theMetersPerSec: mLastSpeed)
        return String(format: "Last lap speed: %5.1f \(aLabel).", aRate)
    }
    
    public override func getUIString() -> String {
        let aRate = mUserData.convertRawRate(theMetersPerSec: mLastSpeed)
        return String(format: "%5.1f", aRate)
    }
}


class LifetimeTotalDistanceDataCollector : DataCollectorInterface {
    let mUserData = BuzzSpeedUserDefaults()
    var mDistanceTracker = DistanceTracker()
    
    override func locationUpdate(theLocation: [CLLocation]) throws {
        try super.locationUpdate(theLocation: theLocation)
        mDistanceTracker.locationUpdate(theLocation: theLocation)
        mUserData.setLifetimeDistance(theDistance: mDistanceTracker.getDistance())
    }
    
    override func start() throws {
        let aLifetime = mUserData.getLifetimeDistance()
        mDistanceTracker.setValue(theValue : aLifetime)
        try super.start()
    }
    
    func getDistance() -> Double {
        return mUserData.convertRawDistance(theMeters: mDistanceTracker.getDistance())
    }
    
    public override func getSayString() -> String {
        let aLabel = mUserData.getDistanceSayString()
        return String(format: "Lifetime Total distance: %5.1f \(aLabel).", getDistance())
    }
    
    public override func getUIString() -> String {
        return String(format: "%5.1f", getDistance())
    }
}
