//
//  Date+ext.swift
//  terminal
//
//  Created by Dmitriy Safarov on 10.04.2020.
//  Copyright © 2020 OlegOsipov333. All rights reserved.
//

import Foundation

extension Date {
    
    enum DateFormatType: CaseIterable {
         static var allCases: [DateFormatType] {
            return [.apiShort, .apiWithoutTime, .apiLongTime, .apiLongTimeT, .apiTriggeredAlert, .apiShortWithSeconds, .apiShortWithSecondsTAndQuotes]
        }
        // The chart date "dd.MM.yyyy"
        case chart
        case beginChart
        // The HH:mm
        case hhmm
        /// The UI formatted date "yyyy-MM-dd HH:mm:ss"
        case apiShortWithSeconds
        /// The UI formatted date "yyyy-MM-ddTHH:mm:ss"
        case apiShortWithSecondsT
        /// The UI formatted date "yyyy-MM-dd'T'HH:mm:ss"
        case apiShortWithSecondsTAndQuotes
        /// The UI formatted date "dd MMMM yyyy"
        case uiDate
        /// The UI formatted date "dd MMMM yyyy HH:mm"
        case uiDateTime
        /// The API Formatted date "yyyy-MM-dd HH:mm"
        case apiShort
        /// The API formatted date "yyyy-MM-dd"
        case apiWithoutTime
        /// The API formatted date "yyyy-MM-dd HH:mm:ss.SSS"
        case apiLongTime
        /// The API formatted date "yyyy-MM-dd'T'HH:mm:ss.SSS"
        case apiLongTimeT
        /// The API formatted date  "MMM  d yyyy H:mma"
        case apiTriggeredAlert
        /// The API formatted date  "yyyy-MM-dd HH:mm:ss.SSS"
        case apiShortWithMilliseconds
        /// A custom date format string
        case custom(String)
        
        var stringFormat: String {
            switch self {
            case .chart: return "dd.MM.yyyy HH:mm"
            case .beginChart: return "dd.MM.yyyy"
            case .hhmm: return "HH:mm"
            case .apiLongTime: return "yyyy-MM-dd HH:mm:ss.SSS"
            case .apiLongTimeT: return "yyyy-MM-dd'T'HH:mm:ss.SSS"
            case .apiTriggeredAlert: return "MMM  d yyyy H:mma"
            case .uiDate: return "dd MMMM yyyy"
            case .uiDateTime: return "dd MMMM yyyy HH:mm"
            case .apiShort: return "yyyy-MM-dd HH:mm"
            case .apiShortWithSecondsT: return "yyyy-MM-ddTHH:mm:ss"
            case .apiShortWithSecondsTAndQuotes: return "yyyy-MM-dd'T'HH:mm:ss"
            case .apiShortWithSeconds: return "yyyy-MM-dd HH:mm:ss"
            case .apiShortWithMilliseconds: return "yyyy-MM-dd HH:mm:ss.SSS"
            case .apiWithoutTime: return "yyyy-MM-dd"
            case .custom(let customFormat): return customFormat
            }
        }
    }
    
    init?(fromString: String,
          format: DateFormatType,
          locale: Locale = Locale(identifier: TNChartConfiguration.systemLang),
          bruteForce: Bool = true) {
        guard !fromString.isEmpty else {
            return nil
        }
        var dateFormatter = DateFormatterHelper.shared.get(dateFormat: format.stringFormat, locale: locale)
        guard let date = dateFormatter.date(from: fromString) else {
            if bruteForce {
                let allFormatTypes = DateFormatType.allCases
                for format in allFormatTypes {
                    dateFormatter = DateFormatterHelper.shared.get(dateFormat: format.stringFormat, locale: locale)
                    if let date = dateFormatter.date(from: fromString) {
                        self.init(timeInterval: 0, since: date)
//                        Log.error(id: 213, #file, #line, #column, #function, "DateFormatType.successful brute force: \(fromString) requestFormat:\(format.stringFormat) detectedFormat: \(format.stringFormat)")
                        return
                    }
                }
            }
            return nil
        }
        self.init(timeInterval: 0, since: date)
    }
    
    func toString(format: DateFormatType, timeZone: TimeZone? = TimeZone.current) -> String? {
        let dateFormatter = DateFormatterHelper.shared.get(
            dateFormat: format.stringFormat,
            locale: Locale(identifier: TNChartConfiguration.systemLang),
            timeZone: timeZone)
        return dateFormatter.string(from: self)
    }
    
    init?(fromYYMMDDxxxHHMMSSformat text: String) {
        let dateInputLenght = 10
        let timeInputLenght = 8
        let resultingFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatterHelper.shared.get(dateFormat: resultingFormat, locale: Locale(identifier: "en_US_POSIX"))
        let resultingString = String(text.prefix(dateInputLenght)) + " " + String(text.suffix(timeInputLenght))
        if let date = dateFormatter.date(from: resultingString) {
            self.init(timeInterval: 0, since: date)
        } else {
            return nil
        }
        
    }
    
    mutating func change(_ component: Calendar.Component, by value: Int) {
        self = Calendar.current.date(byAdding: component, value: value, to: self) ?? self
    }
    func changed(_ component: Calendar.Component, by value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self) ?? self
    }

    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }

    func endOfDay() -> Date {
        return Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: self.startOfDay()) ?? self
    }

    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self))) ?? self
    }

    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth()) ?? self
    }
    func startOfYear() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self))) ?? self
    }

    func endOfYear() -> Date {
        return Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: self.startOfYear()) ?? self
    }

    func convertTimeZone(from initTimeZone: TimeZone = TimeZone.current, to targetTimeZone: TimeZone) -> Date {
        let delta = TimeInterval(targetTimeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
        return addingTimeInterval(delta)
    }

    func convertTimeZone(from initTimeZone: TimeZone?, to targetTimeZone: TimeZone?) -> Date {
        guard let initTimeZone = initTimeZone, let targetTimeZone = targetTimeZone else {
            return self
        }
        return convertTimeZone(from: initTimeZone, to: targetTimeZone)
    }

    static func timeZoneInterval(between initTimeZone: TimeZone?, and targetTimeZone: TimeZone?) -> TimeInterval {
        guard let initTimeZone = initTimeZone, let targetTimeZone = targetTimeZone else {
            return 0.0
        }
        return TimeInterval(targetTimeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
    }
    
}
