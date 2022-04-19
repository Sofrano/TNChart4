//
//  ChartRequestBuilder.swift
//  terminal
//
//  Created by Dmitriy Safarov on 26.01.2021.
//

import Foundation

/// Chart Request Build, controls pagination and, depending on the parameters, configures the request as appropriate
public class TNChartRequestBuilder {
    private var lastTimeInterval: TimeInterval
    private var request: TNDTOChartRequest
    
    public init(request: TNDTOChartRequest) {
        self.request = request
        lastTimeInterval = Date().timeIntervalSince1970
    }
    
    /// Request creating  to update the latest data
    public func requestForActualData() -> TNDTOChartRequest {
        request.updatePeriod(dateFrom: Date().timeIntervalSince1970 - 8400,
                             dateTo: Date().timeIntervalSince1970)
        request.updateHash()
        request.count = 1
        request.intervalMode = .closedRay
        return request
    }
    
    /// Request creating for next page
    public func requestForNextPage() -> TNDTOChartRequest {
        let dateFrom = request.type.calculateDateFrom(at: lastTimeInterval, intervalMode: request.intervalMode)
        let dateTo = Date(timeIntervalSince1970: lastTimeInterval).addingTimeInterval(60 * 60 * 24).startOfDay().timeIntervalSince1970
        request.updatePeriod(dateFrom: dateFrom, dateTo: dateTo)
        request.updateHash()
        return request
    }
    
    /// A function that says that the request was executed correctly
    /// and the logic should be based on this next time
    public func done() {
        lastTimeInterval = request.type.calculateDateFrom(at: lastTimeInterval, intervalMode: request.intervalMode) - 1
        request.intervalMode = .closedRay
        request.count = -1
    }
}
