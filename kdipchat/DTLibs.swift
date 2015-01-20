//
//  DTLibs.swift
//  breakfast
//
//  Created by Rai on 10/16/14.
//  Copyright (c) 2014 putu dondo hariwibowo. All rights reserved.
//

import Foundation
import UIKit

class DTLibs {
    class func convertDateFromString(dateStr: String, dateStrFormat: String, dateNewFormat: String) -> String
    {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateStrFormat
        var dateFromString = dateFormatter.dateFromString(dateStr)
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = dateNewFormat
        let stringDate: String = formatter.stringFromDate(dateFromString!)
        return stringDate
    }
    
    class func convertStringToDate(dateStrFormat: String, date: String) -> NSDate
    {
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = dateStrFormat
        let newdate = formatter.dateFromString(date)
        return newdate!
    }
    
    class func convertStringFromDate(dateStrFormat: String, date: NSDate) -> String
    {
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = dateStrFormat
        let stringDate: String = formatter.stringFromDate(date)
        return stringDate
    }
    
    class func daysBetweenDate(dateFrom: String, dateEnd: String) -> Int
    {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var fromDate = dateFormatter.dateFromString(dateFrom)
        var toDate = dateFormatter.dateFromString(dateEnd)
        var calendar = NSCalendar.currentCalendar()
        
        let difference = calendar.components(NSCalendarUnit.DayCalendarUnit, fromDate: fromDate!, toDate: toDate!, options: nil)
        return difference.day
    }
    
    class func isiOS8() -> Bool
    {
        let Device = UIDevice.currentDevice()
        let iosVersion = NSString(string: Device.systemVersion).doubleValue
        let iOS8 = iosVersion >= 8
        //let iOS7 = iosVersion >= 7 && iosVersion < 8
        return iOS8 ? true : false
    }
}