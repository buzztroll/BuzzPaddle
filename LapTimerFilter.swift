//
//  LapTimerFilter.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/25/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import AVFoundation
import CoreLocation


class LapTimer : TimeBaseUpdateFilter {
    let mEventsOnLap : [EventFilter]
    let mSustainedEvents : [EventFilter]
    var mLapCounter : Int
    
    init(theInterval: Double, theEventConsumer: EventStringConsumer, theEventsOnLap : [EventFilter], theSustainedEvents : [EventFilter]) {
        mEventsOnLap = theEventsOnLap
        mSustainedEvents = theSustainedEvents
        mLapCounter = 0
        super.init(theInterval: theInterval, theEventConsumer: theEventConsumer)
    }
    
    override func start() {
        super.start()
        for aEvent in mEventsOnLap {
            aEvent.start()
        }
        for aEvent in mSustainedEvents {
            aEvent.start()
        }
    }
    
    override func stop() {
        super.start()
        for aEvent in mEventsOnLap {
            aEvent.start()
        }
        for aEvent in mSustainedEvents {
            aEvent.stop()
        }
    }
    
    override func timeUpdate(theElapsedTime : Double) {
        for aEvent in mEventsOnLap {
            aEvent.timeUpdate(theElapsedTime: theElapsedTime)
        }
        for aEvent in mSustainedEvents {
            aEvent.timeUpdate(theElapsedTime: theElapsedTime)
        }
        super.timeUpdate(theElapsedTime: theElapsedTime)
    }
    
    override func locationUpdate(theLocation : [CLLocation]) {
        for aEvent in mEventsOnLap {
            aEvent.locationUpdate(theLocation: theLocation)
        }
        for aEvent in mSustainedEvents {
            aEvent.locationUpdate(theLocation: theLocation)
        }
        super.locationUpdate(theLocation: theLocation)
    }
    
    override func tic() {
        mLapCounter += 1
        // Walk through all the events on this lap and restart them
        mEventStringConsumer.incomingString(theValue: getSayString())
        for aEvent in mEventsOnLap {
            aEvent.stop()
            let aSayString = aEvent.getSayString()
            mEventStringConsumer.incomingString(theValue: aSayString)
            aEvent.start()
        }
        for aEvent in mSustainedEvents {
            let aSayString = aEvent.getSayString()
            mEventStringConsumer.incomingString(theValue: aSayString)
        }
    }
    
    override func getSayString() -> String {
        return String(format: "%d", mLapCounter)
    }
}
