//
//  TimeManager.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/25/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//
import Foundation
import CoreLocation
import AVFoundation


public class EventProducer : NSObject, CLLocationManagerDelegate {
    var mTimer : Timer?
    var mRunning = false
    var mStartTime = 0.0
    var mElapsedTime = 0.0
    var locationManager:CLLocationManager = CLLocationManager()
    var mEventConsumerList = [EventConsumer]()
    
    override init() {
        super.init()

        self.locationManager.delegate = self
        self.locationManager.distanceFilter = 15
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.allowsBackgroundLocationUpdates = true
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for aDc in mEventConsumerList {
            do {
                try aDc.locationUpdate(theLocation: locations)
            } catch {
                BuzzLog(message: "An error occurred updating location");
            }
        }
    }
    
    public func registerForEvents(theEventConsumer : EventConsumer) {
        mEventConsumerList.append(theEventConsumer)
    }

    public func removeForEvents(theEventConsumer : EventConsumer) {
        var ndx = -1
        for i in 0...mEventConsumerList.count {
            if mEventConsumerList[i] == theEventConsumer {
                ndx = i
                break
            }
        }
        if ndx < 0 {
            BuzzLog(message: "Bad eventConsumer.  Not in list")
            return
        }
        mEventConsumerList.remove(at: ndx)
    }

    func start() throws {
        if mRunning {
            throw BuzzSpeedErrors.alreadyStarted
        }
        mRunning = true
        mStartTime  = NSDate.timeIntervalSinceReferenceDate
        for aDc in mEventConsumerList {
            try aDc.start()
        }
       
        mTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(updateTime),
                                     userInfo: nil,
                                     repeats: true)
        locationManager.startUpdatingLocation()
    }
    
    func stop() throws {
        if !mRunning {
            throw BuzzSpeedErrors.notStarted
        }
        mRunning = false
        mTimer?.invalidate()
        locationManager.stopUpdatingLocation()
        for aDc in mEventConsumerList {
            try aDc.stop()
        }
    }
    
    @objc func updateTime() {
        mElapsedTime = NSDate.timeIntervalSinceReferenceDate - mStartTime
        for aDc in mEventConsumerList {
            do {
                try aDc.timeUpdate(theElapsedTime: mElapsedTime)
            } catch {
                BuzzLog(message: "Error info: \(error)")
                BuzzLog(message: "An error occurred updating time");
            }
        }
    }
}
