//
//  shareData.swift
//  Junction
//
//  Created by Isaac Robinson on 8/18/16.
//  Copyright © 2016 Isaac Robinson. All rights reserved.
//

import Foundation

class shareData {
    static let sharedInstance = shareData()
   // var currentController = 0 //0 for main view, 1 for third view
    var symptomArray : [Int]
    var averageHeartRate: Int
    private init() {
        self.symptomArray = []
        self.averageHeartRate = -1
    } //do I need the self?
    
    
}