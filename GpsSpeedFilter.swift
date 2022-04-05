//
//  GpsSpeedFilter.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/25/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import AVFoundation
import CoreLocation


class GpsSpeedFilter : EventFilter
{
    let mEventStringConsumer : EventStringConsumer
    
    init(theEventConsumer: EventStringConsumer) {
        mEventStringConsumer = theEventConsumer
    }
    
    func start() {
    }
    
    func timeUpdate(theElapsedTime : Double) {
    }
    
    func locationUpdate(theLocation : [CLLocation]) {
        let metersPerSecond = theLocation.last!.speed
        let mph = metersPerSecond * 2.236936
        let mphStr = String(format: "%5.2f mph", mph)
        mEventStringConsumer.incomingString(theValue: mphStr)
    }
    
    func stop() {
    }
}
