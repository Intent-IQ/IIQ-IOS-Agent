//
//  IIQUtils.swift
//  IIQ-IOS-Agent
//
//  Created by Julian Rassolov on 25/12/2023.
//

import Foundation

class IIQUtils {
    
    public static func getCurrentDateInMilliseconds() -> Int64 {
        let currentDate = Date()
        let milliseconds = Int64(currentDate.timeIntervalSince1970 * 1000)
        return milliseconds
    }
    
    public static func convertMillisecondsToHours(milliseconds: Int64) -> Double {
        let seconds = Double(milliseconds) / 1000
        let hours = seconds / 3600
        return hours
    }
    
}
