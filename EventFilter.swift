//
//  EventConsumer.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/24/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import AVFoundation
import CoreLocation

public protocol EventFilter {
    func start()
    func stop()
    func reset()
    func lap()
    func timeUpdate(theElapsedTime : Double)
    func locationUpdate(theLocation : [CLLocation])
    func getSayString() -> String
}
