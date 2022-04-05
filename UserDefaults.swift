//
//  UserDefaults.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/30/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation
import AVFoundation

class BuzzSpeedUserDefaults {
    let userDefaults = UserDefaults.standard

    init() {
        let alreadyConfigured = userDefaults.bool(forKey: "appConfigured")
        if !alreadyConfigured {
            // set defaults
            userDefaults.set(true, forKey: "appConfigured")
            userDefaults.set(true, forKey: "switchLapBestSpeed")
            userDefaults.set(true, forKey: "switchLastLapSpeed")
            userDefaults.set(true, forKey: "switchBestSpeed")
            userDefaults.set(true, forKey: "switchAverageSpeed")
            userDefaults.set(true, forKey: "switchTotalDistance")
            userDefaults.set(true, forKey: "switchTotalTime")
            
            self.setRateType(theValue: "mph")
            self.setDistanceType(theValue: "miles")
            self.setRunType(theValue: "Interval")
            setIntervalCount(theValue: 5)
            userDefaults.synchronize()
        }
    }
    
    func save() {
        userDefaults.synchronize()
    }
    
    func getSwitchLapBestSpeed() -> Bool {
        return userDefaults.bool(forKey: "switchLapBestSpeed")
    }
    func setSwitchLapBestSpeed(theValue : Bool) {
        userDefaults.set(theValue, forKey: "switchLapBestSpeed")
    }
    
    func getSwitchLastLapSpeed() -> Bool {
        return userDefaults.bool(forKey: "switchLastLapSpeed")
    }
    func setSwitchLastLapSpeed(theValue : Bool) {
        userDefaults.set(theValue, forKey: "switchLastLapSpeed")
    }
    
    func getSwitchBestSpeed() -> Bool {
        return userDefaults.bool(forKey: "switchBestSpeed")
    }
    func setSwitchBestSpeed(theValue : Bool) {
        userDefaults.set(theValue, forKey: "switchBestSpeed")
    }
    
    func getSwitchAverageSpeed() -> Bool {
        return userDefaults.bool(forKey: "switchAverageSpeed")
    }
    func setSwitchAverageSpeed(theValue : Bool) {
        userDefaults.set(theValue, forKey: "switchAverageSpeed")
    }
    
    func getSwitchTotalDistanced() -> Bool {
        return userDefaults.bool(forKey: "switchTotalDistance")
    }
    func setSwitchTotalDistance(theValue : Bool) {
        userDefaults.set(theValue, forKey: "switchTotalDistance")
    }
    
    func getSwitchTotalTime() -> Bool {
        return userDefaults.bool(forKey: "switchTotalTime")
    }
    func setSwitchTotalTime(theValue : Bool) {
        userDefaults.set(theValue, forKey: "switchTotalTime")
    }
    
    func getRunType() -> String {
        return userDefaults.string(forKey: "pickWorkoutType")!
    }
    func setRunType(theValue : String) {
        userDefaults.set(theValue, forKey: "pickWorkoutType")
    }
    
    func getIntervalCount() -> Int {
        var x = userDefaults.integer(forKey: "intervalCount")
        if x == 0 {
            x = 5
        }
        return x
    }
    func setIntervalCount(theValue : Int) {
        userDefaults.set(theValue, forKey: "intervalCount")
    }
    
    func getWarnInterval() -> Bool {
        return userDefaults.bool(forKey: "warnInterval")
    }
    func setWarnInterval(theValue : Bool) {
        userDefaults.set(theValue, forKey: "warnInterval")
    }
    
    func getWarmupInterval() -> Bool {
        return userDefaults.bool(forKey: "warmupInterval")
    }
    func setWarmupInterval(theValue : Bool) {
        userDefaults.set(theValue, forKey: "warmupInterval")
    }
    
    func getWarmupTime() -> Int {
        if !getWarmupInterval() {
            return 0
        }
        return userDefaults.integer(forKey: "warmupTime")
    }
    
    func getCooldownTime() -> Int {
        if !getCooldownInterval() {
            return 0
        }
        return userDefaults.integer(forKey: "cooldownTime")
    }
    
