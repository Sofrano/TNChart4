//
//  Configuration.swift
//  terminal
//
//  Created by Dmitriy Safarov on 13.05.2021.
//

import Foundation

public class TNChartConfiguration {
    
    static var imageResources: TNChartImageResourcable!
    static var chartAppearance: TNChartAppearancable!
    static var localized: TNChartLocalized!
    static var systemLang: String!
    
    public static func configure(imageResources: TNChartImageResourcable,
                                 chartAppearance: TNChartAppearancable,
                                 localizedStrings: TNChartLocalized,
                                 systemLang: String) {
        self.imageResources = imageResources
        self.chartAppearance = chartAppearance
        self.localized = localizedStrings
        self.systemLang = systemLang
    }
    
    public static func configure(systemLang: String) {
        self.systemLang = systemLang
    }

}
