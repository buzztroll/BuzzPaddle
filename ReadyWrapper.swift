//
//  ReadyWrapper.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/25/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import CoreLocation


public class TimeBasedReady {
    var mInterval : Double
    var mNextUpdate : Double
    
    init(theInterval : Double) {
        mInterval = theInterval
        mNextUpdate = theInterval
    }
    
    func reset() {
        mNextUpdate = mInterval
    }
    
    func checkUpdate(theElapsedTime : Double) -> Bool {
        if theElapsedTime > mNextUpdate {
            mNextUpdate += mInterval
            return true
        }
        return false
    }
}
