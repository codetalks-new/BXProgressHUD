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
open class BXRoundProgressView : BXBaseProgressView{
    /**
     * Indicator background (non-progress) color.
     * Defaults to translucent white (alpha 0.1)
     */
    open var backgroundTintColor: UIColor = UIColor(white: 1.0, alpha: 0.1){
        didSet{
            setNeedsDisplay()
        }
    }
    
    /*
    * Display mode - NO = round or YES = annular. Defaults to round.
    */
    open var annular: Bool = false{
        didSet{
            setNeedsDisplay()
        }
    }
    
    public convenience init(){
        self.init(size:BXProgressOptions.annularSize)
    }
    
    public convenience init(size:CGFloat){
        self.init(frame:CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size)))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
    }
  
    open override var intrinsicContentSize : CGSize {
      let size =  BXProgressOptions.annularSize
      return CGSize(width: size, height: size)
    }
  
  
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        let allRect = bounds
        let lineWidth = BXProgressOptions.lineWidth
        let circleRect = allRect.insetBy(dx: lineWidth , dy: lineWidth)
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let startAngle =  CGFloat( M_PI_2 ) // 90 degrees
        
        
        if annular{
            // Draw background
            let processBackgroundPath = UIBezierPath()
            processBackgroundPath.lineWidth = lineWidth
            processBackgroundPath.lineCapStyle = .butt
            
            let radius = (bounds.width - lineWidth) * 0.5
            let endAngle = CGFloat( M_PI  * 2 ) + startAngle
            processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            backgroundTintColor.set()
            processBackgroundPath.stroke()
            
            // Draw progress
            let processPath = UIBezierPath()
            processPath.lineWidth = lineWidth
            processPath.lineCapStyle = .square
            let endAngle2 = self.progress * 2 * CGFloat(M_PI) + startAngle
            processPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle2, clockwise: true)
            progressColor.set()
            processPath.stroke()
            
        }else{
            // Draw background
            progressColor.setStroke()
            backgroundTintColor.setFill()
            
            let circlePath = UIBezierPath(ovalIn: circleRect)
            circlePath.lineWidth = lineWidth
            circlePath.stroke()
            circlePath.fill()
            
            // Draw progress
            progressColor.setFill()
            let radius = (bounds.width - lineWidth - 2) * 0.5
            let endAngle2 = self.progress * 2 * CGFloat(M_PI) + startAngle
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle2, clockwise: true)
            path.close()
            path.fill()
            
        }
    }
    
}

