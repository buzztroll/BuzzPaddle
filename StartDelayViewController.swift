//
//  IntervalViewController.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/29/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import UIKit

class StartDelayViewController: BaseViewControll {

    let mUserData = BuzzSpeedUserDefaults()
    
    var mActivationSpeedPickData : ActivationSpeedPickerDelegate?
    var mActivationSpeedPickPopover : TimePopUpViewController?
    
    var mStartDelayPickData : MinutesSecondsPickerDelegate?
    var mStartDelayPickPopover : TimePopUpViewController?
    var mActivationSpeedType : WorkoutType?

 
    @IBOutlet weak var switchStartDelay: UISwitch!
    @IBOutlet weak var switchActivationSpeed: UISwitch!
    @IBOutlet weak var btnStartButton: UIButton!
    @IBOutlet weak var btnActivationSpeed: UIButton!
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        mUserData.setSwitchStartDelay(theValue: switchStartDelay.isOn)
        mUserData.setSwitchRateActivate(theValue: switchActivationSpeed.isOn)
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        if sender == btnStartButton {
            mStartDelayPickPopover!.show(vc: self)
        }
        else if sender == btnActivationSpeed {
            mActivationSpeedPickPopover!.show(vc: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnActivationSpeed!.setTitle(mActivationSpeedPickData!.getStoreDisplayValue(), for: [])
        mActivationSpeedType!.loadValue()
    }
    
    override func loadView() {
        super.loadView()
        
        switchStartDelay.setOn(mUserData.getSwitchStartDelay(), animated: false)
        switchActivationSpeed.setOn(mUserData.getSwitchRateActivate(), animated: false)
        
        let storyboard = self.storyboard!
        
        let aStartDelayPickData = MinutesSecondsPickerDelegate(theUserDataName: "startDelay")
        mStartDelayPickData = aStartDelayPickData
        mStartDelayPickPopover = storyboard.instantiateViewController(withIdentifier: "TimePopUpViewController") as? TimePopUpViewController
        let aStartDelayType = WorkoutType(theUIButton: btnStartButton, thePickerDel: aStartDelayPickData, theTitle: "Start Time Delay")
        mStartDelayPickPopover!.setUp(theConsumer: aStartDelayType)
        aStartDelayType.loadValue()
    
        let aActivationSpeedPickData = ActivationSpeedPickerDelegate(theUserDataName: "activationSpeed")
        mActivationSpeedPickData = aActivationSpeedPickData
        mActivationSpeedPickPopover = storyboard.instantiateViewController(withIdentifier: "TimePopUpViewController") as? TimePopUpViewController
        let aActivationSpeedType = WorkoutType(theUIButton: btnActivationSpeed, thePickerDel: aActivationSpeedPickData, theTitle: "Activation Speed")
        mActivationSpeedPickPopover!.setUp(theConsumer: aActivationSpeedType)
        aActivationSpeedType.loadValue()
        mActivationSpeedType = aActivationSpeedType
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adaptivePresentationStyle(for: UIPresentationController)  -> UIModalPresentationStyle {
        return .none
    }
}
