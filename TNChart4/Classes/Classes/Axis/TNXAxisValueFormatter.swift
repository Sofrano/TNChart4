//
//  AxisValueFormatter.swift
//  terminal
//
//  Created by Dmitriy Safarov on 13.01.2021.
//

import Foundation
import Charts

class TNXAxisValueFormatter {
    
    let axisTransformer: TNAxisPositionTransformer
    
    init(axisTransformer: TNAxisPositionTransformer) {
        self.axisTransformer = axisTransformer
    }

}

extension TNXAxisValueFormatter: AxisValueFormatter {
   
    /// Called when a value from an axis is formatted before being drawn.
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let timestamp = axisTransformer.timeOf(xValue: value)
        let date = Date(timeIntervalSince1970: timestamp)
        let time = date.toString(format: .custom("HH:mm")) ?? ""
        return time + "\n  _"
    }
    
}
