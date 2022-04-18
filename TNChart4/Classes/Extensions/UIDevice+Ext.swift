//
//  UIDevice+Ext.swift
//  TNChart
//
//  Created by Dmitriy Safarov on 21.05.2021.
//

import Foundation

extension UIDeviceOrientation {
    /// Sign of rotation from portrait orientation to current
    var rotationSign: CGFloat {
        switch self {
        case .landscapeLeft:
            return 1.0

        case .landscapeRight:
            return -1.0

        default:
            return -1.0
        }
    }

    /// Sign of rotation from portrait orientation to current
    var rotationSignString: String {
        if self.rotationSign < 0 {
            return "-"
        }
        return ""
    }

    /// Sign of rotation from current to portrait orientation
    var contrRotationSign: CGFloat {
        switch self {
        case .landscapeLeft:
            return -1.0

        case .landscapeRight:
            return 1.0

        default:
            return 1.0
        }
    }

    /// Sign of rotation from current to portrait orientation
    var contrRotationSignString: String {
        if self.contrRotationSign < 0 {
            return "-"
        }
        return ""
    }
}
