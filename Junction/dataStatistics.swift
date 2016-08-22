//
//  dataStatistics.swift
//  Junction
//
//  Created by Isaac Robinson on 8/22/16.
//  Copyright © 2016 Isaac Robinson. All rights reserved.
//

import Foundation
import HealthKit


class dataStatistics{
    
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
    }()

    
    
    func getStats(){
    
    let calendar = NSCalendar.currentCalendar()
    
    let intervals = NSDateComponents()
    intervals.day = 3
    
    // Set the anchor date to Monday at 3:00 a.m.
    let anchorComponents = calendar.components([.Day, .Month, .Year, .Weekday], fromDate: NSDate())
    
    
    let offset = (3 + anchorComponents.weekday - 2) % 7
    anchorComponents.day -= offset
    anchorComponents.hour = 1
    
    guard let anchorDate = calendar.dateFromComponents(anchorComponents) else {
    fatalError("*** unable to create a valid date from the given components ***")
    }
    
    guard let quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate) else {
    fatalError("*** Unable to create a step count type ***")
    }
    
        // Create the query
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                quantitySamplePredicate: nil,
                                                options: .DiscreteAverage,
                                                anchorDate: anchorDate,
                                                intervalComponents: intervals)
        
        // Set the results handler
        query.initialResultsHandler = {
            query, results, error in
            
            guard let statsCollection = results else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: (error?.localizedDescription) ***")
            }
            
            let endDate = NSDate()
            
            guard let startDate = calendar.dateByAddingUnit(.Month, value: -3, toDate: endDate, options: []) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            // Plot the weekly step counts over the past 3 months
            statsCollection.enumerateStatisticsFromDate(startDate, toDate: endDate) { [unowned self] statistics, stop in
                
                if let quantity = statistics.averageQuantity() {
                    let date = statistics.startDate
                   // let value = quantity.doubleValueForUnit(HKUnit.countUnit())
                    let value = Int(quantity.doubleValueForUnit(HKUnit.init(fromString: "count/s"))*60)
                    // Call a custom method to plot each data point.
                   // self.plotWeeklyStepCount(value, forDate: date)
                    print(value)
                    shareData.sharedInstance.averageHeartRate = value
                }
            }
        }
        print("work")
        healthStore?.executeQuery(query)
        
    }
    
}
