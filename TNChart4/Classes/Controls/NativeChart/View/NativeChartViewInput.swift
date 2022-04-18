//
//  NativeChartNativeChartViewInput.swift
//  terminal
//
//  Created by Dmitriy Safarov on 22/12/2020.
//  Copyright © 2020 Tradernet. All rights reserved.
//

import UIKit

protocol NativeChartViewInput: AnyObject {
    func setupInitialState()
    func setupChartController(_ controller: TNChartControllerable)
    func fixScaleAndPosition()
    func updateLegend(_ value: NSAttributedString)
    func updateLoadingState(isLoading: Bool)
    func showError(text: String)
    func updateChartState(_ state: ChartDataState)
}
