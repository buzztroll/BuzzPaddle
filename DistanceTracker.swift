//
//  DistanceTracker.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/26/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import CoreLocation


class DistanceTracker {
    var mLastLocation : CLLocation?
    var mFirstLocation : CLLocation?
    var mTotalDistance = 0.0
    var mElapsedTime = 0.0
    
    func setValue(theValue : Double) {
        mTotalDistance = theValue
    }
    
    func locationUpdate(theLocation: [CLLocation])  {
        if mLastLocation == nil {
            mLastLocation = theLocation.first
            mFirstLocation = mLastLocation
        }
        if let aStart = mLastLocation {
            let aEnd = theLocation.last!
            let aDist = aEnd.distance(from: aStart)
            mTotalDistance += aDist
            mLastLocation = aEnd
        }
    }
    
    func getTimeSpan() -> Double {
        if let aFirstTime = mFirstLocation, let aLastTime = mLastLocation {
            let aTimeSpan = aLastTime.timestamp.timeIntervalSince(aFirstTime.timestamp)
            return aTimeSpan
        }
        return 0.0
    }
    
    func getDistance() -> Double {
        return mTotalDistance
    }
    
    func reset() {
        mTotalDistance = 0.0
        mElapsedTime = 0.0
        mFirstLocation = nil
        mLastLocation = nil
    }
    
    func lap() {
        // we keep the last location
        mTotalDistance = 0.0
        mElapsedTime = 0.0
        mFirstLocation = mLastLocation
    }
    
    func timeUpdate(theElapsedTime : Double) {
        mElapsedTime = theElapsedTime
    }
}
