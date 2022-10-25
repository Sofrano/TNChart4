//
//  TNChartLocalized.swift
//  TNChart
//
//  Created by Dmitriy Safarov on 19.05.2021.
//

import Foundation

public protocol TNChartLocalized {
    var globalEmpty: String { get }
    var emptyListError: String { get }
    var chartPeriodDay: String { get }
    var chartPeriodMonth: String { get }
    var chartPeriodHalfYear: String { get }
    var chartPeriodYear: String { get }  
}
