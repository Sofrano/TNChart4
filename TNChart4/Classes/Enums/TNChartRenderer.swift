//
//  ChartRenderer.swift
//  terminal
//
//  Created by Dmitriy Safarov on 19.05.2021.
//

import Foundation

public enum TNChartRenderer {
    case native
    case js
    
    var title: String {
        switch self {
        case .native:
            return "N"
        case .js:
            return "WEB"
        }
    }
    
    var next: TNChartRenderer {
        switch self {
        case .native:
            return .js
        case .js:
            return .native
        }
    }
}
