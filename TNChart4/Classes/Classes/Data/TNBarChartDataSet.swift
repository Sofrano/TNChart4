//
//  TNChartData.swift
//  terminal
//
//  Created by Dmitriy Safarov on 05.01.2021.
//

import Foundation
import Charts

class TNBarChartDataSet: BarChartDataSet {
    
    /// We calculate the maximum value of the sales volume for a given range of the x-axis
    func minMaxY(fromX: Double, toX: Double) -> Double? {
        var max: Double = -Double.greatestFiniteMagnitude
        if fromX > toX { return nil }
        for index in Int(fromX)...Int(toX) {
            guard let entry = entryForXValue(Double(index), closestToY: 0) as? TNBarChartDataEntry else { continue }
            if max < entry.volume { max = entry.volume }
        }
        return max
    }
    
}
