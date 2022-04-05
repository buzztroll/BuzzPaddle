//
//  OverviewViewController.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/28/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import UIKit
import MapKit

class OverviewViewController: UIViewController, UIPopoverPresentationControllerDelegate  {
    
    let mUserData = BuzzSpeedUserDefaults()
    var mMain : MainViewController?
    
    @IBOutlet weak var lblLifetimeTime: UILabel!
    @IBOutlet weak var lblLifetimeDistance: UILabel!
    @IBOutlet weak var lblTotalTimeDisplay: UILabel!
    @IBOutlet weak var lblTotalDistanceDisplay: UILabel!
    @IBOutlet weak var lblAverageSpeedDisaply: UILabel!
    @IBOutlet weak var lblCurrentSpeedDisplay: UILabel!
    @IBOutlet weak var lblBestSpeedDisplay: UILabel!
    @IBOutlet weak var lblCurrentLapTime: UILabel!
    @IBOutlet weak var lblLastLapDistanceDisplay: UILabel!
    @IBOutlet weak var lblLastLapSpeedDisplay: UILabel!
    @IBOutlet weak var lblLapCountDisplay: UILabel!
    @IBOutlet weak var lblBestLapSpeedDisplay: UILabel!

    @IBOutlet weak var lblVersion: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverSegue" {
            let popoverViewController = segue.destination
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        lblVersion.text = version
        
        lblLifetimeTime.text = getTimeString(theTime: mUserData.getLifetimeTime())
        lblLifetimeDistance.text = String(format: "%5.1f", mUserData.convertRawDistance(theMeters:mUserData.getLifetimeDistance()))
    }

    func getTimeString(theTime : Double) -> String {
        var aElapsedTime = theTime
        
        let hours = UInt8(aElapsedTime / 3600.00)
        aElapsedTime -= (TimeInterval(hours) * 3600)
        let minutes = UInt8(aElapsedTime / 60.0)
        aElapsedTime -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(aElapsedTime)
        aElapsedTime -= TimeInterval(seconds)
        let fract = UInt8(aElapsedTime * 10)
        
        return String(format: "%03d:%02d:%02d.%d", hours, minutes, seconds, fract)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
