//
//  EventConsumer.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/26/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import CoreLocation


public class EventConsumer : Equatable {
    let mUuid = NSUUID()

    public static func ==(lhs: EventConsumer, rhs: EventConsumer) -> Bool {
        return lhs.mUuid == rhs.mUuid
    }
    
    func start() throws {
        throw BuzzSpeedErrors.notImplemented
    }
    
    func stop() throws {
        throw BuzzSpeedErrors.notImplemented
    }
    
    func timeUpdate(theElapsedTime : Double) throws {
        throw BuzzSpeedErrors.notImplemented
    }
    
    func locationUpdate(theLocation : [CLLocation]) throws {
        throw BuzzSpeedErrors.notImplemented
    }
    
}
