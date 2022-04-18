//
//  ChartData.swift
//  terminal
//
//  Created by Dmitriy Safarov on 22.12.2020.
//

import Foundation

public struct TNChartDataInfo: Hashable {
    let defaultTicker: String
    
    public init(defaultTicker: String) {
        self.defaultTicker = defaultTicker
    }
    
    public static func == (lhs: TNChartDataInfo, rhs: TNChartDataInfo) -> Bool {
        return true
    }
    
}

public struct TNChartData: Hashable {
    let time: Double
    let volume: Double
    let hloc: [Double]
    let info: TNChartDataInfo
    
    public init(time: Double, volume: Double, hloc: [Double], info: TNChartDataInfo) {
        self.time = time
        self.volume = volume
        self.hloc = hloc
        self.info = info
    }
    
    var high: Double { hloc[0] }
    var low: Double { hloc[1] }
    var open: Double { hloc[2] }
    var close: Double { hloc[3] }
    
    public static func == (lhs: TNChartData, rhs: TNChartData) -> Bool {
        return lhs.time == rhs.time
    }
    
}
