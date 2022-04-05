//
//  Meat.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/26/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


// This basically goes from view world to real world
// for now we will have hard defaults and inflate everything,
// but in the future all the gui information will come in the right
// stuff will be established here
class Meat {
    let mEventManager : EventProducer = EventProducer()
    let mOverviewView : OverviewViewController
    let mWorkoutView : WorkoutViewController
    let mStartDelayView : StartDelayViewController
    let mSpeak : SpeakViewController
    //let mMapFollow : MapFollower
    
    let mUITime : ElapsedTimeDataCollector
    let mUISpeed : SpeedNowCollector
    let mUIDistance : TotalDistanceDataCollector
    let mAverageSpeed : AverageSpeedDataCollector
    let mBestSpeed : BestSpeedCollector
    
    let mLapTime : LapTimeDataCollector
    let mLapDistance : LapDistanceDataCollector
    let mLastLapBest : BestLapSpeedCollector
    let mLastLapSpeed : LastLapSpeedDataCollector
    let mLapCount : LapCountDataCollector
    
    let mLifetimeDistance : LifetimeTotalDistanceDataCollector
    let mLifetimeTime : LifetimeTimeCollector
    
    let mUserDefaults = BuzzSpeedUserDefaults()
   
    init(theOverviewView : OverviewViewController, theWorkoutView : WorkoutViewController, theStartDeplayView : StartDelayViewController, theSpeakView : SpeakViewController) throws {
        
        mOverviewView = theOverviewView
        mWorkoutView = theWorkoutView
        mStartDelayView = theStartDeplayView
        mSpeak = theSpeakView
        
        mUITime = ElapsedTimeDataCollector()
        mUITime.registerOutputConsumer(theOutputConsumer: UIOutputConsumer(theUILabel: mOverviewView.lblTotalTimeDisplay))
        mEventManager.registerForEvents(theEventConsumer: mUITime)
        
        mUISpeed = SpeedNowCollector()
        mUISpeed.registerOutputConsumer(theOutputConsumer: UIOutputConsumer(theUILabel: mOverviewView.lblCurrentSpeedDisplay))
        mEventManager.registerForEvents(theEventConsumer: mUISpeed)
        
        mUIDistance = TotalDistanceDataCollector()
        mUIDistance.registerOutputConsumer(theOutputConsumer: UIOutputConsumer(theUILabel: mOverviewView.lblTotalDistanceDisplay))
        mEventManager.registerForEvents(theEventConsumer: mUIDistance)
        
        mAverageSpeed = AverageSpeedDataCollector()
        mAverageSpeed.registerOutputConsumer(theOutputConsumer: UIOutputConsumer(theUILabel: mOverviewView.lblAverageSpeedDisaply))
        mEventManager.registerForEvents(theEventConsumer: mAverageSpeed)

        mBestSpeed = BestSpeedCollector()
        mBestSpeed.registerOutputConsumer(theOutputConsumer: UIOutputConsumer(theUILabel: mOverviewView.lblBestSpeedDisplay))
        mEventManager.registerForEvents(theEventConsumer: mBestSpeed)
        
        // create lap components
        mLapTime = LapTimeDataCollector()
        mLapTime.registerOutputConsumer(theOutputConsumer: UIOutputConsumer(theUILabel: mOverviewView.lblCurrentLapTime))
        mEventManager.registerForEvents(theEventConsumer: mLapTime)

        mLapDistance = LapDistanceDataCollector()
        mLapDistance.registerOutputConsumer(theOutputConsumer: UIOutputConsumer(theUILabel: mOverviewView.lblLastLapDistanceDisplay))
        mEventManager.registerForEvents(theEventConsumer: mLapDistance)

        mLastLapBest = BestLapSpeedCollector()
        mLastLapBest.registerOutputConsumer(theOutputConsumer: UIOutputConsumer(theUILabel: mOverviewView.lblBestLapSpeedDisplay))
        mEventManager.registerForEvents(theEventConsumer: mLastLapBest)

        mLastLapSpeed = LastLapSpeedDataCollector()
        mLastLapSpeed.registerOutputConsumer(theOutputConsumer: UIOutputConsumer(theUILabel: mOverviewView.lblLastLapSpeedDisplay))
        mEventManager.registerForEvents(theEventConsumer: mLastLapSpeed)

        mLapCount = LapCountDataCollector()
        mLapCount.registerOutputConsumer(theOutputConsumer: UIOutputConsumer(theUILabel: mOverviewView.lblLapCountDisplay))
        mEventManager.registerForEvents(theEventConsumer: mLapCount)
        
        mLifetimeDistance = LifetimeTotalDistanceDataCollector()
        mLifetimeDistance.registerOutputConsumer(theOutputConsumer: UIOutputConsumer(theUILabel: mOverviewView.lblLifetimeDistance))
        mEventManager.registerForEvents(theEventConsumer: mLifetimeDistance)

        mLifetimeTime = LifetimeTimeCollector()
        mLifetimeTime.registerOutputConsumer(theOutputConsumer: UIOutputConsumer(theUILabel: mOverviewView.lblLifetimeTime))
        mEventManager.registerForEvents(theEventConsumer: mLifetimeTime)
        
        setupDisplayThread()
        let aSpeakList = buildSpeakList()
        
        var aActivationMetersPerSec = mUserDefaults.getActivationMetersPerSecond()
        if !mUserDefaults.getSwitchRateActivate() {
            aActivationMetersPerSec = 0.0
        }
        var aStartDelay = mUserDefaults.getStartDelayInSeconds()
        if !mUserDefaults.getSwitchStartDelay() {
            aStartDelay = 0
        }
        
        let aRunType = mUserDefaults.getRunType()
        if aRunType == "Lap" {
            let aLapList = setupLapList()
            let intervalSecs = mUserDefaults.getLapTimeInSeconds()

            let aVoiceFeedback = try VoiceFeedback(theSpeakers: aSpeakList, theLappers : aLapList, theInterval: intervalSecs)
            if aStartDelay > 0 || aActivationMetersPerSec > 0.0 {
                let aVoiceLoopDelay = try ActivationFeedback(theEventProducer: mEventManager, theRealFeedback : aVoiceFeedback, theDelayTime: aStartDelay, theMetersPerSec: aActivationMetersPerSec, theSpeakers: aSpeakList, theLappers: aLapList)
                mEventManager.registerForEvents(theEventConsumer: aVoiceLoopDelay)
            }
            else {
                mEventManager.registerForEvents(theEventConsumer: aVoiceFeedback)
            }
        }
        else {
            let warmupTime = mUserDefaults.getWarmupTime()
            let cooldownTime = mUserDefaults.getCooldownTime()
            let hardTime =  mUserDefaults.getHardTime()
            let restTime =  mUserDefaults.getRestTime()
            let lapCount = mUserDefaults.getIntervalCount()

            var warnLeadTime = 10
            if !mUserDefaults.getWarnInterval() {
                warnLeadTime = 0
            }
            let intervalTime = try IntervalTime(hardLength : hardTime, restLength : restTime, warningLeadTime : warnLeadTime, warmUpTime : warmupTime, coolDownTime : cooldownTime, totalLaps : lapCount, theSpeakList: aSpeakList, theWorkoutView : theWorkoutView, theLapCounter : mLapCount)
            let aLapList = [DataCollectorInterface]()
            if aStartDelay > 0 || aActivationMetersPerSec > 0.0 {
                let aVoiceLoopDelay = try ActivationFeedback(theEventProducer: mEventManager, theRealFeedback : intervalTime, theDelayTime: aStartDelay, theMetersPerSec: aActivationMetersPerSec, theSpeakers: aSpeakList, theLappers: aLapList)
                
                mEventManager.registerForEvents(theEventConsumer: aVoiceLoopDelay)
            }
            else {
                mEventManager.registerForEvents(theEventConsumer: intervalTime)
            }
        }
    }
    
