//
//  NativeChartNativeChartInteractorOutput.swift
//  terminal
//
//  Created by Dmitriy Safarov on 22/12/2020.
//  Copyright © 2020 Tradernet. All rights reserved.
//

import Foundation

public protocol NativeChartInteractorOutput: class {
    
    func onFetchedChartData(_ chartData: [TNChartData])
    func onError(_ error: NativeChartError)
    
}
