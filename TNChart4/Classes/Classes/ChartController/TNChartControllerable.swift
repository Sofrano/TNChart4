//
//  ChartControllerable.swift
//  terminal
//
//  Created by Dmitriy Safarov on 13.01.2021.
//

import Foundation
import Charts

protocol TNChartControllerable {

    /// Chart is empty or not. Used for correct data processing
    var isEmpty: Bool { get }
    
    /// Sets the current chart display type
    var chartType: TNChartType { get set }
    
    /// Callback, when user select entry
    var onSelectEntry: ((ChartDataEntry) -> Void)? { get set }
    
    /// Append and create entries for chart
    ///
    /// - parameter entries:list of TNChartData data
    /// - returns: true - if new data has been added (duplicates are ignored)
    func append(entries: [TNChartData],
                isUsefulData: inout Bool,
                actualEntryTime: inout TimeInterval?)
    
    /// Setup chart by controller
    ///
    /// - parameter chartView: chartView to be customized
    func setupChartView(_ chartView: ChartViewBase)
    
    /// Call this method to let the ChartData know that the underlying data has changed.
    /// Calling this performs all necessary recalculations needed when the contained
    /// data has changed.
    func notifyDataChanged()
    
    /// Clears the chart from all data (sets it to null) and refreshes it (by calling setNeedsDisplay()).
    func clear()
}
