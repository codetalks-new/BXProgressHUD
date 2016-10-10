//
//  BXBaseProgressView.swift
//  Pods
//
//  Created by Haizhen Lee on 15/11/6.
//
//

import UIKit

open class BXBaseProgressView:UIView{
    /**
     * Progress (0.0 to 1.0)
     */
    open var progress: CGFloat = 0.0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    /**
     * progress color.
     * Defaults to white [UIColor whiteColor].
     */
    open var progressColor: UIColor = .white{
        didSet{
            setNeedsDisplay()
        }
    }
    
    open override var intrinsicContentSize : CGSize {
        return frame.size
    }
}





public enum BXProgressHUDAnimation : Int {
    
    /** Opacity animation */
    case fade
    /** Opacity + scale animation */
    case zoom
    /** Opacity + scale animation */
    public static var ZoomOut: BXProgressHUDAnimation {
        return .zoom
    }
    /** Opacity + scale animation */
    case zoomIn
}

public typealias BXProgressHUDCompletionBlock = () -> Void

public protocol BXProgressHUDDelegate : NSObjectProtocol {
    
    /**
     * Called after the HUD was fully hidden from the screen.
     */
    func hudWasHidden(_ hud:BXProgressHUD)
}
