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
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor? = nil) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        if let color = borderColor {
            let borderShape = CAShapeLayer()
            borderShape.path = path.cgPath
            borderShape.strokeColor = color.cgColor
            borderShape.lineWidth = 2.0
            borderShape.fillColor = nil
            layer.addSublayer(borderShape)
        }
    }
    
}

extension UIView {
    final class func animateDefault(
        withDuration duration: TimeInterval = 0.6,
        delay: TimeInterval = 0.0,
        options: UIView.AnimationOptions = [UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.curveEaseIn],
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: completion)
    }
}
