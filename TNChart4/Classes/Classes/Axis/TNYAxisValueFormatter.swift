//
//  YAxisValueFormatter.swift
//  terminal
//
//  Created by Dmitriy Safarov on 02.02.2021.
//

import Foundation
import Charts

class TNYAxisValueFormatter: AxisValueFormatter {
    
    let numberFormatter = NumberFormatter()
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return value.string(params: [.round(fractionDigits: 3)])
    }
    
}
