//
//  DataCollectorInterface.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/26/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import AVFoundation
import CoreLocation


public class DataCollectorInterface : EventConsumer {
    var mRunning : Bool
    var mOutputConsumers = [OutputConsumer]()
    
    public override init() {
        mRunning = false
        super.init()
    }
    
    func registerOutputConsumer(theOutputConsumer : OutputConsumer) {
        mOutputConsumers.append(theOutputConsumer)
    }
    
    public override func start() throws {
        if mRunning {
            throw BuzzSpeedErrors.alreadyStarted
        }
        mRunning = true
    }
    
    public override func stop() throws {
        if !mRunning {
            throw BuzzSpeedErrors.notStarted
        }
        mRunning = false
    }
    
    func lap() throws {
        if !mRunning {
            throw BuzzSpeedErrors.notStarted
        }
    }
    
    public override func timeUpdate(theElapsedTime : Double) throws {
        if !mRunning {
            throw BuzzSpeedErrors.notStarted
        }
    }
    
    public override func locationUpdate(theLocation : [CLLocation]) throws {
        if !mRunning {
            throw BuzzSpeedErrors.notStarted
        }
    }
    
    public func getSayString() -> String {
        return ""
    }
    
    public func getUIString() -> String {
        return ""
    }
    
    public func updateUI() {
        let aSay = getUIString()
        for o in mOutputConsumers {
            o.incomingString(theOutput: aSay)
        }
    }
    
    static public func ==(lhs: DataCollectorInterface, rhs: DataCollectorInterface) -> Bool {
        return lhs.mUuid == rhs.mUuid
    }
}
