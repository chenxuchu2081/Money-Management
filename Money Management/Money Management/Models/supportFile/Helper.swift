//
//  Helper.swift
//  Money Management
//
//  Created by CHEN Xuchu on 20/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import Foundation


class Helper: NSObject{
    
    
    
    static func FormatDate(dates: Date) -> String{
        let formatString = DateFormatter()
//        formatString.dateStyle = .long
//        formatString.timeStyle = .none
        formatString.dateFormat = "yyyy-MM-dd"
        formatString.locale = Locale(identifier: "en_US_POSIX")
        let whatTime = formatString.string(from: dates)
        
        print(whatTime)
        return whatTime
    }

   static func stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd") -> Date {
        let stringDate = string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
       // let locale = Locale.current.identifier
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.parseDate(from: stringDate)
        return date
    }
    
    static func FormatTime(time: Date, timeFormat: String="HH:mm") -> String{
        let formatString = DateFormatter()
        formatString.dateFormat = timeFormat
        let whatTime = formatString.string(from: time)
        
        print(whatTime)
        return whatTime
    }
    
    static func getComponentOfDate(Date: Date, WhichComponent: String) -> Int{
        let calendar = Calendar.current
        let currentTimeZone = TimeZone.current.identifier
        let timeZone = TimeZone.init(identifier: currentTimeZone)
        let componets = calendar.dateComponents(in: timeZone!, from: Date)
        
        switch WhichComponent {
        case "year":
            return componets.year!
        case "month":
            return componets.month!
        case "day":
            return componets.day!
        case "hour":
            return componets.hour!
        case "minute":
            return componets.minute!
        case "second":
            return componets.second!
        case "weekday":
            return componets.weekday!
        default:
            return componets.day!
        }
    }
    
    
    
    
}

extension DateFormatter
{
    private enum DateFormats: String, CaseIterable {
        case basicDate                                 = "yyyy-MM-dd"
        case basicDateWithTime_Without_Miliseconds     = "yyyy-MM-dd HH:mm:ss"
        case basicDateWithTime_With_Miliseconds        = "yyyy-MM-dd HH:mm:ss.SSSSS"
        case basicDateWithTime_WithX_Miliseconds       = "yyyy-MM-dd HH:mm:ss.SSSSx"
        
        var withTimeStamp: String {
            switch self {
            case .basicDate                             : return "yyyy-MM-dd"
            case .basicDateWithTime_Without_Miliseconds : return "yyyy-MM-dd'T'HH:mm:ss"
            case .basicDateWithTime_With_Miliseconds    : return "yyyy-MM-dd'T'HH:mm:ss.SSSSS"
            case .basicDateWithTime_WithX_Miliseconds   : return "yyyy-MM-dd'T'HH:mm:ss.SSSSx"
            }
        }
    }
    
    //  MARK: Public method
    /* We start with an empty state for dateFormat, once we found a format the works
     we use it all the time to save time, otherwise we try other formats. */
    func parseDate(from string: String?) -> Date {
        guard let dateString = string else { return Date() }
        
        if let date = self.date(from: dateString) {
            return date
        }
        else {
            return locateCorrectFormat(for: dateString)
        }
    }
    
    //  MARK: Private methods
    private func locateCorrectFormat(for dateString: String) -> Date {
        for dateFormat in DateFormats.allCases {
            if let date = parse(dateString, using: dateFormat) {
                return date
            }
        }
        
        return useRegexToExtractDate(from: dateString)
    }
    
    private func parse(_ string: String, using dateFormat: DateFormats) -> Date? {
        self.dateFormat = dateFormat.rawValue
        
        if let date = self.date(from: string) {
            return date
        }
        
        self.dateFormat = dateFormat.withTimeStamp
        if let date = self.date(from: string) {
            return date
        }
        
        return nil
    }
    
    private func useRegexToExtractDate(from stringFromAPI: String) -> Date {
        //                      (----year---)[-/.](---month-----)[-/.](---------day----------)
        let basicDatePattern = "(19|20)\\d\\d[-/.](0[1-9]|1[012])[-/.](0[1-9]|[12][0-9]|3[01])"
        
        if let regex = try? NSRegularExpression(pattern: basicDatePattern, options: NSRegularExpression.Options(rawValue: 0)) {
            if let textCheckingResault = regex.firstMatch(in: stringFromAPI,
                                                          options: .reportCompletion,
                                                          range: NSRange(location: 0, length: (stringFromAPI.count)))
            {
                let croppedDate = (stringFromAPI as NSString).substring(with: textCheckingResault.range)
                let croppedDateMatchingBasicFormat = replacCharectersInStringToMatchBasicDateFormat(croppedDate)
                
                if let foundDate = parse(croppedDateMatchingBasicFormat, using: DateFormats.basicDate) {
                    return foundDate
                }
            }
        }
        return Date()
    }
    
    private func replacCharectersInStringToMatchBasicDateFormat(_ croppedDate: String) -> String {
        let croppedDateSeperatedByHyphen = String(croppedDate.map { char in
            if char == "." || char == "/" {
                return "-"
            }
            return char
        })
        return croppedDateSeperatedByHyphen
    }
}


