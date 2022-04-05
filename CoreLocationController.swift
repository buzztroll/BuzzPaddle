//
//  CoreLocationController.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/23/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import CoreLocation

class CoreLocationController : NSObject, CLLocationManagerDelegate {
    var locationManager:CLLocationManager = CLLocationManager()
    var sampleInterval = 3
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = 1
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last as! CLLocation
        let strLoc = "didUpdateLocations:  \(location.coordinate.latitude), \(location.coordinate.longitude)"
        print(location.timestamp)
        print(location.speed)
        print(strLoc)
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            break
            
        case .authorized:
            self.locationManager.startUpdatingLocation()
            break
            
        case .denied:
            break
            
        default:
            break
            
        }
    }
}

