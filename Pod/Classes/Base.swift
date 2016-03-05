//
//  BXBaseProgressView.swift
//  Pods
//
//  Created by Haizhen Lee on 15/11/6.
//
//

import UIKit

public class BXBaseProgressView:UIView{
    /**
     * Progress (0.0 to 1.0)
     */
    public var progress: CGFloat = 0.0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    /**
     * progress color.
     * Defaults to white [UIColor whiteColor].
     */
    public var progressColor: UIColor = .whiteColor(){
        didSet{
            setNeedsDisplay()
        }
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return frame.size
    }
}





public enum BXProgressHUDAnimation : Int {
    
    /** Opacity animation */
    case Fade
    /** Opacity + scale animation */
    case Zoom
    /** Opacity + scale animation */
    public static var ZoomOut: BXProgressHUDAnimation {
        return .Zoom
    }
    /** Opacity + scale animation */
    case ZoomIn
}

public typealias BXProgressHUDCompletionBlock = () -> Void

public protocol BXProgressHUDDelegate : NSObjectProtocol {
    
    /**
     * Called after the HUD was fully hidden from the screen.
     */
    func hudWasHidden(hud:BXProgressHUD)
}
