//
//  TNMinimizedExtendedPanelAppearancable.swift
//  TNChart4
//
//  Created by Dmitriy Safarov on 20.10.2022.
//

import Foundation

public protocol TNMinimizedExtendedPanelAppearancable {
    var segmentedControl: EnumSegmentedControlAppearancable { get }
    var buttonBorderColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
    var buttonFont: UIFont { get }
    var buttonBackgroundColor: UIColor { get }
}
