//
//  CombinedChartDataSource.swift
//  terminal
//
//  Created by Dmitriy Safarov on 13.01.2021.
//

import Foundation
import UIKit
import Charts

class TNCombinedChartController {
    
    // MARK: - Variables
    
    /// Combined ChartData, which combines candlestick and bar data
    var combinedChartData: CombinedChartData
    
    private var _onSelectEntry: ((ChartDataEntry) -> Void)?
    private var _chartType: TNChartType = .candles
    private var chartView: CombinedChartView?
    
    /// BarChart
    private var barChartData: BarChartData!
    private var barChartDataSet = TNBarChartDataSet(entries: [])
    
    /// CandleChart
    private var candleChartData: CandleChartData!
    private var candleChartDataSet = CandleChartDataSet(entries: [])
    
    /// LineChart
    private var lineChartData: LineChartData!
    private var lineChartDataSet = LineChartDataSet(entries: [])
    
    /// Transformer, used to convert data to coordinate
    private var axisTransformer: TNAxisPositionTransformer
    
    private var axisValueFormatter: AxisValueFormatter
    
    /// Used to protect against data duplication
    private var usedTime: [TNChartData] = []
    
    /// Last actual entry time
    private var actualEntryTime: TimeInterval?
    
    // MARK: - Constructors
    
    init(axisTransformer: TNAxisPositionTransformer,
         axisValueFormatter: AxisValueFormatter,
         chartType: TNChartType) {
        self.axisTransformer = axisTransformer
        self.axisValueFormatter = axisValueFormatter
        self.combinedChartData = CombinedChartData()
        self._chartType = chartType
        setupDataSets()
        applyAppearance()
        setupChartType(chartType)
    }
    
    // MARK: - Private Functions
    
    private func setupChartType(_ chartType: TNChartType) {
        _chartType = chartType
        switch chartType {
        case .candles:
            candleChartDataSet.visible = true
            lineChartDataSet.visible = false
            candleChartDataSet.showCandleBar = true
        case .bars:
            candleChartDataSet.visible = true
            lineChartDataSet.visible = false
            candleChartDataSet.showCandleBar = false
        case .line:
            candleChartDataSet.visible = false
            lineChartDataSet.visible = true
        }
        candleChartDataSet.notifyDataSetChanged()
        lineChartDataSet.notifyDataSetChanged()
        notifyDataChanged()
    }
    
    private func createRenderer() -> DataRenderer? {
        guard let chartView = chartView else { return nil }
        let renderer = TNCombinedChartRenderer(chart: chartView,
                                               animator: chartView.chartAnimator,
                                               viewPortHandler: chartView.viewPortHandler)
        return renderer
    }
    
