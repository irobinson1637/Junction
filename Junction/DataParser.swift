//
//  DataParser.swift
//  Junction
//
//  Created by Isaac Robinson on 8/12/16.
//  Copyright © 2016 Isaac Robinson. All rights reserved.
//

import Foundation
import ResearchKit

struct DataParser {
    
    static func findWalkHeartFiles(result: ORKTaskResult) -> [NSURL] { //creates array of results, step 4 or index 3 of results is walk
        
        var urls = [NSURL]()
        
        if let results = result.results
            where results.count > 4,
            let walkResult = results[3] as? ORKStepResult,
            let restResult = results[4] as? ORKStepResult {
            
            for result in walkResult.results! { //yay parsing!
                if let result = result as? ORKFileResult,
                    let fileUrl = result.fileURL {
                    urls.append(fileUrl)
                }
            }
            
            for result in restResult.results! {
                if let result = result as? ORKFileResult,
                    let fileUrl = result.fileURL {
                    urls.append(fileUrl)
                }
            }
        }
        
        return urls
    }
}