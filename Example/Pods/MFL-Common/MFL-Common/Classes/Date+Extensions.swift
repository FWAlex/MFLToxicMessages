//

//  Date+Extensions.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 02/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public extension Date {
    
    func component(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
    
    func dateByAdding(months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
    
    func dateByAdding(years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self)!
    }
    
    func commonComponents() -> DateComponents {
        return Calendar.current.dateComponents([.hour, .minute, .day, .month, .year], from: self)
    }
    
    func daysTo(_ date: Date) -> Int {
        let calendar = NSCalendar.current
        
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        
        return calendar.dateComponents([.day], from: date1, to: date2).day ?? 0
    }
    
    public func isWithin24Hours(of date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: self, to: date)
        
        if let hours = components.hour, abs(hours) <= 24 {
            guard let minutes = components.minute, let seconds = components.second else { return false }
            
            if abs(hours) == 24 && ( abs(minutes) > 0 || abs(seconds) > 0 ) { return false }
            
            return true
        }
        
        return false
    }
}


