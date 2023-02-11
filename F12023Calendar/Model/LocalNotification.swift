//
//  LocalNotification.swift
//  F12023Calendar
//
//  Created by Andrey Studenkov on 10.02.2023.
//

import Foundation

struct LocalNotification {
   
    var identifier: String
    var scheduleType: ScheduleType
    var title: String
    var body: String
    var timeInterval: Double?
    var dateComponents: DateComponents?
    var repeats: Bool
    
    internal init(identifier: String, title: String, body: String, timeInterval: Double,  repeats: Bool) {
        self.identifier = identifier
        self.scheduleType = .time
        self.title = title
        self.body = body
        self.timeInterval = timeInterval
        self.dateComponents = nil
        self.repeats = repeats
    }
    
    internal init(identifier: String, title: String, body: String, dateComponents: DateComponents, repeats: Bool) {
        self.identifier = identifier
        self.scheduleType = .calendar
        self.title = title
        self.body = body
        self.timeInterval = nil
        self.dateComponents = dateComponents
        self.repeats = repeats
    }
    
    enum ScheduleType {
        case time, calendar
    }
}
