//
//  PeriodicFeedback.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/27/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import CoreLocation
import AVFoundation


public protocol TimerDelegate {
    func tic()
}

class PeriodicFeedback : EventConsumer {
    
    var mDelegate : TimerDelegate?
    
    func setDelegate(theDelegate : TimerDelegate) {
        mDelegate = theDelegate
    }
    
    override func start() throws {
    }
    
    override func stop() throws {
    }
    
    override func timeUpdate(theElapsedTime: Double) throws {
    }
    
    override func locationUpdate(theLocation: [CLLocation]) throws {
    }
    
    func tic() {
        if let aDel = mDelegate {
            aDel.tic()
        }
    }
}

class TimePeriodicFeedback : PeriodicFeedback {
    let mInterval : Double
    var mNext : Double
    
    init(theInterval : Double) {
        mInterval = theInterval
        mNext = theInterval
        super.init()
    }
    
    override func start() throws {
        mNext = mInterval
    }
    
    override func timeUpdate(theElapsedTime: Double) throws {
        if theElapsedTime > mNext {
            mNext += mInterval
            tic()
        }
    }
}

class UIUpdater : TimePeriodicFeedback {
    let mDataCollectors : [DataCollectorInterface]
    var mTimer : TimePeriodicFeedback?
    
    init(theDataColllectors : [DataCollectorInterface]) {
        mDataCollectors = theDataColllectors
        super.init(theInterval: 0.1)
    }
    
    override func tic() {
        for d in mDataCollectors {
            d.updateUI()
        }
    }
}

class VoiceFeedback : EventConsumer, TimerDelegate {
    let mMinPeriod = 30
    let mDataToSpeak : [DataCollectorInterface]
    let mDataToLap : [DataCollectorInterface]
    var mTimer : PeriodicFeedback?
    let mInterval : Double
    let mSpeechManager = SpeechManager()
    
    init(theSpeakers: [DataCollectorInterface], theLappers: [DataCollectorInterface], theInterval : Int) throws {
        
        if theInterval < mMinPeriod {
            throw BuzzSpeedErrors.valueTooSmall(minimumTime: mMinPeriod, givenValue: theInterval, name: "Interval period")
        }
        mDataToSpeak = theSpeakers
        mDataToLap = theLappers
        mInterval = Double(theInterval)
        super.init()
    }
    
    override func start() throws {
        mTimer = TimePeriodicFeedback(theInterval: mInterval)
        mTimer!.setDelegate(theDelegate: self)
        try mTimer!.start()
        mSpeechManager.start()
        mSpeechManager.saySomething(theSay: "Starting.")
        mSpeechManager.stop()
    }
    
    override func stop() throws {
        if let aTimer = mTimer {
            try aTimer.stop()
            mTimer = nil
        }
        else {
            throw BuzzSpeedErrors.notStarted
        }
        mSpeechManager.start()
        mSpeechManager.saySomething(theSay: "Stopping.")
        mSpeechManager.stop()
    }
    
    override func timeUpdate(theElapsedTime: Double) throws {
        if let aTimer = mTimer {
            try aTimer.timeUpdate(theElapsedTime: theElapsedTime)
        }
        else {
            throw BuzzSpeedErrors.notStarted
        }
    }
    
    override func locationUpdate(theLocation: [CLLocation]) throws {
        if let aTimer = mTimer {
            try aTimer.locationUpdate(theLocation: theLocation)
        }
        else {
            throw BuzzSpeedErrors.notStarted
        }
    }
    
    func tic() {
        for d in mDataToLap {
            do {
                try d.lap()
            }
            catch {
                BuzzLog(message: "SOME ERROR")
                BuzzLog(message: "Error info: \(error)")
            }
        }
        mSpeechManager.start()
        var speakData = ""
        for d in mDataToSpeak {
            let aSay = d.getSayString()
            speakData = speakData + "  " + aSay
        }
        mSpeechManager.saySomething(theSay: speakData)
        mSpeechManager.stop()
    }
}

enum IntervalStates {
    case NONE
    case WARMUP
    case HARD
    case REST
    case COOLDOWN
    case DONE
}

class IntervalTime : EventConsumer {
    let mMinTime = 15
    
    let mSpeechManager = SpeechManager()
    let mHardInterval : Double
    let mEasyInterval : Double
    let mWarningLeadTime : Double
    let mTotalLaps : Int
    let mWarmupTime : Double
    let mCoolDownTime : Double
    let mSpeakObjects : [DataCollectorInterface]
    let mLapCounter : LapCountDataCollector

    var mNextWarningTime : Double
    var mState : IntervalStates
    var mLapCount : Int
    var mNextEventTime : Double
    var mCurrentElapsedTime : Double
    var mDoneMonitor : WorkoutViewController?
    

