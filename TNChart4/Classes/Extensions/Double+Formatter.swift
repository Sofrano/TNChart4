//
//  Double.swift
//  terminal
//
//  Created by Oleg Osipov on 11/02/2019.
//  Copyright © 2019 OlegOsipov333. All rights reserved.
// #1

import Foundation
import UIKit

/// Format Double
extension Optional where Wrapped == Double {

    /// Unwrap optional to String(self).stringValue
    var stringValue: String {
        guard let self = self else { return "" }
        return String(self)
    }

    /// Unwrap optional to self.doubleValue
    var doubleValue: Double {
        return (self ?? 0.0)
    }

    /// Format Double.
    /// Nil = '-' ("global.empty".localized())
    func string(params: [NumberFormatterParams] = []) -> String {
        // 'nil'  =>  '-'
        guard let self = self else {
            for param in params {
                switch param {
                case .emptyZero:
                    return ""
                default:
                    break
                }
            }
            return TNChartConfiguration.localized.globalEmpty
        }
        return (self + 0.0).string(params: params)
    }
    
    func abs() -> Double? {
        guard let self = self else {
            return nil
        }
        return Swift.abs(self)
    }
}

/// Format Double
extension Optional where Wrapped == CGFloat {
    /// Unwrap optional to self.doubleValue
    var cgFloatValue: CGFloat {
        return (self ?? 0.0)
    }
}

/// Number formatter parameters
enum NumberFormatterParams {
    /// Always show plus sign
    case showPlus

    /// Always show percent sign
    case showPercent

    /// Set maximum fraction digits number
    case round(fractionDigits: Int)

    /// Set minimum fraction digits number
    case minimumFraction(_ fractionDigits: Int)

    /// Round to minimal value step
    case roundTo(step: Double?)

    /// Separate every 3 digits with spacer
    case separateGroups

    /// Return empty string when value equals zero
    case emptyZero

    struct Preset {
        static let changePercent: [NumberFormatterParams] = [.round(fractionDigits: 2), .minimumFraction( 2), .showPercent, .showPlus]
    }
}

extension Double {

    /// Format double number to string with params
    func string(params: [NumberFormatterParams] = []) -> String {
        var value: Double = self + 0.0

        // Should formatter separate every 3 decimal digits with spacer
        var shouldSeparateDecGroups = false
        
        var settings = NumberFormatter.Settings()
        
        // Proceed params
        for param in params {
            switch param {

            case .showPlus:
                // Always show plus sign
                if self != 0 {
                    settings.positivePrefix = "+"
                }

            case .showPercent:
                // Always show percent sign
                settings.negativeSuffix = "%"
                settings.positiveSuffix = "%"

            case .round(let fractionDigits):
                // Set maximum fraction digits number
                settings.maximumFractionDigits = fractionDigits

            case .minimumFraction(let fractionDigits):
                // Set minimum fraction digits number
                settings.minimumFractionDigits = fractionDigits

            case .roundTo(let step):
                // Round to minimal value step
                if let step = step {
                    var step = step
                    var significantFractionalDigitsNumber = step.significantFractionalDigitsNumber
                    if significantFractionalDigitsNumber > 12 {
                        step = step.round(nearest: 0.0000000000001)
                        significantFractionalDigitsNumber = step.significantFractionalDigitsNumber
                    }
                    value = value.round(nearest: step)
                    settings.minimumFractionDigits = significantFractionalDigitsNumber
                    settings.maximumFractionDigits = significantFractionalDigitsNumber
                } else {
                    var significantFractionalDigitsNumber = value.significantFractionalDigitsNumber
                    if significantFractionalDigitsNumber > 12 {
                        value = value.round(nearest: 0.0000000000001)
                        significantFractionalDigitsNumber = value.significantFractionalDigitsNumber
                    }
                    settings.minimumFractionDigits = significantFractionalDigitsNumber
                    settings.maximumFractionDigits = significantFractionalDigitsNumber
                }

            case .separateGroups:
                // Formatter should separate every 3 decimal digits with spacer
                shouldSeparateDecGroups = true

            case .emptyZero:
                // Return empty string if value equals zero
                if value == 0 {
                    return ""
                }
            }
        }

        // Separate every 3 decimal digits with spacer
        let formatter = NumberFormatterHelper.shared.get(settings: settings)
        if let formatted = formatter.string(from: value as NSNumber) {
            // Separate decimals
            if shouldSeparateDecGroups {
                var components = formatted.components(separatedBy: ".")
                if components.count > 1 {
                    components[1].insert(separator: " ", every: 3)
                    // separated decimals
                    return components[0] + "." + components[1]
                }
                // No decimals in double
                return components[0] + ""
            }
            // no decimal separation
            return formatted + ""
        }

        // Formatting failed
        return String(value) + ""
    }

    /// Round to nearest value
    func round(nearest: Double) -> Double {
        guard nearest != 0.0 else {
            return self
        }
        let step = 1 / nearest
        let numberToRound = self * step
        return numberToRound.rounded() / step
    }
}

extension Double {
    func round(nearest: Double?) -> Double {
        guard let nearest = nearest else {
            return self
        }
        return self.round(nearest: nearest)
    }
    /// Number of fraction digits
    var significantFractionalDigitsNumber: Int {
        guard let decimal = Decimal(string: String(self)) else {
            return 0
        }
        return max(-decimal.exponent, 0)
    }

    func round(maximumFractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(maximumFractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }

    func round(maximumFractionDigitsFrom number: Double) -> Double {
        let maximumFractionDigits = number.significantFractionalDigitsNumber
        return self.round(maximumFractionDigits: maximumFractionDigits)
    }
}
