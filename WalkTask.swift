//
//  WalkTask.swift
//  Junction
//
//  Created by Isaac Robinson on 8/12/16.
//  Copyright © 2016 Isaac Robinson. All rights reserved.
//
import Foundation
import ResearchKit

public var WalkTask: ORKOrderedTask {
    return ORKOrderedTask.fitnessCheckTaskWithIdentifier("WalkTask", intendedUseDescription:nil, walkDuration: 5 as NSTimeInterval, restDuration: 5 as NSTimeInterval, options: .None)
}