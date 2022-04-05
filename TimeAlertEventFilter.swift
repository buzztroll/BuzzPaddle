//
//  TimeAlertEventConsumer.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/24/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import AVFoundation
import CoreLocation


class TimeAlertEventFilter : TimeBaseUpdateFilter {
    var mFormatString : String
    var mTitle : String
    
    init(theInterval: Double, theEventConsumer: EventStringConsumer, theFormat : String, theTitle : String) {
        mFormatString = theFormat
        mTitle = theTitle
        super.init(theInterval: theInterval, theEventConsumer: theEventConsumer)
    }
    
    override
    func getSayString() -> String {
        var aElapsedTime = mElapsedTime
        
        let hours = UInt8(aElapsedTime / 3600.00)
        aElapsedTime -= (TimeInterval(hours) * 3600)
        let minutes = UInt8(aElapsedTime / 60.0)
        aElapsedTime -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(aElapsedTime)
        aElapsedTime -= TimeInterval(seconds)
        
        var aSayTime = mTitle
        
        if hours > 0 {
            let strHours = String(format: mFormatString, hours)
            aSayTime.append(strHours)
            if hours == 1 {
                aSayTime.append(" hour ")
            }
            else {
                aSayTime.append(" hours ")
            }
        }
        if minutes > 0 {
            let strMinutes = String(format: mFormatString, minutes)
            aSayTime.append(strMinutes)
            if minutes == 1 {
                aSayTime.append(" minute ")
            }
            else {
                aSayTime.append(" minutes ")
            }
        }
        let strSeconds = String(format: mFormatString, seconds)
        aSayTime.append(strSeconds)
        aSayTime.append(" seconds")
        
        return aSayTime
    }
}
