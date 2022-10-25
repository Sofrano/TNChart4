//
//  ChartType.swift
//  terminal
//
//  Created by Oleg Osipov on 04/04/2019.
//  Copyright © 2019 OlegOsipov333. All rights reserved.
// #1

import Foundation
import UIKit

/// Type of chart graph
public enum TNChartType: String, CaseIterable {
    case candles
    case line
    case bars

    /// Next chart type 
    public var next: TNChartType {
        switch self {
        case .candles: return .line
        case .line: return .bars
        case .bars: return .candles
        }
    }
    
    /// Icon for chartType
    public var icon: UIImage {
        switch self {
        case .bars: return TNChartConfiguration.imageResources.chartTypeBarIcon
        case .candles: return TNChartConfiguration.imageResources.chartTypeCandleIcon
        case .line: return TNChartConfiguration.imageResources.chartTypeLineIcon
        }
    }

}
