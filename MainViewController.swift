//
//  MainViewController.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/28/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    var mMeat : Meat?
    let mUserData = BuzzSpeedUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vcList = self.viewControllers {
            for vc in vcList {
                vc.loadView()
            }
        }
    }
    
    func startIt() throws {
        var aOver : OverviewViewController?
        var aLap : WorkoutViewController?
        var aInterval : StartDelayViewController?
        var aSpeak : SpeakViewController?

        if let vcList = self.viewControllers {
            for vc in vcList {
                if vc is OverviewViewController {
                    aOver = (vc as! OverviewViewController)
                }
                else if vc is WorkoutViewController {
                    aLap = (vc as! WorkoutViewController)
                }
                else if vc is StartDelayViewController {
                    aInterval = (vc as! StartDelayViewController)
                }
                else if vc is SpeakViewController {
                    aSpeak = (vc as! SpeakViewController)
                }
            }
            if let over = aOver, let lap = aLap, let interval = aInterval, let speak = aSpeak {
                let theMeat = try Meat(theOverviewView: over, theWorkoutView: lap, theStartDeplayView: interval, theSpeakView: speak)
                theMeat.start()
                mMeat = theMeat
            }
            else {
                throw BuzzSpeedErrors.notReady
            }
        }
        else {
            throw BuzzSpeedErrors.notReady
        }
    }
    
    func stopIt() {
        if let aMeat = mMeat {
            aMeat.stop()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
