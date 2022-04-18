//
//  XAxisController.swift
//  terminal
//
//  Created by Dmitriy Safarov on 13.01.2021.
//

import Foundation

// Transforms the time into the X-axis and vice versa, taking into
// account the data gluing for the correct display of the chart
class TNAxisPositionTransformer {
    
    /// Map of associations between x-axis coordinate and time
    private var timeAtPositionDict: [Double: TimeInterval] = [:]
    private var positionAtTimeDict: [TimeInterval: Double] = [:]
    
    /// Used for gluing and converting to position
    private var startingIndex: Double = 0.0
    private var lowestIndex: Double = 0.0
    private var highestIndex: Double = 0.0
    private var lowestOffset: Double = 0.0
    private var highestOffset: Double = 0.0
    
    /// Time by x-axis coordinate
    ///
    /// - parameter xValue: X-Axis coordinate
    /// - returns: Time located in coordinate
    func timeOf(xValue: Double) -> TimeInterval {
        return timeAtPositionDict[xValue] ?? 0
    }
    
    /// Transforms time to x-axis coordinate
    /// 
    /// - parameter timeInterval: Time  to be transformed into coordinate
    /// - returns: X-Axis coordinate
    func transformToXValue(timeInterval: TimeInterval) -> Double {
        // if there is already a calculation, then we take the calculated
        guard positionAtTimeDict[timeInterval] == nil else {
            return positionAtTimeDict[timeInterval] ?? 0
        }
        
        let rawX = timeInterval
        // If this is the first coordinate, then we take it as a reference point
        guard !positionAtTimeDict.isEmpty else {
            startingIndex = rawX
            lowestIndex = rawX
            highestIndex = rawX
            positionAtTimeDict[timeInterval] = rawX
            timeAtPositionDict[rawX] = timeInterval
            return startingIndex
        }
        
        // We calculate the x coordinate in time.
        // Additionally, data is glued for those dates where there were breaks in the markets
        var absoluteX = startingIndex + ((rawX - startingIndex) / (60 * 15))
        var newIndex = 0.0
        if absoluteX > startingIndex {
            absoluteX -= highestOffset
            let dIndex = abs(highestIndex - absoluteX)
            if dIndex > 1 {
                highestOffset += dIndex
                absoluteX = highestIndex + 1
            }
            newIndex = Double(Int(absoluteX))
            if highestIndex < absoluteX { highestIndex = absoluteX }
            positionAtTimeDict[timeInterval] = newIndex
            timeAtPositionDict[newIndex] = timeInterval
        } else {
            absoluteX += lowestOffset
            let dIndex = abs(lowestIndex - absoluteX)
            if dIndex > 1 {
                lowestOffset -= dIndex
                absoluteX = lowestIndex - 1
            }
            
            newIndex = Double(Int(absoluteX))
            
            if lowestIndex > absoluteX { lowestIndex = absoluteX }
            if highestIndex < absoluteX { highestIndex = absoluteX }
            
            positionAtTimeDict[timeInterval] = newIndex
            timeAtPositionDict[newIndex] = timeInterval
        }
        return newIndex
    }
    
}
