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
        let formatter = makeFormatter(format)
        if #available(iOS 13.0, *) {
            return formatter.string(from: NSDate.now)
        } else {
            return formatter.string(from: NSDate() as Date)
        }
    }
    
    static func dateWithString(_ aString: String, format: NSDateFormat) -> NSDate? {
        let formatter = makeFormatter(format)
        return formatter.date(from: aString) as? NSDate
    }
    
    static func weekdayFromDate(_ date: NSDate) -> String? {
        let weekdays = ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Shanghai") ?? .current
        let weekday = calendar.component(.weekday, from: date as Date)
        let index = weekday - 1
        guard weekdays.indices.contains(index) else { return nil }
        return weekdays[index]
    }
    
    static func pastWithDays(_ days: Int, format: NSDateFormat) -> String {
        if #available(iOS 13.0, *) {
            return self.pastWithDate(NSDate.now as NSDate, days: days, format: format)
        } else {
            return self.pastWithDate(NSDate(), days: days, format: format)
        }
    }
    
    static func pastWithDate(_ date: NSDate, days: Int, format: NSDateFormat) -> String {
        let formatter = makeFormatter(format)
        let pastDay = self.pastWithDate(date, days: days)
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
        let time = TimeInterval(days * 24 * 60 * 60)
        return date.addingTimeInterval(-time)
    }
    
    static private func makeFormatter(_ format: NSDateFormat) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = stringWithFormat(format)
        return formatter
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
