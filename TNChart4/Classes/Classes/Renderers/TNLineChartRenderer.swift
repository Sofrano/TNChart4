//
//  TNLineChartRenderer.swift
//  terminal
//
//  Created by Dmitriy Safarov on 15.01.2021.
//

import Foundation
import UIKit
import Charts

class TNLineChartRenderer: LineChartRenderer {
    
    var shouldDrawPopupValue: Bool = false
    var yAxisValueFormatter: AxisValueFormatter?
    
    /// Draws vertical highlight-lines if enabled.
    override func drawHighlightLines(context: CGContext, point: CGPoint, set: LineScatterCandleRadarChartDataSetProtocol) {
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
              let entry = set.entryForXValue(xValue, closestToY: yValue),
              let trans = dataProvider?.getTransformer(forAxis: set.axisDependency) else { return }

        
        if set.isVerticalHighlightIndicatorEnabled {
            // Draw blue circle point
            let highPoint = trans.pixelForValues(x: Double(point.x), y: entry.y)
            let diameter: CGFloat = 8.0
            let contextCircle = UIGraphicsGetCurrentContext()
            let circlePoint = CGRect(x: point.x - diameter / 2, y: highPoint.y - diameter / 2, width: diameter, height: diameter)
            contextCircle?.setFillColor(TNChartConfiguration.chartAppearance.module.candleHighlightedCircleColor)
            contextCircle?.fillEllipse(in: circlePoint)
        }
    }
    
    override func drawDataSet(context: CGContext, dataSet: LineChartDataSetProtocol) {
        drawCurrentValueLine(context: context, dataSet: dataSet)
        super.drawDataSet(context: context, dataSet: dataSet)
    }
    
    func drawCurrentValueLine(context: CGContext, dataSet: LineChartDataSetProtocol) {
        guard dataSet.isVisible,
              let lastEntry = dataSet.entryForIndex(dataSet.entryCount - 1),
              let trans = dataProvider?.getTransformer(forAxis: dataSet.axisDependency)
        else { return }
        
        context.saveGState()
        defer { context.restoreGState() }
        let posY = trans.pixelForValues(x: lastEntry.x ?? 0.0, y: lastEntry.y ?? 0.0).y
        context.beginPath()
        if shouldDrawPopupValue {
            let color = dataSet.color(atIndex: dataSet.entryCount - 1)
            context.setStrokeColor(color.cgColor)
        } else {
            context.setStrokeColor(TNChartConfiguration.chartAppearance.module.chartViewHorizontalLineColor.cgColor)
        }
        context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: posY))
        context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: posY))
        context.setLineDash(phase: 0, lengths: shouldDrawPopupValue ? [5.0, 3.0] : [])
        context.strokePath()
    }
    
    override func drawValues(context: CGContext) {
        super.drawValues(context: context)
        guard shouldDrawPopupValue else { return }
        dataProvider?.lineData?.dataSets.forEach {
            if let dataSet = $0 as? LineChartDataSetProtocol {
                drawPopupValue(context: context, dataSet: dataSet)
            }
        }
    }
    
    private func drawPopupValue(context: CGContext, dataSet: LineChartDataSetProtocol) {
        guard dataSet.isVisible,
              let lastEntry = dataSet.entryForIndex(dataSet.entryCount - 1),
              let trans = dataProvider?.getTransformer(forAxis: dataSet.axisDependency)
        else { return }
        
        context.saveGState()
        defer { context.restoreGState() }
        let centerY = trans.pixelForValues(x: lastEntry.x ?? 0.0, y: lastEntry.y ?? 0.0).y
        let color = dataSet.color(atIndex: dataSet.entryCount - 1)
        context.setFillColor(color.cgColor)
        let text = yAxisValueFormatter?.stringForValue(lastEntry.y, axis: nil) ?? ""
        let font = UIFont.systemFont(ofSize: 10.0)
        let attrString = NSMutableAttributedString(string: text,
                                                   attributes: [NSAttributedString.Key.font: font,
                                                                NSAttributedString.Key.foregroundColor: UIColor.white])
        let textSize = attrString.size()
        
        var legendRect = CGRect()
        let legendWidth = textSize.width + 8.0
        let legendHeight = textSize.height + 4.0
        let legendOffset = 14.0
        legendRect.origin.x = viewPortHandler.contentRight - legendWidth
        legendRect.origin.y = centerY - (legendHeight / 2)
        legendRect.size.width = legendWidth
        legendRect.size.height = legendHeight
        let legendPath = UIBezierPath(roundedRect: legendRect, cornerRadius: 0)
        legendPath.fill()
        
        let textRect = CGRect(x: legendRect.origin.x + 4.0,
                              y: legendRect.origin.y + 2.0,
                              width: textSize.width,
                              height: 12.0)
        attrString.draw(in: textRect)
    }
    
}
