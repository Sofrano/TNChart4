//
//  NativeChartNativeChartModuleInput.swift
//  terminal
//
//  Created by Dmitriy Safarov on 22/12/2020.
//  Copyright © 2020 Tradernet. All rights reserved.
//

public protocol NativeChartModuleInput: AnyObject {
    func configure(withTicker: String?, isDemo: Bool)
    func forceReload()
}
