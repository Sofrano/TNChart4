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
        var maximum: Double = -Double.greatestFiniteMagnitude
        if fromX > toX { return nil }
        let fromIndex = entryIndex(x: fromX, closestToY: Double.nan, rounding: .closest)
        let toIndex = entryIndex(x: toX, closestToY: Double.nan, rounding: .closest)
        
        for index in fromIndex...toIndex {
            if let entry = entries[index] as? TNBarChartDataEntry {
                if maximum < entry.volume { maximum = entry.volume }
            }
        }
        return maximum
    }
    
}
