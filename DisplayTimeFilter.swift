//
//  DisplayTimeFilter.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/25/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//
import Foundation
import AVFoundation
import CoreLocation


class DisplayTimeFilter : TimeBaseUpdateFilter
{
    override
    func getSayString() -> String {
        var aElapsedTime = mElapsedTime
        
        let hours = UInt8(aElapsedTime / 3600.00)
        aElapsedTime -= (TimeInterval(hours) * 3600)
        let minutes = UInt8(aElapsedTime / 60.0)
        aElapsedTime -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(aElapsedTime)
        aElapsedTime -= TimeInterval(seconds)
        let fract = UInt8(aElapsedTime * 10)
        
        let hoursStr = String(format: "%02d", hours)
        let minsStr = String(format: "%02d", minutes)
        let secsStr = String(format: "%02d", seconds)
        let fractStr = String(format: "%01d", fract)
        
        return "\(hoursStr):\(minsStr):\(secsStr).\(fractStr)"
    }
}
