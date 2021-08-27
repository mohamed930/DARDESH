//
//  UIDate.swift
//  DARDESH
//
//  Created by Mohamed Ali on 19/07/2021.
//

import UIKit

extension Date {
    
    func timeElapsed () -> String {
        
        let seconds = Date().timeIntervalSince(self)
        var elapsed = ""
        
        if seconds < 60 {
            elapsed = "Just now"
        }
        else if seconds < 60 * 60 {
            let minutes = Int(seconds/60)
            let minText = minutes > 1 ? "mins" : "min"
            elapsed = "\(minutes) \(minText)"
        }
        else if seconds < 24 * 60 * 60 {
            let hours = Int(seconds / (60*60))
            let hourText = hours > 1 ? "hours" : "hour"
            elapsed = "\(hours) \(hourText)"
        }
        else  {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let result = formatter.string(from: self)
            
            elapsed = result
        }
        
        return elapsed
        
    }
    
    func ConvertTimeString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        return dateformatter.string(from: self)
    }
    
    
    func StringDate () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyyyHHmmss a"
        return dateFormatter.string(from: self)
    }
    
}
