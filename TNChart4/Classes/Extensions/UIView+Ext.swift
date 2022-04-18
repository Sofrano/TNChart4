//
//  UIView+Ext.swift
//  TNChart
//
//  Created by Dmitriy Safarov on 21.05.2021.
//

import Foundation

extension UIView {
    
    /// Rounded corners
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}
