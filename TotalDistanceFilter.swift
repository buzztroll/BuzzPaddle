//
//  TotalDistanceFilter.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/25/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import AVFoundation
import CoreLocation

class TotalDistanceFilter : EventFilter {
    var mPrefix : String
    var mSuffix : String
    var mLastLocation : CLLocation?
    var mTotalDistance : CLLocationDistance = 0.0
    let mEventStringConsumer : EventStringConsumer

    init(theEventConsumer: EventStringConsumer, prefix : String, suffix : String) {
        mPrefix = prefix
        mSuffix = suffix
        mEventStringConsumer = theEventConsumer
    }
    
    func start() {
        mTotalDistance = 0.0
    }
    
    func stop() {
    }

    func timeUpdate(theElapsedTime: Double) {
    }
    
    func locationUpdate(theLocation: [CLLocation]) {
        if mLastLocation == nil {
            mLastLocation = theLocation.first
        }
        if let aStart = mLastLocation {
            let aEnd = theLocation.last!
            let aDist = aEnd.distance(from: aStart)
            mTotalDistance += aDist
            let aTotalMiles = mTotalDistance * 0.0006213712

            mEventStringConsumer.incomingString(theValue: String(format: "\(mPrefix) %5.1f \(mSuffix)", mPrefix, aTotalMiles))
        }
    }
}
