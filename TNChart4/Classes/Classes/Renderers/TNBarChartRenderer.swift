//
//  TNBarChartRenderer.swift
//  terminal
//
//  Created by Dmitriy Safarov on 06.01.2021.
//

import Foundation
import UIKit
import Charts

class TNBarChartRenderer: BarChartRenderer {
    override func drawDataSet(context: CGContext, dataSet: BarChartDataSetProtocol, index: Int) {
        guard let chartView = dataProvider as? CombinedChartView,
              let tnBarChartDataSet = dataSet as? TNBarChartDataSet else {
            super.drawDataSet(context: context, dataSet: dataSet, index: index)
            return
        }
        
        // we determine the displayed range of values along the x-axis in order
        // to further optimally work with the calculation of values
        let lowestVisibleX = chartView.lowestVisibleX
        let highestVisibleX = chartView.highestVisibleX
        
        // For the minimum possible value for displaying a bar,
        // we take the minimum value on the Y axis
        let minValue = chartView.rightAxis.axisMinimum < 0
            ? 0
            : chartView.rightAxis.axisMinimum
        let maxValue = chartView.rightAxis.axisMaximum
        
        // Сalculate the maximum value of the trading volume in a given
        // range to determine the highest bar position
        guard let maxTradingVolume = tnBarChartDataSet.minMaxY(fromX: lowestVisibleX,
                                                               toX: highestVisibleX) else {
            super.drawDataSet(context: context, dataSet: dataSet, index: index)
            return
        }
        
        // Calculate the center of the screen as the edge for drawing the highest bar
        let center = ((maxValue - minValue) / 2) + minValue
        
        // We calculate the coefficient to calculate the bar height
        let coeff = (center - minValue) / (maxTradingVolume)
        
        // We go through all bars and adjust their height depending
        // on the trading volume and coefficient
        for index in Int(lowestVisibleX)...Int(highestVisibleX) {
            guard let entry = dataSet.entryForXValue(Double(index), closestToY: 0) as? TNBarChartDataEntry else {
                continue
            }
            entry.y = entry.volume * coeff + minValue
        }
        
        super.drawDataSet(context: context, dataSet: dataSet, index: index)
    }

    
}
