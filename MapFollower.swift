//
//  MapFollower.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 10/4/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class MapFollower : EventConsumer {
    let mMapStatusMap: MKMapView
    
    init(theMapStatusMap: MKMapView) {
        mMapStatusMap = theMapStatusMap
    }
    
    func start() throws {
       
    }
    func stop() throws {
        
    }
    
    func timeUpdate(theElapsedTime : Double) throws {
    
    }
    
    func locationUpdate(theLocation : [CLLocation]) throws {
        let region = MKCoordinateRegionMakeWithDistance(
            theLocation.last!.coordinate, 1000, 1000)
        
        mMapStatusMap.setRegion(region, animated: false)
    }
}
