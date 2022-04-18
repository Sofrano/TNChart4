//
//  IntervalModeType.swift
//  terminal
//
//  Created by Dmitriy Safarov on 13.05.2021.
//

import Foundation

public enum TNIntervalModeType: String, Encodable {
    /// From cache
    case openRay = "OpenRay"
    /// Without cache
    case closedRay = "ClosedRay"
}
