//
//  NativeChartNativeChartInteractorInput.swift
//  terminal
//
//  Created by Dmitriy Safarov on 22/12/2020.
//  Copyright © 2020 Tradernet. All rights reserved.
//

import Foundation

public protocol NativeChartInteractorInput {
    
    var output: NativeChartInteractorOutput? { get set }
    
    /// Interactor configuration. Used when changing chart parameters
    ///
    /// - parameter ticker: Ticker Name
    /// - parameter chartType: Chart visible time interval
    /// - parameter isDemo: Demo or Real user
    func configure(ticker: String, chartType: TNChartPeriod, isDemo: Bool)
    
    /// Requests a chunk of data for a chart
    func nextPage()
    
    /// Fetching new actual data
    func fetchUpdatedEntries()
    
}
