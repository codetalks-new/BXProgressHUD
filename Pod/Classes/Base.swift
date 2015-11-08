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

public struct BXProgressOptions{
    public static var annularSize :CGFloat = 37
    public static var lineWidth : CGFloat = 2.0
    public static var barSize : CGSize = CGSize(width: 120, height: 20)
    public static let labelFontSize  : CGFloat = 14.0
    public static let padding  : CGFloat = 4.0
    public static let detailsLabelFontSize  :CGFloat = 12.0
}

public enum BXProgressHUDMode : Int {
    
    /** Progress is shown using an UIActivityIndicatorView. This is the default. */
    case Indeterminate
    /** Progress is shown using a round, pie-chart like, progress view. */
    case Determinate
    /** Progress is shown using a horizontal progress bar */
    case DeterminateHorizontalBar
    /** Progress is shown using a ring-shaped progress view. */
    case AnnularDeterminate
    /** Shows a custom view */
    case CustomView
    /** Shows only labels */
    case Text
    /** Shows a Checkmark Image */
    case Checkmark
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
