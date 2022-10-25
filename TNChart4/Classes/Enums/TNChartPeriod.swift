//
//  ChartPeriod.swift
//  terminal
//
//  Created by Oleg Osipov on 04/04/2019.
//  Copyright © 2019 OlegOsipov333. All rights reserved.
// #1

import Foundation

/// Chart visible time interval
public enum TNChartPeriod: Int, CaseIterable, EnumSegmentedControlItemable {
   
    public var width: CGFloat {
        40.0
    }
    
    public var height: CGFloat {
        32.0
    }
    
    public var localized: String {
        title
    }
    
    case minute1 = -2
    case minute5 = -1
    case day = 0
    case month = 1
    case halfyear = 2
    case year = 3
    
    public var count: Int {
        switch self {
        case .minute1:
            return -200
        case .minute5:
            return -100
        case .day, .month:
            return -10
        case .halfyear, .year:
            return -1
        }
    }
    
    public var timeframe: Int {
        switch self {
        case .minute1:
            return 1
        case .minute5:
            return 5
        case .day:
            return 15
        case .month:
            return 60
        case .halfyear, .year:
            return 1440
        }
    }
    
    public var interval: String {
        switch self {
        case .minute1:
            return "I1"
        case .minute5:
            return "I5"
        case .day:
            return "I15"
        case .month:
            return "H1"
        case .halfyear, .year:
            return "D1"
        }
    }
    
    public var candleWidth: TimeInterval {
        switch self {
        case .minute1:
            return 60
        case .minute5:
            return 300
        case .day:
            return 900.0
        case .month:
            return 3600.0
        case .halfyear, .year:
            return 86400.0
        }
    }
    
    public var range: Double {
        switch self {
        case .day, .minute1, .minute5:
            return 24 * 4
        case .month:
            return 24 * 30
        case .halfyear:
            return 30 * 6
        case .year:
            return 30 * 12
        }
    }
    
    public var title: String {
        switch self {
        case .minute1:
            return "1m"
        case .minute5:
            return "5m"
        case .day:
            return TNChartConfiguration.localized.chartPeriodDay
        case .month:
            return TNChartConfiguration.localized.chartPeriodMonth
        case .halfyear:
            return TNChartConfiguration.localized.chartPeriodHalfYear
        case .year:
            return TNChartConfiguration.localized.chartPeriodYear
        }
    }
    
    /// Period calculation for pagination, depending on the mode
    ///
    /// - parameter dateTo: Countdown date
    /// - parameter intervalMode: Chart interval mode
    /// - returns: Calculated Date
    public func calculateDateFrom(at dateTo: TimeInterval, intervalMode: TNIntervalModeType) -> TimeInterval {
        switch intervalMode {
        case .closedRay:
            return closedRayCalculationDateFrom(at: dateTo)
        case .openRay:
            return openRayCalculationDateFrom(at: dateTo)
        }
    }

    /// ClosedRay period calculation for pagination (New Data)
    ///
    /// - parameter dateTo: Countdown date
    /// - returns: Calculated Date
    private func closedRayCalculationDateFrom(at dateTo: TimeInterval) -> TimeInterval {
        switch self {
        case .day, .minute1, .minute5:
            let date = Date(timeIntervalSince1970: dateTo).adding(months: -1)?.endOfMonth().startOfDay()
            return date?.timeIntervalSince1970 ?? 0
        case .month:
            let date = Date(timeIntervalSince1970: dateTo).adding(months: -3)?.endOfMonth().startOfDay()
            return date?.timeIntervalSince1970 ?? 0
        case .halfyear, .year:
            let date = Date(timeIntervalSince1970: dateTo).adding(months: -12 * 5)?.startOfYear().adding(months: -1)?.endOfMonth().startOfDay()
            return date?.timeIntervalSince1970 ?? 0
        }
    }
    
    /// OpenRay period calculation for pagination (Cached Data)
    ///
    /// - parameter dateTo: Countdown date
    /// - returns: Calculated Date
    private func openRayCalculationDateFrom(at dateTo: TimeInterval) -> TimeInterval {
        switch self {
        case .minute1:
            let date = Date(timeIntervalSince1970: dateTo).adding(months: -1)?.endOfMonth().startOfDay()
            return date?.timeIntervalSince1970 ?? 0
        case .minute5:
            let date = Date(timeIntervalSince1970: dateTo).adding(months: -1)?.endOfMonth().startOfDay()
            return date?.timeIntervalSince1970 ?? 0
        case .day:
            let date = Date(timeIntervalSince1970: dateTo).adding(months: -2)?.endOfMonth().startOfDay()
            return date?.timeIntervalSince1970 ?? 0
        case .month:
            let date = Date(timeIntervalSince1970: dateTo).adding(months: -2)?.endOfMonth().startOfDay()
            return date?.timeIntervalSince1970 ?? 0
        case .halfyear, .year:
            let date = Date(timeIntervalSince1970: dateTo).startOfYear().adding(months: -1)?.endOfMonth().startOfDay()
            return date?.timeIntervalSince1970 ?? 0
        }
    }
}

extension Date {

    func adding(months: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)

        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.month = months

        return calendar.date(byAdding: components, to: self)
    }

}
