//
//  ChartResources.swift
//  terminal
//
//  Created by Dmitriy Safarov on 13.05.2021.
//

import Foundation
import UIKit

public protocol TNChartImageResourcable {
    var chartTypeBarIcon: UIImage { get }
    var chartTypeCandleIcon: UIImage { get }
    var chartTypeLineIcon: UIImage { get }
    var bulletAttachmentImage: UIImage { get }
    var chartPanelClose: UIImage { get }
}
