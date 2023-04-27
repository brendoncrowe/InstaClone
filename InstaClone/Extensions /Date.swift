//
//  Date.swift
//  InstaClone
//
//  Created by Brendon Crowe on 4/25/23.
//

import UIKit


extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
}

// another useful extension similar to above
extension Date {
    
    func agoDisplay() -> String {
        let timePeriod = ["second", "minute", "hour", "day", "week", "month", "year", "decade"]
        let duration = [60, 60, 24, 7, 4.33, 12, 10]
        var secondsAgo = Date().timeIntervalSince(self)
        
        var i: Int = 0
        while i < duration.count && secondsAgo >= duration[i] {
            secondsAgo /= duration[i]
            i += 1
        }
        return "\(Int(secondsAgo)) \(timePeriod[i])\(Int(secondsAgo) != 1 ? "s" : "") ago"
    }
}
