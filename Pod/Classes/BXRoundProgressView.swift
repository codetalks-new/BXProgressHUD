//
//  BXRoundProgressView.swift
//  Pods
//
//  Created by Haizhen Lee on 15/11/6.
//
//

import UIKit

/**
 * A progress view for showing definite progress by filling up a circle (pie chart).
 */
public class BXRoundProgressView : BXBaseProgressView{
    /**
     * Indicator background (non-progress) color.
     * Defaults to translucent white (alpha 0.1)
     */
    public var backgroundTintColor: UIColor = UIColor(white: 1.0, alpha: 0.1){
        didSet{
            setNeedsDisplay()
        }
    }
    
    /*
    * Display mode - NO = round or YES = annular. Defaults to round.
    */
    public var annular: Bool = false{
        didSet{
            setNeedsDisplay()
        }
    }
    
    public convenience init(){
        self.init(size:BXProgressOptions.annularSize)
    }
    
    public convenience init(size:CGFloat){
        self.init(frame:CGRect(origin: CGPointZero, size: CGSize(width: size, height: size)))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clearColor()
        opaque = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let allRect = bounds
        let lineWidth = BXProgressOptions.lineWidth
        let circleRect = allRect.insetBy(dx: lineWidth , dy: lineWidth)
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let startAngle =  CGFloat( M_PI_2 ) // 90 degrees
        
        
        if annular{
            // Draw background
            let processBackgroundPath = UIBezierPath()
            processBackgroundPath.lineWidth = lineWidth
            processBackgroundPath.lineCapStyle = .Butt
            
            let radius = (bounds.width - lineWidth) * 0.5
            let endAngle = CGFloat( M_PI  * 2 ) + startAngle
            processBackgroundPath.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            backgroundTintColor.set()
            processBackgroundPath.stroke()
            
            // Draw progress
            let processPath = UIBezierPath()
            processPath.lineWidth = lineWidth
            processPath.lineCapStyle = .Square
            let endAngle2 = self.progress * 2 * CGFloat(M_PI) + startAngle
            processPath.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle2, clockwise: true)
            progressColor.set()
            processPath.stroke()
            
        }else{
            // Draw background
            progressColor.setStroke()
            backgroundTintColor.setFill()
            
            let circlePath = UIBezierPath(ovalInRect: circleRect)
            circlePath.lineWidth = lineWidth
            circlePath.stroke()
            circlePath.fill()
            
            // Draw progress
            progressColor.setFill()
            let radius = (bounds.width - lineWidth - 2) * 0.5
            let endAngle2 = self.progress * 2 * CGFloat(M_PI) + startAngle
            let path = UIBezierPath()
            path.moveToPoint(center)
            path.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle2, clockwise: true)
            path.closePath()
            path.fill()
            
        }
    }
    
}

