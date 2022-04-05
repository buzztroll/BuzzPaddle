//
//  SpeakViewController.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/29/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import UIKit

class SpeakViewController: BaseViewControll {
    
    @IBOutlet weak var btnDistance: UIButton!
    @IBOutlet weak var btnRate: UIButton!

    var mRatePickerDel : SinglePickerDelegate?
    var mDistancePickerDel : SinglePickerDelegate?
    var mWorkoutPickerDel : SinglePickerDelegate?
    var mDistancePopover : TimePopUpViewController?
    var mRatePopover : TimePopUpViewController?
    var mVoicePickerDel : VoicePickerDelegate?
    var mVoicePopover : TimePopUpViewController?

    @IBOutlet weak var btnVoice: UIButton!
    
    let mUserData = BuzzSpeedUserDefaults()
   
    @IBAction func switchValueChanged(_ sender: Any) {
        saveState()
    }
    
    @IBAction func btnTestClick(_ sender: Any) {
        let aButton : UIButton = sender as! UIButton
        
        if aButton == btnDistance {
            mDistancePopover!.show(vc: self)
        }
        else if aButton == btnRate {
            mRatePopover!.show(vc: self)
        }
        else if aButton == btnVoice {
            mVoicePopover!.show(vc: self)
        }
    }
    
    func adaptivePresentationStyle(for: UIPresentationController)  -> UIModalPresentationStyle {
        return .none
    }

    @IBOutlet weak var switchLapBestSpeed: UISwitch!
    @IBOutlet weak var switchLastLapSpeed: UISwitch!
    @IBOutlet weak var switchBestSpeed: UISwitch!
    @IBOutlet weak var switchAverageSpeed: UISwitch!
    @IBOutlet weak var switchTotalDistance: UISwitch!
    @IBOutlet weak var switchTotalTime: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func loadView() {
        super.loadView()

        // Do any additional setup after loading the view.
        
        switchLapBestSpeed.setOn(mUserData.getSwitchLapBestSpeed(), animated: false)
        switchLastLapSpeed.setOn(mUserData.getSwitchLastLapSpeed(), animated: false)
        switchBestSpeed.setOn(mUserData.getSwitchBestSpeed(), animated: false)
        switchAverageSpeed.setOn(mUserData.getSwitchAverageSpeed(), animated: false)
        switchTotalDistance.setOn(mUserData.getSwitchTotalDistanced(), animated: false)
        switchTotalTime.setOn(mUserData.getSwitchTotalTime(), animated: false)
        
        let storyboard = self.storyboard!
        
        let aDistanceUnitPickerDel = SinglePickerDelegate(theUserDataName: "pickDistanceType", theValues: ["miles", "kilometers"])
        mDistancePickerDel = aDistanceUnitPickerDel
        mDistancePopover = storyboard.instantiateViewController(withIdentifier: "TimePopUpViewController") as? TimePopUpViewController
        let aDistanceType = WorkoutType(theUIButton: btnDistance, thePickerDel: aDistanceUnitPickerDel, theTitle: "Distance Type")
        mDistancePopover!.setUp(theConsumer: aDistanceType)
        aDistanceType.loadValue()
        
        let aRatePickerDel = SinglePickerDelegate(theUserDataName: "pickRateType", theValues: ["mph", "minute/mile", "kph"])
        mRatePickerDel = aRatePickerDel
        mRatePopover = storyboard.instantiateViewController(withIdentifier: "TimePopUpViewController") as? TimePopUpViewController
        let aRateType = WorkoutType(theUIButton: btnRate, thePickerDel: aRatePickerDel, theTitle : "Rate Type")
        mRatePopover!.setUp(theConsumer: aRateType)
        aRateType.loadValue()
        
        let aVoicePickerDel = VoicePickerDelegate(theUserDataName: "voiceRateType")
        mVoicePickerDel = aVoicePickerDel
        mVoicePopover = storyboard.instantiateViewController(withIdentifier: "TimePopUpViewController") as? TimePopUpViewController
        let aVoiceType = WorkoutType(theUIButton: btnVoice, thePickerDel: aVoicePickerDel, theTitle : "Voice")
        mVoicePopover!.setUp(theConsumer: aVoiceType)
        aVoiceType.loadValue()
    }
    
    func saveState() {
        mUserData.setSwitchLapBestSpeed(theValue: switchLapBestSpeed.isOn)
        mUserData.setSwitchLastLapSpeed(theValue: switchLastLapSpeed.isOn)
        mUserData.setSwitchBestSpeed(theValue: switchBestSpeed.isOn)
        mUserData.setSwitchAverageSpeed(theValue: switchAverageSpeed.isOn)
        mUserData.setSwitchTotalDistance(theValue: switchTotalDistance.isOn)
        mUserData.setSwitchTotalTime(theValue: switchTotalTime.isOn)
        
        mUserData.save()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


class WorkoutType : PopupPickerConsumer {
    let mUIButton : UIButton
    let mPickerDel : BuzzPickerDelegate
    let mTitle : String
    
    init(theUIButton : UIButton, thePickerDel : BuzzPickerDelegate, theTitle : String) {
        mUIButton = theUIButton
        mPickerDel = thePickerDel
        mTitle = theTitle
    }
    
    func saveValue(thePicker: UIPickerView) {
        mPickerDel.saveValueToStore(thePicker : thePicker)
        let showValue = mPickerDel.getDisplayValue(thePicker: thePicker)
        mUIButton.setTitle(showValue, for: [])
    }
    
    func loadValue() {
        mUIButton.setTitle(mPickerDel.getStoreDisplayValue(), for: [])
    }
    
    func getPickerDelegate() -> BuzzPickerDelegate {
        return mPickerDel
    }
    func getUIControl() -> UIControl {
        return mUIButton
    }
    func getTitle() -> String {
        return mTitle
    }
}

class BaseViewControll : UIViewController, UIPopoverPresentationControllerDelegate {
}
