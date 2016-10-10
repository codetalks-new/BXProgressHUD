//
//  BXBarProgressView.swift
//  Pods
//
//  Created by Haizhen Lee on 15/11/6.
//
//

import UIKit


/**
 * A flat bar progress view.
 */
open class BXBarProgressView: BXBaseProgressView{
    /**
     * Bar border line color.
     * Defaults to white [UIColor whiteColor].
     */
    open var lineColor: UIColor = .white{
        didSet{
            setNeedsDisplay()
        }
    }
    
    /**
     * Bar background color.
     * Defaults to clear [UIColor clearColor];
     */
    open var progressRemainingColor: UIColor = .clear{
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    public convenience init(){
        self.init(size:BXProgressOptions.barSize)
    }
    
    public convenience init(size:CGSize){
        self.init(frame:CGRect(origin: CGPoint.zero, size: size))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  
  open override var intrinsicContentSize : CGSize {
    return BXProgressOptions.barSize
  }
    
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        let ctx = UIGraphicsGetCurrentContext()
        let lineWidth = BXProgressOptions.lineWidth
        ctx?.setLineWidth(lineWidth)
        lineColor.setStroke()
        progressRemainingColor.setFill()
        // Draw background
        let radius = (rect.height - lineWidth) * 0.5
        let roundedRect = rect.insetBy(dx: lineWidth, dy: lineWidth)
        let shapePath = UIBezierPath(roundedRect: roundedRect, cornerRadius: radius)
        shapePath.lineWidth = lineWidth
        shapePath.fill()
        shapePath.stroke()
        
        let pradius = radius - lineWidth
        let amount = progress * rect.width
        let isAfterLeftCorner = amount > radius + lineWidth * 2
        let isBeforeRightCorner = amount < rect.width - radius - lineWidth * 2
        let isInMiddleArea = isAfterLeftCorner && isBeforeRightCorner
        if amount <= lineWidth {
            return
        }
        progressColor.setFill()
        if amount >= (rect.width - lineWidth ) {
            shapePath.fill()
            return
        }
        let dx = roundedRect.width * progress
        if isInMiddleArea{
            let progressRoundedRect =   roundedRect.divided(atDistance: dx, from: CGRectEdge.minXEdge).slice
            let roundingCorners :UIRectCorner = [.topLeft,.bottomLeft]
            let progressPath = UIBezierPath(roundedRect: progressRoundedRect, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: pradius, height: pradius))
            progressPath.lineWidth = lineWidth
            progressPath.fill()
        }else if !isAfterLeftCorner {
            let center = CGPoint(x: roundedRect.minX  + radius, y:roundedRect.midY)
            // sin @ = (radius - amount) / (radius)
            let offsetAngle = asin((radius - amount) / radius)
            let startY = radius + radius * cos(offsetAngle)
            let startPoint  = CGPoint(x: amount + lineWidth * 0.5, y: startY)
            
            let startAngle = CGFloat(M_PI_2) + offsetAngle
            let endAngle =  2 * CGFloat(M_PI) - startAngle
            
            let path = UIBezierPath()
            path.move(to: startPoint)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            path.fill()
            
            
        }else if !isBeforeRightCorner {
            let progressRoundedRect =   roundedRect.divided(atDistance: radius, from: CGRectEdge.maxXEdge).remainder
            let roundingCorners :UIRectCorner = [.topLeft,.bottomLeft]
            let progressPath = UIBezierPath(roundedRect: progressRoundedRect, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: pradius, height: pradius))
            progressPath.lineWidth = lineWidth
            progressPath.fill()
            let arcStartX = roundedRect.maxX - radius
            let offsetAngle = asin((amount - arcStartX) / radius)
            let startAngle = CGFloat(M_PI_2) - offsetAngle
            let endAngle = 2 * CGFloat(M_PI) - startAngle
            let startY =  radius + radius * cos(offsetAngle)
            let reminderPath = UIBezierPath()
            let startPoint = CGPoint(x: amount, y: startY)
            let center = CGPoint(x: arcStartX, y:roundedRect.midY)
            reminderPath.move(to: startPoint)
            reminderPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            reminderPath.close()
            //            reminderPath.fill()
            
            let rightArcPath = UIBezierPath()
            rightArcPath.move(to: CGPoint(x: arcStartX, y: roundedRect.maxY))
            rightArcPath.addArc(withCenter: center, radius: radius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat( M_PI * 2 - M_PI_2), clockwise: false)
            rightArcPath.close()
            rightArcPath.append(reminderPath)
            rightArcPath.usesEvenOddFillRule = true
            
            rightArcPath.fill()
        }
        
        
    }
}
