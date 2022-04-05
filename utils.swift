//
//  utils.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/26/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


enum BuzzSpeedErrors: Error {
    case notImplemented
    case notStarted
    case alreadyStarted
    case mustBeStarted
    case badParameter
    case notReady
    case valueTooSmall(minimumTime: Int, givenValue: Int, name : String)
}

enum Instruments {
    case Distance
    case CurrentSpeed
    case ElapsedTime
    case MaxSpeed
    case AverageSpeed
}

class BuzzPickerDelegate : NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var mChoices : [[String]]
    let mUserDataName : String
    let mUserDefaults = UserDefaults.standard

    init(theUserDataName : String, theChoices : [[String]]) {
        mChoices = theChoices
        mUserDataName = theUserDataName
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return mChoices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mChoices[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let font = UIFont(name: "Helvetica Neue", size: 15.0)!
        let label = UILabel()
        label.text = mChoices[component][row]
        label.font = font
        label.textAlignment = NSTextAlignment.center
        
        return label
    }
    
    func getDisplayValue(thePicker: UIPickerView) -> String {
        return ""
    }
    
    func getStoreDisplayValue() -> String {
        return ""
    }
    
    func saveValueToStore(thePicker: UIPickerView) {
    }
    
    func setValueFromStore(thePicker: UIPickerView) {
        
    }
}

class SinglePickerDelegate : BuzzPickerDelegate {
    init(theUserDataName : String, theValues : [String]) {
        var aChoices = [[String]]()
        aChoices.append(theValues)
        super.init(theUserDataName : theUserDataName, theChoices: aChoices)
    }
    
    override func getDisplayValue(thePicker: UIPickerView) -> String {
        return mChoices[0][thePicker.selectedRow(inComponent: 0)]
    }
    
    override func getStoreDisplayValue() -> String {
        if let x = mUserDefaults.string(forKey: mUserDataName) {
            return x
        }
        else {
            return mChoices[0][0]
        }
    }
    
    override func saveValueToStore(thePicker: UIPickerView) {
        let x = getDisplayValue(thePicker: thePicker)
        mUserDefaults.set(x, forKey: mUserDataName)
    }
    
    override func setValueFromStore (thePicker: UIPickerView) {
        if let aDisplayValue = mUserDefaults.string(forKey: mUserDataName) {
            setValueFromString(thePicker: thePicker, theValue : aDisplayValue)
        }
        else {
            setValueFromString(thePicker: thePicker, theValue : mChoices[0][0])
        }
    }
    
    func setValueFromString(thePicker: UIPickerView, theValue : String) {
        var foundNdx = -1
        var ndx = 0
        for m in mChoices[0] {
            if m == theValue {
                foundNdx = ndx
                break
            }
            ndx += 1
        }
        if foundNdx < 0 {
            BuzzLog(message: "Failed to set mins")
            return
        }
        thePicker.selectRow(ndx, inComponent:0, animated:false)
    }
}

class SingleWithLabelPickerDelegate : SinglePickerDelegate {
    init(theUserDataName : String, theValues : [String], theLabel : String) {
        super.init(theUserDataName : theUserDataName, theValues: theValues)
        var aLabelList = [String]()
        aLabelList.append(theLabel)
        mChoices.append(aLabelList)
    }
}

class VoicePickerDelegate : SinglePickerDelegate {
    init(theUserDataName : String) {
        var aVoices = [String]()
        aVoices.append("Default US")
        for v in AVSpeechSynthesisVoice.speechVoices() {
            aVoices.append(v.name)
        }
        super.init(theUserDataName : theUserDataName, theValues: aVoices)
    }
}

class MinutesSecondsPickerDelegate : BuzzPickerDelegate {
    let mMinsNdx = 0
    let mSecsNdx = 2
    
    init(theUserDataName : String) {
        var aMins = [String]()
        for min in 0...60 {
            aMins.append(String(format: "%d", min))
        }
        var aChoices = [[String]]()
        aChoices.append(aMins)
        aChoices.append(["mins"])
        aChoices.append(["0", "15", "30", "45"])
        aChoices.append(["secs"])

        super.init(theUserDataName : theUserDataName, theChoices: aChoices)
    }
    
    override func getDisplayValue(thePicker: UIPickerView) -> String {
        let aMinsNdx = thePicker.selectedRow(inComponent: mMinsNdx)
        let aSecondsNdx = thePicker.selectedRow(inComponent: mSecsNdx)
        let aMins = Int(mChoices[mMinsNdx][aMinsNdx])!
        let aSecs = Int(mChoices[mSecsNdx][aSecondsNdx])!
        
        return String(format: "%02d:%02d", aMins, aSecs)
    }
    
    override func setValueFromStore(thePicker: UIPickerView) {
        let startValue = mUserDefaults.integer(forKey: mUserDataName)
        setTime(thePicker: thePicker, theSeconds: startValue)
    }
    
    override func getStoreDisplayValue() -> String {
        let x = mUserDefaults.integer(forKey: mUserDataName)
        let aMins = x / 60
        let aSecs = x % 60
        return String(format: "%02d:%02d", aMins, aSecs)
    }
    
