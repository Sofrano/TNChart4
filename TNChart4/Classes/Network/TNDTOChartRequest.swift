//
//  DTOChartRequest.swift
//  terminal
//
//  Created by Dmitriy Safarov on 15.12.2020.
//

import Foundation

public class TNDTOChartRequest: Encodable {
    public private(set) var id: String
    var count: Int
    private var timeframe: Int
    private var dateFrom: String = ""
    private var dateTo: String = ""
    private var interval: String
    var intervalMode: TNIntervalModeType
    private var demo: Int
    private(set) var type: TNChartPeriod
    public private(set) var hash: String?
    private var compareIds: String = ""
    private var compareStocks: String = ""
    private var compareTickets: String = ""
    
    private var hashDateFrom: String = ""
    private var hashDateTo: String = ""
    
    func updatePeriod(dateFrom: TimeInterval, dateTo: TimeInterval) {
        self.hashDateFrom = String(format: "%.0f", dateFrom * 1000)
        self.hashDateTo = String(format: "%.0f", dateTo * 1000)
        self.dateFrom = Date(timeIntervalSince1970: dateFrom).toString(format: .chart) ?? ""
        self.dateTo = Date(timeIntervalSince1970: dateTo).startOfDay().toString(format: intervalMode == .closedRay ? .beginChart : .chart) ?? ""
    }
    
    func updateHash() {
        hash = id + String(hashDateFrom) + String(hashDateTo) + buildJsonString().jsHash
    }
    
    private func buildJsonString() -> String {
        let result = """
    {\"id\":\"\(id)\",\"compareIds\":\"\",\"compareStocks\":\"\",\"compareTickets\":\"\",\"count\":\(count),\"timeframe\":\(timeframe),\"date_from\":\"\(dateFrom)\",\"date_to\":\"\(dateTo)\",\"interval\":\"\(interval)\",\"intervalMode\":\"\(intervalMode.rawValue)\",\"demo\":1}
    """
        return result
    }
    
    public init(id: String, type: TNChartPeriod, demo: Int) {
        self.id = id
        self.count = type.count
        self.timeframe = type.timeframe
        self.type = type
        self.interval = type.interval
        self.intervalMode = .closedRay
        self.demo = 1
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case compareIds
        case compareStocks
        case compareTickets
        case count
        case timeframe
        case dateFrom = "date_from"
        case dateTo = "date_to"
        case interval
        case intervalMode
        case demo
        case hash
    }
}