    init(hardLength : Int, restLength : Int, warningLeadTime : Int, warmUpTime : Int, coolDownTime : Int, totalLaps : Int, theSpeakList : [DataCollectorInterface], theWorkoutView : WorkoutViewController, theLapCounter : LapCountDataCollector) throws {
        
        if hardLength < mMinTime {
            throw BuzzSpeedErrors.valueTooSmall(minimumTime: mMinTime, givenValue: hardLength, name: "Hard Interval Length")
        }
        if restLength < mMinTime {
            throw BuzzSpeedErrors.valueTooSmall(minimumTime: mMinTime, givenValue: restLength, name: "Rest Interval Length")
        }
        if warmUpTime < mMinTime && warmUpTime > 0 {
            throw BuzzSpeedErrors.valueTooSmall(minimumTime: mMinTime, givenValue: warmUpTime, name: "Warm up time")
        }
        if coolDownTime < mMinTime && coolDownTime > 0 {
            throw BuzzSpeedErrors.valueTooSmall(minimumTime: mMinTime, givenValue: coolDownTime, name: "Cool down time")
        }
        if totalLaps < 0 {
            throw BuzzSpeedErrors.valueTooSmall(minimumTime: 1, givenValue: totalLaps, name: "Total Laps")
        }
        
        mDoneMonitor = theWorkoutView
        mHardInterval = Double(hardLength)
        mEasyInterval = Double(restLength)
        mWarningLeadTime = Double(warningLeadTime)
        mTotalLaps = totalLaps
        mWarmupTime = Double(warmUpTime)
        mCoolDownTime = Double(coolDownTime)
        mSpeakObjects = theSpeakList
        
        mNextWarningTime = 0.0
        mState = IntervalStates.NONE
        mLapCount = 0
        mNextEventTime = 0.0
        mCurrentElapsedTime = 0.0
        mLapCounter = theLapCounter
    }
    
    func speak(aSay : String) {
        mSpeechManager.start()
        mSpeechManager.saySomething(theSay: aSay)
        mSpeechManager.stop()
    }
    
    override func start() throws {
        mNextWarningTime = 0.0
        mState = IntervalStates.NONE
        mLapCount = 0
        mNextEventTime = 0.0
        mCurrentElapsedTime = 0.0
    }
    
    func setWarnTime() {
        if mWarningLeadTime <= 0 {
            // If not using a warn time skip
            return
        }
        let aWarnTime = mNextEventTime - mWarningLeadTime
        if aWarnTime <= mCurrentElapsedTime {
            // if warn time already would have happened skip
            return
        }
        mNextWarningTime = aWarnTime
    }
    
    func setWarmUp() {
        mState = IntervalStates.WARMUP
        mNextEventTime = mWarmupTime + mCurrentElapsedTime
        setWarnTime()
        speak(aSay: "Starting warmup")
    }
    
    func setHard() {
        mState = IntervalStates.HARD
        mNextEventTime = mHardInterval + mCurrentElapsedTime
        setWarnTime()
        do {
            try mLapCounter.lap()
        }
        catch {
            BuzzLog(message: "The lap counter isn't working")
        }
        mLapCount += 1
        for o in mSpeakObjects {
            do {
                try o.lap()
            }
            catch {
                BuzzLog(message: "Error info: \(error)")
            }
        }
        speak(aSay: "Starting hard")
    }
    
    func setEasy() {
        mState = IntervalStates.REST
        mNextEventTime = mEasyInterval + mCurrentElapsedTime
        setWarnTime()
        var speakWords = String(format: "Starting rest.  Lap %d results.  ", mLapCount)
        for o in mSpeakObjects {
            do {
                try o.lap()
            }
            catch {
                BuzzLog(message: "Error info: \(error)")
            }
            speakWords = speakWords + " " + o.getSayString()
        }
        speak(aSay: speakWords)
    }
    
    func setCoolDown() {
        mState = IntervalStates.COOLDOWN
        mNextEventTime = mCoolDownTime + mCurrentElapsedTime
        setWarnTime()
        speak(aSay: "Starting cooldown")
    }
    
    func setDone() {
        mState = IntervalStates.DONE
        mNextEventTime = -1.0
        mNextWarningTime = -1.0
        speak(aSay: "Workout finished!")
        mDoneMonitor?.intervalFinished()
    }
    
    func eventChange() {
        switch mState {
        case IntervalStates.NONE:
            if mWarmupTime > 0 {
                setWarmUp()
            }
            else {
                setHard()
            }
        case IntervalStates.WARMUP:
            setHard()
        case IntervalStates.HARD:
            setEasy()
        case IntervalStates.REST:
            if mLapCount < mTotalLaps {
                setHard()
            }
            else {
                if mCoolDownTime > 0 {
                    setCoolDown()
                }
                else {
                    setDone()
                }
            }
        case IntervalStates.COOLDOWN:
            setDone()
        case IntervalStates.DONE:
            BuzzLog(message: "Already done")            
        }
    }
    
