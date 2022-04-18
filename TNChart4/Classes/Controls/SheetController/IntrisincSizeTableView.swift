//
//  IntrisincSizeTableView.swift
//  TNChart
//
//  Created by Dmitriy Safarov on 21.05.2021.
//

import Foundation
import UIKit

final class IntrinsicSizeTableView: UITableView {

    public var maxHeight: CGFloat?

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        var height = contentSize.height
        if let maxHeight = maxHeight,
            maxHeight < height {
            height = maxHeight
        }
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
}
