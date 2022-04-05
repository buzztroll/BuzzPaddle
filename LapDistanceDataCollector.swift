//
//  LapDistanceDataCollector.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/26/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation


class LapDistanceDataCollector : TotalDistanceDataCollector {

    override func lap() throws {
        try super.lap()
        mDistanceTracker.lap()
    }
    
    public override func getSayString() -> String {
        let aDistance = mUserData.convertRawRate(theMetersPerSec: getDistance())
        let aLabel = mUserData.getDistanceSayString()
        return String(format: "Last lap: %5.1f \(aLabel).", aDistance)
    }
}

class LapCountDataCollector : DataCollectorInterface {
    var mLapCount = 0
    
    override func start() throws {
        try super.start()
        mLapCount = 0
    }
    
    override func lap() throws {
        try super.lap()
        mLapCount += 1
    }
    
    public override func getSayString() -> String {
        return String(format: "Lap number %d.", mLapCount)
    }
    
    public override func getUIString() -> String {
        return String(format: "%5d", mLapCount)
    }
}
