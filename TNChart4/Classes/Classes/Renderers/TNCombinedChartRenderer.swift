//
//  TNCombinedChartRenderer.swift
//  terminal
//
//  Created by Dmitriy Safarov on 21.12.2020.
//

import Foundation
import UIKit
import Charts

/// A custom CombinedChartRenderer that works with two displayable data types that are tied to each other.
///
/// Support Chart Types:
/// - TNBarChartRenderer
/// - TNCandleCandleStickChartRenderer
class TNCombinedChartRenderer: CombinedChartRenderer {
    
    var combinedRenderers = [DataRenderer]()
    
    override init(chart: CombinedChartView, animator: Animator, viewPortHandler: ViewPortHandler) {
        super.init(chart: chart, animator: animator, viewPortHandler: viewPortHandler)
        createRenderers()
    }
    
    // We create our own renders that process information for the graph
    override func createRenderers() {
        guard let chart = chart else { return }
        combinedRenderers = [DataRenderer]()
        combinedRenderers.append(TNBarChartRenderer(dataProvider: chart, animator: animator, viewPortHandler: viewPortHandler))
        combinedRenderers.append(TNCandleStickChartRenderer(dataProvider: chart, animator: animator, viewPortHandler: viewPortHandler))
        combinedRenderers.append(TNLineChartRenderer(dataProvider: chart, animator: animator, viewPortHandler: viewPortHandler))
        subRenderers = combinedRenderers
    }
    
    /// Draws all highlight indicators for the values that are currently highlighted.
    ///
    /// - Parameters:
    ///   - indices: the highlighted values
    override func drawHighlighted(context: CGContext, indices: [Highlight]) {
        for renderer in combinedRenderers {
            var data: ChartData?
            switch renderer {
            case is TNBarChartRenderer:
                data = (renderer as? TNBarChartRenderer)?.dataProvider?.barData
            case is TNCandleStickChartRenderer:
                data = (renderer as? TNCandleStickChartRenderer)?.dataProvider?.candleData
            case is TNLineChartRenderer:
                data = (renderer as? TNLineChartRenderer)?.dataProvider?.lineData
            default: break
            }
            
            guard data?.dataSets.first?.visible == true else {
                continue
            }
            renderer.drawHighlighted(context: context, indices: indices)
        }
    }
    
    /// Draw data
    override func drawData(context: CGContext) {
        // Didn't find the reason, but I have to inject custom renders
        subRenderers = combinedRenderers
        super.drawData(context: context)
    }
    
}
