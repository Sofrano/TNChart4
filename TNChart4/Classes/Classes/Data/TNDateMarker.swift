//
//  TNDateMarker.swift
//  terminal
//
//  Created by Dmitriy Safarov on 24.12.2020.
//

import Foundation
import UIKit
import Charts

protocol TNDateMarkerDataSource: class {
    func stringForValue(_ value: Double, marker: TNDateMarker) -> String
}

class TNDateMarker: MarkerImage {
    @objc var color: UIColor
    @objc var arrowSize = CGSize(width: 15, height: 11)
    @objc var font: UIFont
    @objc var textColor: UIColor
    @objc var insets: UIEdgeInsets
    @objc var minimumSize = CGSize()
    
    weak var dataSource: TNDateMarkerDataSource?
    
    private var label: String?
    private var _labelSize: CGSize = CGSize()
    private var _paragraphStyle: NSMutableParagraphStyle?
    private var _drawAttributes = [NSAttributedString.Key: Any]()
    
    var onSelectEntry: ((ChartDataEntry) -> Void)?
    
    @objc public init(color: UIColor,
                      font: UIFont,
                      textColor: UIColor,
                      insets: UIEdgeInsets) {
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        super.init()
    }
    
    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        var offset = self.offset
        var size = self.size
        
        if size.width == 0.0 && image != nil {
            size.width = image?.size.width ?? 0
        }
        if size.height == 0.0 && image != nil {
            size.height = image?.size.height ?? 0
        }
        
        let width = size.width
        let height = size.height
        let padding: CGFloat = 8.0
        
        var origin = point
        origin.x -= width / 2
        origin.y -= height
        
        if origin.x + offset.x < 0.0 {
            offset.x = -origin.x + padding
        } else if let chart = chartView,
                  origin.x + width + offset.x > chart.bounds.size.width {
            offset.x = chart.bounds.size.width - origin.x - width - padding
        }
        if origin.y + offset.y < 0 {
            offset.y = height + padding
        } else if let chart = chartView,
                  origin.y + height + offset.y > chart.bounds.size.height {
            offset.y = chart.bounds.size.height - origin.y - height - padding
        }
        
        return offset
    }
    
    override func draw(context: CGContext, point: CGPoint) {
        guard let label = label else { return }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y = (chartView?.viewPortHandler.contentBottom ?? 0.0)
        
        context.saveGState()
        
        context.setFillColor(color.cgColor)
        
        context.beginPath()
        context.move(to: CGPoint(
                        x: rect.origin.x,
                        y: rect.origin.y))
        context.addLine(to: CGPoint(
                            x: rect.origin.x + rect.size.width,
                            y: rect.origin.y))
        context.addLine(to: CGPoint(
                            x: rect.origin.x + rect.size.width,
                            y: rect.origin.y + rect.size.height - 25))
        context.addLine(to: CGPoint(
                            x: rect.origin.x ,
                            y: rect.origin.y + rect.size.height - 25))
        context.fillPath()
        
        rect.origin.y += 0

        rect.size.height -= self.insets.top + self.insets.bottom
        UIGraphicsPushContext(context)
        label.draw(in: rect, withAttributes: _drawAttributes)
        UIGraphicsPopContext()
        context.restoreGState()
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        guard let chartData = entry.data as? TNChartData else {
            return
        }
        let timestamp = chartData.time
        let date = Date(timeIntervalSince1970: timestamp)
        let value = date.toString(format: .custom("HH:mm dd MMM")) ?? ""
        setLabel(value)
        onSelectEntry?(entry)
    }
    
    @objc func setLabel(_ newLabel: String) {
        label = newLabel
        
        _drawAttributes.removeAll()
        _drawAttributes[.font] = self.font
        _drawAttributes[.paragraphStyle] = _paragraphStyle
        _drawAttributes[.foregroundColor] = self.textColor
        
        _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}
