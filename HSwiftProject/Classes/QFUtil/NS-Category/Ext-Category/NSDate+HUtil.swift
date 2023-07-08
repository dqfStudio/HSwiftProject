//
//  NSDate+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

enum NSDateFormat: Int {
    case style1 = 0 ///yyyy-MM-dd HH:mm:ss
    case style2 = 1 ///yyyy-MM-dd HH:mm
    case style3 = 2 ///yyyy-MM-dd
    case style4 = 3 ///yyyy年MM月dd日
}

private var startDate: NSDate?

extension NSDate {

    static func startTime() {
        if #available(iOS 13.0, *) {
            startDate = NSDate.now as NSDate
        } else {
            // Fallback on earlier versions
            startDate = NSDate()
        }
    }
    
    static func endTime() {
        if startDate != nil {
            NSLog("time: %f", -startDate!.timeIntervalSinceNow)
            self.startTime()
        }
    }

    static func time(Callback: @escaping () -> Void) {
        let startDate: NSDate?
        if #available(iOS 13.0, *) {
            startDate = NSDate.now as NSDate
        } else {
            startDate = NSDate()
        }
        Callback()
        NSLog("time: %f", -startDate!.timeIntervalSinceNow)
    }
    
    static func dateWithFormat(_ format: NSDateFormat) -> String {
        let formatString: String = self.stringWithFormat(format)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = formatString
        if #available(iOS 13.0, *) {
            return formatter.string(from: NSDate.now)
        } else {
            return formatter.string(from: NSDate() as Date)
        }
    }
    
    static func dateWithString(_ aString: String, format: NSDateFormat) -> NSDate? {
        let formatString: String = self.stringWithFormat(format)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = formatString
        return formatter.date(from: aString) as? NSDate
    }
    
    static func weekdayFromDate(_ date: NSDate) -> NSDate? {
        let weekdays: NSArray = NSArray(array: ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"])
        if let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.chinese),
           let timeZone: NSTimeZone = NSTimeZone(name: "Asia/Shanghai") {
            calendar.timeZone = timeZone as TimeZone
            let theComponents: NSDateComponents = calendar.components(in: timeZone as TimeZone, from: date as Date) as NSDateComponents
            return weekdays.object(at: theComponents.weekday) as? NSDate
        }
        return nil
    }
    
    static func pastWithDays(_ days: Int, format: NSDateFormat) -> String {
        if #available(iOS 13.0, *) {
            return self.pastWithDate(NSDate.now as NSDate, days: days, format: format)
        } else {
            return self.pastWithDate(NSDate(), days: days, format: format)
        }
    }
    
    static func pastWithDate(_ date: NSDate, days: Int, format: NSDateFormat) -> String {
        let formatString: String = self.stringWithFormat(format)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = formatString
        let pastDay: NSDate = self.pastWithDate(date, days: days)
        return formatter.string(from: pastDay as Date)
    }
    
    static func pastWithDays(_ days: Int) -> NSDate {
        if #available(iOS 13.0, *) {
            return self.pastWithDate(NSDate.now as NSDate, days: days)
        } else {
            return self.pastWithDate(NSDate(), days: days)
        }
    }
    
    static func pastWithDate(_ date: NSDate, days: Int) -> NSDate {
        let time: TimeInterval = TimeInterval(days * 24 * 60 * 60)
        return date.addingTimeInterval(-time)
    }
    
    static private func stringWithFormat(_ format: NSDateFormat) -> String {
        var formatString: String
        switch format {
        case .style1:
            formatString = "yyyy-MM-dd HH:mm:ss"
        case .style2:
            formatString = "yyyy-MM-dd HH:mm"
        case .style3:
            formatString = "yyyy-MM-dd"
        case .style4:
            formatString = "yyyy年MM月dd日"
        }
        return formatString
    }
    
}
