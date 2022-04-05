//
//  DistanceBasedUpdateFilter.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/25/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import CoreLocation

class DistanceBasedUpdateFilter : EventFilter {
    var mTracker = TrackMiles()
    var mDistanceThreshold : Double
    
    init(theThreshold : Double) {
        mDistanceThreshold = theThreshold
    }
    
    func timeUpdate(theElapsedTime : Double) {
        // Ignore
    }
    
    func locationUpdate(theLocation : [CLLocation]) {
        mTracker.locationUpdate(theLocation: theLocation)
    }
    
    func getSayString() -> String {
        return ""
    }
    
    func reset() {
        mTracker.reset()
    }
}
