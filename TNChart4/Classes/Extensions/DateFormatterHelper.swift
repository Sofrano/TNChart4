//
//  DateFormatterHelper.swift
//  terminal
//
//  Created by Developer333 on 21/07/2020.
//  Copyright © 2020 OlegOsipov333. All rights reserved.
//

import Foundation

class DateFormatterHelper {
    struct DateFormatterIdentifier: Hashable {
        let locale: Locale
        let dateFormat: String
        let timeZone: TimeZone
        var queue: String
    }
    
    static let shared = DateFormatterHelper()
    
    private init() { }
    
    private let queue = DispatchQueue(label: "dateFormatter", qos: .default)
    private var dateFormatters: [DateFormatterIdentifier: DateFormatter] = [:]
    
    func get(dateFormat: String, locale: Locale = Locale(identifier: TNChartConfiguration.systemLang), timeZone: TimeZone? = TimeZone.current) -> DateFormatter {
        guard let currentQueue = DispatchQueue.currentLabel else {
            return DateFormatter(dateFormat: dateFormat, locale: locale, timeZone: timeZone ?? TimeZone.current)
        }
        
        let identifier = DateFormatterIdentifier(locale: locale, dateFormat: dateFormat, timeZone: timeZone ?? TimeZone.current, queue: currentQueue)
        let dateFormatter = queue.sync(execute: { () -> DateFormatter in
            if let dateFormatter = dateFormatters[identifier] {
                return dateFormatter
            } else {
                let dateFormatter = DateFormatter(dateFormat: dateFormat, locale: locale, timeZone: timeZone ?? TimeZone.current)
                dateFormatters[identifier] = dateFormatter
                return dateFormatter
            }
        })
        return dateFormatter
    }
}

extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
    
    convenience init(dateFormat: String, locale: Locale = Locale(identifier: TNChartConfiguration.systemLang), timeZone: TimeZone = TimeZone.current) {
        self.init()
        self.dateFormat = dateFormat
        self.locale = locale
        self.timeZone = timeZone
    }
}

extension DispatchQueue {
    class var currentLabel: String? { return String(validatingUTF8: __dispatch_queue_get_label(nil)) }
}
