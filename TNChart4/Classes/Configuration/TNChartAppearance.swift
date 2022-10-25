//
//  ChartAppearance.swift
//  terminal
//
//  Created by Dmitriy Safarov on 08.01.2021.
//

import Foundation
import UIKit

public protocol TNChartAppearancable {
    var module: TNChartModuleAppearancable { get }
    var panel: TNChartFullscreenPanelAppearancable { get }
    var control: TNChartMinimizedPanelAppearancable { get }
    var newControl: TNMinimizedExtendedPanelAppearancable { get }
    var sheet: TNChartSheetAppearancable { get }
}

public protocol TNChartModuleAppearancable {
    var markerBackgroundColor: UIColor { get }
    var markerFont: UIFont { get }
    var markerTextColor: UIColor { get }
    
    var legendFont: UIFont { get }
    var legendBackgroundColor: UIColor { get }
    var legendForegroundColor: UIColor { get }
    var legendAttributes: [NSAttributedString.Key: Any] { get }
    
    var xAxisTextColor: UIColor { get }
    var xAxisTextFont: UIFont { get }
    
    var yAxisTextColor: UIColor { get }
    var yAxisTextFont: UIFont { get }
    var yAxisLineColor: UIColor { get }

    var candleColor: UIColor { get }
    var candleHighlightColor: UIColor { get }
    var candleShadowColor: UIColor { get }
    var candleDecreasingColor: UIColor { get }
    var candleIncreasingColor: UIColor { get }
    var candleHighlightedCircleColor: CGColor { get }

    var chartViewHighlighLineColor: UIColor { get }
    var chartViewGridColor: UIColor { get }
    var chartViewBackgroundColor: UIColor { get }
    var chartViewHorizontalLineColor: UIColor { get }
    
    var barBorderColor: UIColor { get }
    var barLineColor: UIColor { get }
    
    var lineColor: UIColor { get }
    
    var activityIndicatorColor: UIColor { get }
    var activityIndicatorStyle: UIActivityIndicatorView.Style { get }
}

public protocol TNChartSheetAppearancable {
    var backgroundAlpha: CGFloat { get }
    var cellTextColor: UIColor { get }
    var cellTextFont: UIFont { get }
    var tableFooterViewTitleTextColor: UIColor { get }
    var tableFooterViewTitleTextFont: UIFont { get }
    var tableHeaderBackgroundColor: UIColor { get }
    var sheetContainerBackgroundColor: UIColor { get }
    var backgroundViewBackgroundColor: UIColor { get }
    var pulleyBackgroundColor: UIColor { get }
    func setupCellSeparator(_ separatorView: UIView)
}

public protocol TNChartFullscreenPanelAppearancable {
    var buttonsBackgroundColor: UIColor { get }
    
    var periodButtonActiveTitleColor: UIColor { get }
    var periodButtonActiveBackgroundColor: UIColor { get }
    
    var periodButtonDefaultTitleColor: UIColor { get }
    var periodButtonDefaultBackgroundColor: UIColor { get }
    
    var chartRendererButtonTitleColor: UIColor { get }
    var chartPeriodButtonTitleColor: UIColor { get }
    
    var chartRendererButtonFont: UIFont { get }
    var chartPeriodButtonFont: UIFont { get }
}

public protocol TNChartMinimizedPanelAppearancable {
    var chartTypeBackgroundColor: UIColor { get }
    var chartTypeBorderColor: UIColor { get }
    var chartTypeIconTintColor: UIColor { get }
    
    var periodButtonActiveTitleColor: UIColor { get }
    var periodButtonActiveBackgroundColor: UIColor { get }
    
    var periodButtonDefaultTitleColor: UIColor { get }
    var periodButtonDefaultBackgroundColor: UIColor { get }
    
    var periodButtonTitleFont: UIFont { get }
}