    override func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let font = UIFont(name: "Helvetica Neue", size: 15.0)!
        let label = UILabel()
        label.text = mChoices[component][row]
        label.font = font
        if component == 0 || component == 2 {
            label.textAlignment = NSTextAlignment.right
        }
        else {
            label.textAlignment = NSTextAlignment.left
        }
        return label
    }
    
    override func saveValueToStore(thePicker: UIPickerView) {
        let aTotalSecs = getPeriodTimeSeconds(thePicker: thePicker)
        mUserDefaults.set(aTotalSecs, forKey: mUserDataName)
        mUserDefaults.synchronize()
    }
    
    func getPeriodTimeSeconds(thePicker: UIPickerView) -> Int {
        let aMinsNdx = thePicker.selectedRow(inComponent: mMinsNdx)
        let aSecondsNdx = thePicker.selectedRow(inComponent: mSecsNdx)
        let aMins = mChoices[mMinsNdx][aMinsNdx]
        let aSecs = mChoices[mSecsNdx][aSecondsNdx]

        return Int(aMins)! * 60 + Int(aSecs)!
    }
    
    func setTime(thePicker: UIPickerView, theSeconds : Int) {
        var aSecs = theSeconds
        let aMins = aSecs / 60
        aSecs -= (aMins * 60)
        
        var foundMinNdx = -1
        var minNdx = 0
        for m in mChoices[mMinsNdx] {
            let tmpM = Int(m)
            if tmpM == aMins {
                foundMinNdx = minNdx
                break
            }
            minNdx += 1
        }
        if foundMinNdx < 0 {
            print("Failed to set mins")
            return
        }
        var foundSecsNdx = -1
        var secsNdx = 0
        for m in mChoices[mSecsNdx] {
            let tmpS = Int(m)
            if tmpS == aSecs {
                foundSecsNdx = secsNdx
                break
            }
            secsNdx += 1
        }
        if foundSecsNdx < 0 {
            BuzzLog(message: "Failed to set secs")
            return
        }
        thePicker.selectRow(minNdx, inComponent:mMinsNdx, animated:false)
        thePicker.selectRow(secsNdx, inComponent:mSecsNdx, animated:false)
    }
}

class ActivationSpeedPickerDelegate : BuzzPickerDelegate {
    let mUserData = BuzzSpeedUserDefaults()

    init(theUserDataName : String) {
        var aValues = [String]()
        var val = 0.0
        for _ in 0...50  {
            aValues.append(String(format: "%3.1f", val))
            val += 0.5
        }
        
        var aChoices = [[String]]()
        aChoices.append(aValues)
        
        let aRateType = mUserData.getRateType()
        var aList = [String]()
        aList.append(aRateType)
        aChoices.append(aValues)
        
        super.init(theUserDataName : theUserDataName, theChoices: aChoices)
    }
    
    func setDisplayData(thePicker: UIPickerView) {
        let aRateType = mUserData.getRateType()
        var aList = [String]()
        aList.append(aRateType)
        mChoices[1] = aList
        setValueFromStore(thePicker: thePicker)
    }
    
    override func pickerView(_ pickerView: UIPickerView,
                             viewForRow row: Int,
                             forComponent component: Int,
                             reusing view: UIView?) -> UIView {
        setDisplayData(thePicker: pickerView)
        return super.pickerView(pickerView, viewForRow: row, forComponent: component, reusing: view)
    }
    
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        setDisplayData(thePicker: pickerView)
        return super.numberOfComponents(in: pickerView)
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        setDisplayData(thePicker: pickerView)
        return mChoices[component].count
    }
    
    override func getDisplayValue(thePicker: UIPickerView) -> String {
        let aVal = mChoices[0][thePicker.selectedRow(inComponent: 0)]
        let aRateType = mUserData.getRateType()
        return "\(aVal) \(aRateType)"
    }
    
    override func getStoreDisplayValue() -> String {
        let aRateType = mUserData.getRateType()
        let metersPersecond = mUserDefaults.double(forKey: mUserDataName)
        let thisRate = mUserData.convertRawRate(theMetersPerSec: metersPersecond)
        let x = Int(round((thisRate * 10.0) / 5.0) * 5)
        let y = Double(x) / 10.0

        let s = String(format: "%3.1f", y)
        return "\(s) \(aRateType)"
    }
    
    override func saveValueToStore(thePicker: UIPickerView) {
        let aStrVal = mChoices[0][thePicker.selectedRow(inComponent: 0)]
        let aRaw = Double(aStrVal)!
        let aRateType = mUserData.getRateType()
        
        var metersPerSec : Double = 0.0
        if aRateType == "mph" {
            metersPerSec = aRaw * 0.44704
        }
        else if aRateType == "kph" {
            metersPerSec = aRaw * 0.2777778
        }
        else if aRateType == "minute/mile" {
            metersPerSec = aRaw * 26.8224
        }
        else {
            print("unknown rate type, using meters/sec")
            metersPerSec = aRaw * 26.8224
        }
        print(String(format: "writing to store %f", metersPerSec))
        mUserDefaults.set(metersPerSec, forKey: mUserDataName)
        mUserDefaults.synchronize()
    }
    
    override func setValueFromStore(thePicker: UIPickerView) {
        let s = getStoreDisplayValue()
        var foundNdx = -1
        var ndx = 0
        for m in mChoices[0] {
            if m == s {
                foundNdx = ndx
                break
            }
            ndx += 1
        }
        if foundNdx < 0 {
            BuzzLog(message: "Failed to set value \(s)")
            return
        }
        thePicker.selectRow(ndx, inComponent:0, animated:false)
    }
}

func BuzzLog(message: String) {
    #if DEBUG
        print(message)
    #endif
}