    func getHardTime() -> Int {
        return userDefaults.integer(forKey: "hardTime")
    }
    
    func getRestTime() -> Int {
        return userDefaults.integer(forKey: "restTime")
    }
    
    func getCooldownInterval() -> Bool {
        return userDefaults.bool(forKey: "cooldownInterval")
    }
    func setCooldownInterval(theValue : Bool) {
        userDefaults.set(theValue, forKey: "cooldownInterval")
    }
    
    func getDistanceType() -> String {
        return userDefaults.string(forKey: "pickDistanceType")!
    }
    func setDistanceType(theValue : String) {
        userDefaults.set(theValue, forKey: "pickDistanceType")
    }
    
    func getRateType() -> String {
        return userDefaults.string(forKey: "pickRateType")!
    }
    func setRateType(theValue : String) {
        userDefaults.set(theValue, forKey: "pickRateType")
    }
    
    func getSwitchStartDelay() -> Bool {
        return userDefaults.bool(forKey: "switchStartDelay")
    }
    func setSwitchStartDelay(theValue : Bool) {
        userDefaults.set(theValue, forKey: "switchStartDelay")
    }
    
    func getSwitchRateActivate() -> Bool {
        return userDefaults.bool(forKey: "switchRateActivate")
    }
    func setSwitchRateActivate(theValue : Bool) {
        userDefaults.set(theValue, forKey: "switchRateActivate")
    }
    
    func getVoiceName() -> String {
        if let a = userDefaults.string(forKey: "voiceRateType") {
            return a
        }
        else {
            return "Default US"
        }
    }
    
    func convertRawDistance(theMeters : Double) -> Double {
        let aDistType = getDistanceType()
        if aDistType == "miles" {
            return theMeters * 0.0006213712
        }
        else if aDistType == "kilometers" {
            return theMeters / 1000.0
        }
        else {
            print("unknown distance typet, using meters")
            return theMeters
        }
    }
    
    func convertRawRate(theMetersPerSec : Double) -> Double {
        let aRateType = getRateType()
        if aRateType == "mph" {
            return theMetersPerSec * 2.236936
        }
        else if aRateType == "kph" {
            return theMetersPerSec * 3.6
        }
        else if aRateType == "minute/mile" {
            return 60.0 / (theMetersPerSec * 2.236936)
        }
        else {
            print("unknown rate type, using meters/sec")
            return theMetersPerSec
        }
    }
    
    func getRateSayString() -> String {
        let aRateType = getRateType()

        if aRateType == "mph" {
            return "miles per hour"
        }
        else if aRateType == "kph" {
            return "kiilometers per hour"
        }
        else if aRateType == "minute/mile" {
            return "minute miles"
        }
        else {
            print("unknown rate type, using meters/sec")
            return "meters per second"
        }
    }
    
    func getDistanceSayString() -> String {
        let aDistType = getDistanceType()
        if aDistType == "miles" {
            return "miles"
        }
        else if aDistType == "kilometers" {
            return "kilometers"
        }
        else {
            print("unknown distance type, using meters")
            return "Meters"
        }
    }
    
    func getLapTimeInSeconds() -> Int {
        return userDefaults.integer(forKey: "lapTime")
    }
    
    func getStartDelayInSeconds() -> Int {
        return userDefaults.integer(forKey: "startDelay")
    }
    
    func getActivationMetersPerSecond() -> Double {
        return userDefaults.double(forKey: "activationSpeed")
    }
    
    func getLifetimeDistance() -> Double {
        return userDefaults.double(forKey: "lifetimeDistance")
    }
    
    func setLifetimeDistance(theDistance : Double)  {
        userDefaults.set(theDistance, forKey: "lifetimeDistance")
    }
    
    func getLifetimeTime() -> Double {
        return userDefaults.double(forKey: "lifetimeTime")
    }
    
    func setLifetimeTime(theTime : Double)  {
        userDefaults.set(theTime, forKey: "lifetimeTime")
    }
}
