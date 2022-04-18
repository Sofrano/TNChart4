//
//  TNCandleChartRenderer.swift
//  terminal
//
//  Created by Dmitriy Safarov on 21.12.2020.
//

import Foundation
import UIKit
import Charts

/// Renderer that renders the crosshair as desired
class TNCandleStickChartRenderer: CandleStickChartRenderer {
    
    /// Draws vertical highlight-lines if enabled.
    override func drawHighlightLines(context: CGContext, point: CGPoint, set: LineScatterCandleRadarChartDataSetProtocol)
    {
        if set.isVerticalHighlightIndicatorEnabled {
            // draw vertical highlight lines
            context.beginPath()
            context.setStrokeColor(TNChartConfiguration.chartAppearance.module.chartViewHighlighLineColor.cgColor)
            context.move(to: CGPoint(x: point.x, y: viewPortHandler.contentTop))
            context.addLine(to: CGPoint(x: point.x, y: viewPortHandler.contentBottom))
            context.setLineDash(phase: 0.0, lengths: [5.0, 3.0])
            context.strokePath()
        }
        if set.isHorizontalHighlightIndicatorEnabled {
            context.beginPath()
            context.setStrokeColor(TNChartConfiguration.chartAppearance.module.chartViewHighlighLineColor.cgColor)
            context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: point.y))
            context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: point.y))
            context.setLineDash(phase: 0.0, lengths: [5.0, 3.0])
            context.strokePath()
        }
    
            guard let chartView = dataProvider as? CombinedChartView,
                  let xValue = chartView.highlighted.first?.x,
                  let yValue = chartView.highlighted.first?.y,
                  let entry = set.entryForXValue(xValue, closestToY: yValue) as? CandleChartDataEntry,
                  let trans = dataProvider?.getTransformer(forAxis: set.axisDependency) else { return }

        if set.isVerticalHighlightIndicatorEnabled {
            // Draw blue circle point
            let highPoint = trans.pixelForValues(x: Double(point.x), y: entry.close)
            let diameter: CGFloat = 8.0
            let contextCircle = UIGraphicsGetCurrentContext()
            let circlePoint = CGRect(x: point.x - diameter / 2, y: highPoint.y - diameter / 2, width: diameter, height: diameter)
            contextCircle?.setFillColor(TNChartConfiguration.chartAppearance.module.candleHighlightedCircleColor)
            contextCircle?.fillEllipse(in: circlePoint)
        }
        
        if set.isHorizontalHighlightIndicatorEnabled {
            let lastEntry = set.entryForIndex(set.entryCount - 1) as? CandleChartDataEntry
            let posY = trans.pixelForValues(x: lastEntry?.x ?? 0.0, y: lastEntry?.close ?? 0.0).y
            context.beginPath()
            context.setStrokeColor(TNChartConfiguration.chartAppearance.module.chartViewHorizontalLineColor.cgColor)
            context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: posY))
            context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: posY))
            context.setLineDash(phase: 0, lengths: [])
            context.strokePath()
        }
    }
    
}
