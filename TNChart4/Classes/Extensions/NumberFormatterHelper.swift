//
//  NumberFormatterHelper.swift
//  terminal
//
//  Created by Developer333 on 21/07/2020.
//  Copyright © 2020 OlegOsipov333. All rights reserved.
//

import Foundation

class NumberFormatterHelper {
    struct NumberFormatterIdentifier: Hashable {
        let settings: NumberFormatter.Settings
        var queue: String
    }
    
    static let shared = NumberFormatterHelper()
    
    private init() { }
    
    private let queue = DispatchQueue(label: "numberFormatter", qos: .default)
    private var numberFormatters: [NumberFormatterIdentifier: NumberFormatter] = [:]
        
    func get(settings: NumberFormatter.Settings) -> NumberFormatter {
        guard let currentQueue = DispatchQueue.currentLabel else {
            return NumberFormatter(settings: settings)
        }
        
        let identifier = NumberFormatterIdentifier(settings: settings, queue: currentQueue)
        let numberFormatter = queue.sync(execute: { () -> NumberFormatter in
            if let numberFormatter = numberFormatters[identifier] {
                return numberFormatter
            } else {
                let numberFormatter = NumberFormatter(settings: settings)
                numberFormatters[identifier] = numberFormatter
                return numberFormatter
            }
        })
        return numberFormatter
    }
}

extension NumberFormatter {
    struct Settings: Hashable {
        var positivePrefix: String?
        var negativePrefix: String?
        
        var negativeSuffix: String?
        var positiveSuffix: String?
        
        var minimumFractionDigits: Int?
        var maximumFractionDigits: Int? = 12
        
        var decimalSeparator: String? = "."
        var minimumIntegerDigits: Int? = 1
        var groupingSeparator: String? = " "
        var usesGroupingSeparator: Bool?
    }
    
    convenience init(settings: Settings) {
        self.init()
        numberStyle = .decimal
        positivePrefix = settings.positivePrefix ?? positivePrefix
        negativePrefix = settings.negativePrefix ?? negativePrefix
        
        negativeSuffix = settings.negativeSuffix ?? negativeSuffix
        positiveSuffix = settings.positiveSuffix ?? positiveSuffix
        
        minimumFractionDigits = settings.minimumFractionDigits ?? minimumFractionDigits
        maximumFractionDigits = settings.maximumFractionDigits ?? maximumFractionDigits

        decimalSeparator = settings.decimalSeparator ?? decimalSeparator
        minimumIntegerDigits = settings.minimumIntegerDigits ?? minimumIntegerDigits
        groupingSeparator = settings.groupingSeparator ?? groupingSeparator
        usesGroupingSeparator = settings.usesGroupingSeparator ?? usesGroupingSeparator
    }
}
