//
//  TNXAxisRenderer.swift
//  terminal
//
//  Created by Dmitriy Safarov on 11.01.2021.
//

import Foundation
import UIKit
import Charts

//swiftlint:disable force_cast
//swiftlint:disable function_parameter_count
class TNXAxisRenderer: XAxisRenderer {
    
    var cache: [String] = []
    
    override func drawLabels(context: CGContext, pos: CGFloat, anchor: CGPoint) {
        guard
            let xAxis = self.axis as? XAxis,
            let transformer = self.transformer
        else { return }
        cache = []
        let paraStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paraStyle.alignment = .center
        
        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: xAxis.labelFont,
            .foregroundColor: xAxis.labelTextColor,
            .paragraphStyle: paraStyle
        ]
        
        let labelRotationAngleRadians = xAxis.labelRotationAngle.DEG2RAD
        let centeringEnabled = xAxis.isCenterAxisLabelsEnabled
        let valueToPixelMatrix = transformer.valueToPixelMatrix
        var position = CGPoint(x: 0.0, y: 0.0)
        var labelMaxSize = CGSize()
        
        if xAxis.isWordWrapEnabled {
            labelMaxSize.width = xAxis.wordWrapWidthPercent * valueToPixelMatrix.a
        }
        
        let entries = xAxis.entries
        
        for i in stride(from: 0, to: entries.count, by: 1) {
            if centeringEnabled {
                position.x = CGFloat(xAxis.centeredEntries[i])
            } else {
                position.x = CGFloat(entries[i])
            }
            
            position.y = 0.0
            position = position.applying(valueToPixelMatrix)
            if viewPortHandler.isInBoundsX(position.x) {
                let label = xAxis.valueFormatter?.stringForValue(xAxis.entries[i], axis: xAxis) ?? ""
                let labelns = label as NSString
                
                if xAxis.isAvoidFirstLastClippingEnabled {
                    // avoid clipping of the last
                    if i == xAxis.entryCount - 1 && xAxis.entryCount > 1 {
                        let width = labelns.boundingRect(with: labelMaxSize, options: .usesLineFragmentOrigin, attributes: labelAttrs, context: nil).size.width
                        
                        if width > viewPortHandler.offsetRight * 2.0
                            && position.x + width > viewPortHandler.chartWidth {
                            position.x -= width / 2.0
                        }
                    } else if i == 0 { // avoid clipping of the first
                        let width = labelns.boundingRect(with: labelMaxSize, options: .usesLineFragmentOrigin, attributes: labelAttrs, context: nil).size.width
                        position.x += width / 2.0
                    }
                }
                let xxx = xAxis.entries[i]
                drawLabel(context: context,
                          formattedLabel: label,
                          x: position.x,
                          y: pos,
                          posX: xxx,
                          attributes: labelAttrs,
                          constrainedToSize: labelMaxSize,
                          anchor: anchor,
                          angleRadians: labelRotationAngleRadians)
            }
        }
    }
    
    func drawLabel(context: CGContext,
                   formattedLabel: String,
                   x: CGFloat,
                   y: CGFloat,
                   posX: Double,
                   attributes: [NSAttributedString.Key: Any],
                   constrainedToSize: CGSize,
                   anchor: CGPoint,
                   angleRadians: CGFloat) {
        var formattedLabel = formattedLabel
        defer {
            super.drawLabel(context: context,
                            formattedLabel: formattedLabel,
                            x: x,
                            y: y,
                            attributes: attributes,
                            constrainedTo: constrainedToSize,
                            anchor: anchor,
                            angleRadians: angleRadians)
        }
        guard let formatter = axis.valueFormatter as? TNXAxisValueFormatter else {
            return
        }
        let timeStamp = formatter.axisTransformer.timeOf(xValue: posX)
        guard timeStamp != 0 else {
            formattedLabel = ""
            return
        }
        let date = Date(timeIntervalSince1970: timeStamp)
        let time = date.toString(format: .custom("HH:mm")) ?? ""
        let ddMM = date.toString(format: .custom("dd MMM")) ?? ""
        var postfix = ""
        if !cache.contains(ddMM) {
            cache.append(ddMM)
            postfix = ddMM
        }
        let result = time + "\n" + postfix
        
        formattedLabel = result
    }
    
}

extension FloatingPoint {
    
}