    func doWarning() {
        mNextWarningTime = 0
        let aSay = String(format: "%d more seconds", Int(mWarningLeadTime))
        speak(aSay: aSay)
    }
    
    override func stop() throws {
    }
    
    override func timeUpdate(theElapsedTime: Double) throws {
        if mState == IntervalStates.DONE {
            BuzzLog(message: "Already done")
        }
        if mState == IntervalStates.NONE {
            BuzzLog(message: "Not started")
        }
        mCurrentElapsedTime = theElapsedTime
        if mCurrentElapsedTime > mNextWarningTime && mNextWarningTime > 0 {
            doWarning()
        }
        if mCurrentElapsedTime > mNextEventTime {
            eventChange()
        }
    }
    
    override func locationUpdate(theLocation: [CLLocation]) throws {
    }
}

class ActivationFeedback : EventConsumer {
    var mSpeedActivated = false
    let mTimeAlertMarker = 60.0
    var mMarkNextAlert = 0.0
    let mDelayTime : Double
    let mActivationSpeed : Double
    var mElapsedTime = 0.0
    var mActivated = false
    var mRealFeedback : EventConsumer
    let mEventProducer : EventProducer
    let mDataToSpeak : [DataCollectorInterface]
    let mDataToLap : [DataCollectorInterface]
    let mSpeechManager = SpeechManager()

    
    init(theEventProducer : EventProducer, theRealFeedback : EventConsumer, theDelayTime : Int, theMetersPerSec : Double, theSpeakers: [DataCollectorInterface], theLappers: [DataCollectorInterface]) throws {
        
        mDataToLap = theLappers
        mDataToSpeak = theSpeakers
        mDelayTime = Double(theDelayTime)
        mActivationSpeed = theMetersPerSec
        mEventProducer = theEventProducer
        mRealFeedback = theRealFeedback
        
        mSpeedActivated = (mActivationSpeed <= 0.0)
    }
    
    override func start() throws {
        if !mActivated {
            mElapsedTime = 0.0
            mMarkNextAlert = mTimeAlertMarker
            mSpeechManager.start()
            if mDelayTime > 0.0 {
                sayWorkoutStart()
            }
        }
    }
    
    func sayWorkoutStart() {
        let aStartingIn = Int(mDelayTime - mElapsedTime)
        let mins = aStartingIn / 60
        let secs = aStartingIn - (mins * 60)
        var aSay = "Workout will start in "
        if mins > 0 {
            var aMinStr = "minutes"
            if mins == 1 {
                aMinStr = "minute"
            }
            aSay = String(format: "\(aSay) %d \(aMinStr)", mins)
        }
        if secs > 1 {
            aSay = String(format: "\(aSay) %d seconds.", secs)
        }
        if mElapsedTime + 1.0 >= mDelayTime {
            aSay = "Waiting for activation speed to be achieved."
        }
        mSpeechManager.start()
        mSpeechManager.saySomething(theSay: aSay)
        mSpeechManager.stop()
    }
    
    override func stop() throws {
        if mActivated {
            //try mRealFeedback.stop()
            mEventProducer.removeForEvents(theEventConsumer: mRealFeedback)
            mActivated = false
        }
    }
    
    func activate() throws {
        // reset everything that we have
        mSpeechManager.start()
        mSpeechManager.saySomething(theSay: "Your workout will begin now.")
        mSpeechManager.stop()
    
        try mEventProducer.stop()
        mEventProducer.registerForEvents(theEventConsumer: mRealFeedback)
        mActivated = true
        try mEventProducer.start()
    }
    
    func testActivate() throws {
        if mActivated {
            return
        }
        if mElapsedTime > mDelayTime && mSpeedActivated {
            try activate()
        }
    }
    
    override func timeUpdate(theElapsedTime: Double) throws {
        mElapsedTime = theElapsedTime
        try testActivate()
        if mActivated {
            try mRealFeedback.timeUpdate(theElapsedTime: theElapsedTime)
        }
        else {
            if mElapsedTime > mMarkNextAlert {
                mMarkNextAlert = mElapsedTime + mTimeAlertMarker
                sayWorkoutStart()
            }
        }
    }
    
    override func locationUpdate(theLocation: [CLLocation]) throws {
        if !mSpeedActivated {
            for l in theLocation {
                if l.speed > mActivationSpeed && mElapsedTime > mDelayTime {
                    mSpeechManager.start()
                    mSpeechManager.saySomething(theSay: "Activation speed achieved")
                    mSpeechManager.stop()
                    mSpeedActivated = true
                }
            }
        }
        try testActivate()

        if mActivated {
           try mRealFeedback.locationUpdate(theLocation: theLocation)
        }
    }
}
