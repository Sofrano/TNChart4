//
//  EnumSegmentedControlAppearancable.swift
//  TNChart4
//
//  Created by Dmitriy Safarov on 20.10.2022.
//

import Foundation

public protocol EnumSegmentedControlAppearancable {
    var buttonBorderColor: UIColor { get }
    var buttonDividerColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
    var buttonTitleSelectedColor: UIColor { get }
    var buttonFont: UIFont { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonSelectedBackgroundColor: UIColor { get }
}
