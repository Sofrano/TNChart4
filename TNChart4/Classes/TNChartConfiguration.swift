//
//  Configuration.swift
//  terminal
//
//  Created by Dmitriy Safarov on 13.05.2021.
//

import Foundation
import Charts

public protocol ChartConfiguratorable {
    func configureChart(_ chart: CombinedChartView)
    func configureRenderer(_ renderer: TNCombinedChartRenderer)
}

public class NewChartConfigurator: ChartConfiguratorable {
   
    public func configureChart(_ chart: CombinedChartView) {
        chart.rightAxis.drawGridLinesEnabled = false
        chart.xAxis.gridLineDashLengths = []
    }
    
    public func configureRenderer(_ renderer: TNCombinedChartRenderer) {
        renderer.shouldDrawPopupValue = true
        renderer.shouldRoundCandleCorners = true
    }
    
    public init() { }
}

public class TNChartConfiguration {
    
    static var imageResources: TNChartImageResourcable!
    static var chartAppearance: TNChartAppearancable!
    static var localized: TNChartLocalized!
    static var systemLang: String!
    static var chartConfigurator: ChartConfiguratorable?
    
    public static func configure(imageResources: TNChartImageResourcable,
                                 chartAppearance: TNChartAppearancable,
                                 localizedStrings: TNChartLocalized,
                                 systemLang: String,
                                 configurator: ChartConfiguratorable? = nil) {
        self.imageResources = imageResources
        self.chartAppearance = chartAppearance
        self.localized = localizedStrings
        self.systemLang = systemLang
        self.chartConfigurator = configurator
    }
    
    public static func configure(systemLang: String) {
        self.systemLang = systemLang
    }
    
    public static func configure(chartAppearance: TNChartAppearancable) {
        self.chartAppearance = chartAppearance
    }
    
    

}
