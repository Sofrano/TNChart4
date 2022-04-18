//
//  NativeChartNativeChartViewOutput.swift
//  terminal
//
//  Created by Dmitriy Safarov on 22/12/2020.
//  Copyright © 2020 Tradernet. All rights reserved.
//


public protocol NativeChartViewOutput {
    func viewIsReady()
    func nextPageIfNeed(lowestVisibleX: Double,
                        visibleXRange: Double,
                        chartXMin: Double)
    func setChartType(_ chartType: TNChartType)
    func changeChartPeriodType(_ period: TNChartPeriod)
    func resetAll()
    func reload()
    func dispose()
    func update()
}
