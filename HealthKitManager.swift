//
//  HealthKitManager.swift
//  Junction
//
//  Created by Isaac Robinson on 8/12/16.
//  Copyright © 2016 Isaac Robinson. All rights reserved.
//
import Foundation
import HealthKit

class HealthKitManager: NSObject {
    static var timer: NSTimer?
    
    static func startMockHeartData() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
                                                       target: self,
                                                       selector: #selector(HealthKitManager.saveMockHeartData),
                                                       userInfo: nil,
                                                       repeats: true)
    }
    
    static func stopMockHeartData() {
        self.timer?.invalidate()
    }
    
    static func saveMockHeartData() {
        
        // 1. Create a heart rate Sample
        let heartRateType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
        let heartRateQuantity = HKQuantity(unit: HKUnit(fromString: "count/min"),
                                           doubleValue: Double(arc4random_uniform(80) + 100))
        let heartSample = HKQuantitySample(type: heartRateType,
                                           quantity: heartRateQuantity, startDate: NSDate(), endDate: NSDate())
        
        // 2. Save the sample in the store
        healthKitStore.saveObject(heartSample, withCompletion: { (success, error) -> Void in
            if let error = error {
                print("Error saving heart sample: \(error.localizedDescription)")
            }
        })
    }

    
    static let healthKitStore = HKHealthStore()
    
    static func authorizeHealthKit() {
        
        let healthKitTypes: Set = [
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!
        ]
        
        healthKitStore.requestAuthorizationToShareTypes(healthKitTypes, readTypes: healthKitTypes) { _, _ in }
    }
}