    private func createMarker() -> Marker {
        let marker = TNDateMarker(color: TNChartConfiguration.chartAppearance.module.markerBackgroundColor,
                                  font: TNChartConfiguration.chartAppearance.module.markerFont,
                                  textColor: TNChartConfiguration.chartAppearance.module.markerTextColor,
                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = self.chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        marker.onSelectEntry = { [weak self] entry in
            self?._onSelectEntry?(entry)
        }
        return marker
    }
    
    private func setupDataSets() {
        candleChartData = CandleChartData(dataSet: candleChartDataSet)
        barChartData = BarChartData(dataSet: barChartDataSet)
        lineChartData = LineChartData(dataSet: lineChartDataSet)
        combinedChartData.lineData = lineChartData
        combinedChartData.candleData = candleChartData
        combinedChartData.barData = barChartData
        candleChartDataSet.visible = false
    }
    
    /// Apply appearance settings
    private func applyAppearance() {
        candleChartDataSet.setColor(TNChartConfiguration.chartAppearance.module.candleColor)
        candleChartDataSet.shadowColor = TNChartConfiguration.chartAppearance.module.candleShadowColor
        candleChartDataSet.decreasingColor = TNChartConfiguration.chartAppearance.module.candleDecreasingColor
        candleChartDataSet.increasingColor = TNChartConfiguration.chartAppearance.module.candleIncreasingColor
        candleChartDataSet.neutralColor = TNChartConfiguration.chartAppearance.module.candleShadowColor
        candleChartDataSet.highlightColor = TNChartConfiguration.chartAppearance.module.candleHighlightColor
        
        candleChartDataSet.drawIconsEnabled = false
        candleChartDataSet.axisDependency = .right
        candleChartDataSet.shadowWidth = 0.7
        candleChartDataSet.decreasingFilled = true
        candleChartDataSet.increasingFilled = true
        candleChartDataSet.drawValuesEnabled = false
        
        barChartDataSet.colors = [TNChartConfiguration.chartAppearance.module.barLineColor]
        barChartDataSet.barBorderColor = TNChartConfiguration.chartAppearance.module.barBorderColor
        barChartDataSet.barBorderWidth = 0.5
        barChartDataSet.drawValuesEnabled = false
        barChartDataSet.axisDependency = .right
        
        lineChartDataSet.axisDependency = .right
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.colors = [TNChartConfiguration.chartAppearance.module.lineColor]
        
    }
    
    /// Append and create candle entries
    ///
    /// - parameter entries: list of TNChartData data
    private func appendCandle(entries: [TNChartData]) {
        var candleEntries: [ChartDataEntry] = []
        candleEntries.reserveCapacity(entries.count)
        for entry in entries {
            let xValue = axisTransformer.transformToXValue(timeInterval: entry.time)
            let candleEntry = CandleChartDataEntry(x: xValue,
                                                   shadowH: entry.high,
                                                   shadowL: entry.low,
                                                   open: entry.open,
                                                   close: entry.close,
                                                   data: entry)
            candleEntries.append(candleEntry)
        }
        candleChartDataSet.insert(entries: candleEntries, at: 0)
        candleChartDataSet.notifyDataSetChanged()
        candleChartData.notifyDataChanged()
    }
    
    /// Append and create bar entries
    ///
    /// - parameter entries: list of TNChartData data
    private func appendBar(entries: [TNChartData]) {
        var barEntries: [ChartDataEntry] = []
        barEntries.reserveCapacity(entries.count)
        for item in entries {
            let xValue = axisTransformer.transformToXValue(timeInterval: item.time)
            let barEntry = TNBarChartDataEntry(x: xValue, y: 0)
            barEntry.volume = item.volume
            barEntry.data = item
            barEntries.append(barEntry)
        }
        barChartDataSet.insert(entries: barEntries, at: 0)
        barChartDataSet.notifyDataSetChanged()
        barChartData.notifyDataChanged()
    }
    
    private func appendLine(entries: [TNChartData]) {
        var lineEntries: [ChartDataEntry] = []
        lineEntries.reserveCapacity(entries.count)
        for entry in entries {
            let xValue = axisTransformer.transformToXValue(timeInterval: entry.time)
            let lineEntry = ChartDataEntry(x: xValue,
                                           y: entry.close,
                                           icon: nil,
                                           data: entry)
            lineEntries.append(lineEntry)
        }
        lineChartDataSet.insert(entries: lineEntries, at: 0)
        lineChartDataSet.notifyDataSetChanged()
        lineChartData.notifyDataChanged()
    }
    
}

extension TNCombinedChartController: TNChartControllerable {
   
    var isEmpty: Bool {
        candleChartData.entryCount == 0
    }
    
    var onSelectEntry: ((ChartDataEntry) -> Void)? {
        get { _onSelectEntry }
        set { _onSelectEntry = newValue }
    }
   
    var chartType: TNChartType {
        get { _chartType }
        set { setupChartType(newValue) }
    }
    
    func append(entries: [TNChartData],
                isUsefulData: inout Bool,
                actualEntryTime: inout TimeInterval?) {
        // Filter duplicates, for insurance
        usedTime.removeAll()
        let setRecievedEntries = Set(entries)
        let setCachedEntries = Set(usedTime)

        let filteredEntries = setRecievedEntries.subtracting(setCachedEntries)
        
        // We sort by time so that the position is correct
        let sortedEntries = filteredEntries.sorted { (data1, data2) -> Bool in
            return data1.time < data2.time
        }
        
        if (sortedEntries.first?.time ?? 0) > (self.actualEntryTime ?? 0) {
            self.actualEntryTime = sortedEntries.first?.time
        }
        
        // Add the time of the received data to protect against duplicates
        // when new data is received
        usedTime.append(contentsOf: sortedEntries)
        
        // Append and create candle entries
        appendCandle(entries: sortedEntries)
        
        // Append and create bar entries
        appendBar(entries: sortedEntries)
        
        // Append and create line entries
        appendLine(entries: sortedEntries)
        
        // Update chart
        notifyDataChanged()
        
        isUsefulData = !filteredEntries.isEmpty
        actualEntryTime = self.actualEntryTime
        
    }
    
    func setupChartView(_ chartView: ChartViewBase) {
        self.chartView = chartView as? CombinedChartView
        (chartView as? CombinedChartView)?.rightAxis.valueFormatter = TNYAxisValueFormatter()
        self.chartView?.scaleYEnabled = false
        chartView.renderer = createRenderer()
        chartView.marker = createMarker()
        chartView.data = combinedChartData
        chartView.xAxis.valueFormatter = axisValueFormatter
        
    }
    
    func clear() {
        chartView?.clear()
    }
    
    func notifyDataChanged() {
        guard !usedTime.isEmpty else { return }
        combinedChartData.notifyDataChanged()
        chartView?.notifyDataSetChanged()
    }
    
}