    func done() {
        self.stop()
        mWorkoutView.btnStartStop.setTitle("Start", for: .normal)
    }
    
    func setupDisplayThread() {
        var aUIDisplayThread = [DataCollectorInterface]()
        aUIDisplayThread.append(mUITime)
        aUIDisplayThread.append(mUISpeed)
        aUIDisplayThread.append(mUIDistance)
        aUIDisplayThread.append(mAverageSpeed)
        aUIDisplayThread.append(mBestSpeed)
        aUIDisplayThread.append(mLapTime)
        aUIDisplayThread.append(mLapDistance)
        aUIDisplayThread.append(mLastLapBest)
        aUIDisplayThread.append(mLastLapSpeed)
        aUIDisplayThread.append(mLapCount)
        aUIDisplayThread.append(mLifetimeDistance)
        aUIDisplayThread.append(mLifetimeTime)

        let aUIThread = UIUpdater(theDataColllectors: aUIDisplayThread)
        mEventManager.registerForEvents(theEventConsumer: aUIThread)
    }
    
    func setupLapList() -> [DataCollectorInterface] {
        var aLapList = [DataCollectorInterface]()
        aLapList.append(mLastLapBest)
        aLapList.append(mLastLapSpeed)
        aLapList.append(mLapCount)
        aLapList.append(mLapDistance)
        aLapList.append(mLapTime)

        return aLapList
    }
    
    func buildSpeakList() -> [DataCollectorInterface] {
        var aSpeakList = [DataCollectorInterface]()
        if mUserDefaults.getSwitchAverageSpeed() {
            aSpeakList.append(mAverageSpeed)
        }
        if mUserDefaults.getSwitchTotalDistanced() {
            aSpeakList.append(mUIDistance)
        }
        if mUserDefaults.getSwitchTotalTime() {
            aSpeakList.append(mUITime)
        }
        if mUserDefaults.getSwitchLapBestSpeed() {
            aSpeakList.append(mLastLapBest)
        }
        if mUserDefaults.getSwitchLastLapSpeed() {
            aSpeakList.append(mLastLapSpeed)
        }
        if mUserDefaults.getSwitchBestSpeed() {
            aSpeakList.append(mBestSpeed)
        }
        
        return aSpeakList
    }
    
    func start() {
        do {
            try mEventManager.start()
        }
        catch {
            BuzzLog(message: "Failed to start")
        }
    }
    
    func stop() {
        do {
            try mEventManager.stop()
        }
        catch {
            BuzzLog(message: "Failed to start")
        }
    }
}

class UIOutputConsumer : OutputConsumer {
    let mUILabel : UILabel
    
    init(theUILabel : UILabel) {
        mUILabel = theUILabel
    }
    
    func incomingString(theOutput: String) {
        mUILabel.text = theOutput
    }
    
    func longForm() -> Bool {
        return false
    }
}
