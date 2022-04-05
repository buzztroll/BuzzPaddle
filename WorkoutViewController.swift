//
//  LapViewController.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/28/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import UIKit

class WorkoutViewController: BaseViewControll {
    
    let mUserData = BuzzSpeedUserDefaults()
    var mPeriodPickData : MinutesSecondsPickerDelegate?
    var mPeriodPickPopover : TimePopUpViewController?

    var mWarmupPickData : MinutesSecondsPickerDelegate?
    var mWarmupPickPopover : TimePopUpViewController?

    var mCooldownPickData : MinutesSecondsPickerDelegate?
    var mCooldownPickPopover : TimePopUpViewController?

    var mHardPickData : MinutesSecondsPickerDelegate?
    var mHardPickPopover : TimePopUpViewController?

    var mRestPickData : MinutesSecondsPickerDelegate?
    var mRestPickPopover : TimePopUpViewController?
    
    var mWorkoutTypePopover : TimePopUpViewController?
    var mWorkoutPickerDel : SinglePickerDelegate?

    @IBOutlet weak var switchWarmup: UISwitch!
    @IBOutlet weak var switchCooldown: UISwitch!
    @IBOutlet weak var switchWarnInterval: UISwitch!
    
    @IBOutlet weak var btnWarmup: UIButton!
    @IBOutlet weak var btnCooldown: UIButton!
    @IBOutlet weak var btnHard: UIButton!
    @IBOutlet weak var btnRest: UIButton!
    @IBOutlet weak var btnLapTime: UIButton!
    @IBOutlet weak var btnWorkoutType: UIButton!
    @IBOutlet weak var btnStartStop: UIButton!
    
    @IBOutlet weak var stepperIntervalCount: UIStepper!
    @IBOutlet weak var lblTotalLaps: UILabel!
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        mUserData.setWarnInterval(theValue: switchWarnInterval.isOn)
        mUserData.setCooldownInterval(theValue: switchCooldown.isOn)
        mUserData.setWarmupInterval(theValue: switchWarmup.isOn)
        mUserData.save()
    }
    
    @IBAction func stepValueChanged(_ sender: UIStepper) {
        lblTotalLaps.text = Int(sender.value).description
        mUserData.setIntervalCount(theValue: Int(sender.value))
        mUserData.save()
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnWarmup {
            mWarmupPickPopover!.show(vc: self)
        }
        else if sender == btnCooldown {
            mCooldownPickPopover!.show(vc: self)
        }
        else if sender == btnHard {
            mHardPickPopover!.show(vc: self)
        }
        else if sender == btnRest {
            mRestPickPopover!.show(vc: self)
        }
        else if sender == btnLapTime {
            mPeriodPickPopover!.show(vc: self)
        }
        else if sender == btnWorkoutType {
            mWorkoutTypePopover!.show(vc: self)
        }
    }
   
    
    @IBAction func btnStartStop(_ sender: UIButton) {
        if let mainView = self.tabBarController as? MainViewController {
            
            if btnStartStop.titleLabel?.text == "Start" {
                do {
                    try mainView.startIt()
                    btnStartStop.setTitle("Stop", for: .normal)
                }
                catch BuzzSpeedErrors.valueTooSmall(let minimumTime, _, let errorName) {
                    showError(msg : "\(errorName) must be \(minimumTime) or larger")
                }
                catch {
                    showError(msg : "\(error)")
                }
            }
            else {
                btnStartStop.setTitle("Start", for: .normal)
                mainView.stopIt()
            }
        }
    }
    
    func intervalFinished() {
        if let mainView = self.tabBarController as? MainViewController {
            mainView.stopIt()
            btnStartStop.setTitle("Start", for: .normal)
        }
    }
    
    func showError(msg : String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        super.loadView()
        
 switchWarmup.setOn(mUserData.getWarmupInterval(), animated: false)
    switchCooldown.setOn(mUserData.getCooldownInterval(), animated: false)
        switchWarnInterval.setOn(mUserData.getWarnInterval(), animated: false)

        let storyboard = self.storyboard!

        let aPeriodPickData = MinutesSecondsPickerDelegate(theUserDataName: "lapTime")
        mPeriodPickData = aPeriodPickData
        mPeriodPickPopover = storyboard.instantiateViewController(withIdentifier: "TimePopUpViewController") as? TimePopUpViewController
        let aPeriodType = WorkoutType(theUIButton: btnLapTime, thePickerDel: aPeriodPickData, theTitle: "Lap Time")
        mPeriodPickPopover!.setUp(theConsumer: aPeriodType)
        aPeriodType.loadValue()
        
        let aWarmupPickData = MinutesSecondsPickerDelegate(theUserDataName: "warmupTime")
        mWarmupPickData = aWarmupPickData
        mWarmupPickPopover = storyboard.instantiateViewController(withIdentifier: "TimePopUpViewController") as? TimePopUpViewController
        let aWarmupType = WorkoutType(theUIButton: btnWarmup, thePickerDel: aWarmupPickData, theTitle: "Warmup Time")
        mWarmupPickPopover!.setUp(theConsumer: aWarmupType)
        aWarmupType.loadValue()
        
        let aCooldownPickData = MinutesSecondsPickerDelegate(theUserDataName: "cooldownTime")
        mCooldownPickData = aCooldownPickData
        mCooldownPickPopover = storyboard.instantiateViewController(withIdentifier: "TimePopUpViewController") as? TimePopUpViewController
        let aCooldownType = WorkoutType(theUIButton: btnCooldown, thePickerDel: aCooldownPickData, theTitle: "Cooldown Time")
        mCooldownPickPopover!.setUp(theConsumer: aCooldownType)
        aCooldownType.loadValue()
        
        let aHardPickData = MinutesSecondsPickerDelegate(theUserDataName: "hardTime")
        mHardPickData = aHardPickData
        mHardPickPopover = storyboard.instantiateViewController(withIdentifier: "TimePopUpViewController") as? TimePopUpViewController
        let aHardType = WorkoutType(theUIButton: btnHard, thePickerDel: aHardPickData, theTitle: "Hard Time")
        mHardPickPopover!.setUp(theConsumer: aHardType)
        aHardType.loadValue()
        
        let aRestPickData = MinutesSecondsPickerDelegate(theUserDataName: "restTime")
        mRestPickData = aRestPickData
        mRestPickPopover = storyboard.instantiateViewController(withIdentifier: "TimePopUpViewController") as? TimePopUpViewController
        let aRestType = WorkoutType(theUIButton: btnRest, thePickerDel: aRestPickData, theTitle: "Rest Time")
        mRestPickPopover!.setUp(theConsumer: aRestType)
        aRestType.loadValue()
        
        lblTotalLaps.text = mUserData.getIntervalCount().description
        stepperIntervalCount.value = Double(mUserData.getIntervalCount())
        
        let aWorkoutPickerDel = SinglePickerDelegate(theUserDataName: "pickWorkoutType", theValues: ["Lap", "Interval"])
        mWorkoutPickerDel = aWorkoutPickerDel
        mWorkoutTypePopover = storyboard.instantiateViewController(withIdentifier: "TimePopUpViewController") as? TimePopUpViewController
        let aWorkoutType = WorkoutType(theUIButton: btnWorkoutType, thePickerDel: aWorkoutPickerDel, theTitle: "Workout Type")
        mWorkoutTypePopover!.setUp(theConsumer: aWorkoutType)
        aWorkoutType.loadValue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func adaptivePresentationStyle(for: UIPresentationController)  -> UIModalPresentationStyle {
        return .none
    }
}

