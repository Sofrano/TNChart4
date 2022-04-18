//
//  SheetControlSettings.swift
//  TNChart
//
//  Created by Dmitriy Safarov on 21.05.2021.
//

import Foundation
import UIKit

public struct SheetControllerSettings {
    
    /** Struct that contains properties to configure the animation when presenting the action controller */
    public struct PresentAnimationStyle {
        /**
         * A float value that is used as damping for the animation block. Its default value is `1.0`.
         * @see: animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
         */
        public var damping = CGFloat(1.0)
        /**
         * A float value that is used as delay for the animation block. Its default value is `0.0`.
         * @see: animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
         */
        public var delay = TimeInterval(0.0)
        /**
         * A float value that determines the animation duration. Its default value is `0.7`.
         * @see: animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
         */
        public var duration = TimeInterval(0.7)
        /**
         * A float value that is used as `springVelocity` for the animation block. Its default value is `0.0`.
         * @see: animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
         */
        public var springVelocity = CGFloat(0.0)
        /**
         * A mask of options indicating how you want to perform the animations. Its default value is `UIViewAnimationOptions.CurveEaseOut`.
         * @see: animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
         */
        public var options = UIView.AnimationOptions.curveEaseIn
    }
    
    /** Struct that contains properties to configure the animation when dismissing the action controller */
    public struct DismissAnimationStyle {
        /**
         * A float value that is used as damping for the animation block. Its default value is `1.0`.
         * @see: animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
         */
        public var damping = CGFloat(1.0)
        /**
         * A float value that is used as delay for the animation block. Its default value is `0.0`.
         * @see: animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
         */
        public var delay = TimeInterval(0.0)
        /**
         * A float value that determines the animation duration. Its default value is `0.7`.
         * @see: animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
         */
        public var duration = TimeInterval(0.7)
        /**
         * A float value that is used as `springVelocity` for the animation block. Its default value is `0.0`.
         * @see: animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
         */
        public var springVelocity = CGFloat(0.0)
        /**
         * A mask of options indicating how you want to perform the animations. Its default value is `UIViewAnimationOptions.CurveEaseIn`.
         * @see: animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
         */
        public var options = UIView.AnimationOptions.curveEaseIn
        /**
         * A float value that makes the action controller's to be animated until the bottomof the screen plus this value.
         */
        public var offset = CGFloat(0)
    }
    
    /** Struct that contains all properties related to presentation & dismissal animations */
    public struct AnimationStyle {
        /**
         * A size value that is used to scale the presenting view controller when the action controller is being
         * presented. If `nil` is set, then the presenting view controller won't be scaled. Its default value is
         * `(1.0, 1.0)`.
         */
        public var scale: CGSize? = CGSize(width: 1.0, height: 1.0)
        /** Stores presentation animation properties */
        public var present = PresentAnimationStyle()
        /** Stores dismissal animation properties */
        public var dismiss = DismissAnimationStyle()
    }
    
    /** Stores the animations' properties values */
    public var animation = AnimationStyle()
    
    /**
     * Create the default settings
     * @return The default value for settings
     */
    public static func defaultSettings() -> SheetControllerSettings {
        return SheetControllerSettings()
    }
}
