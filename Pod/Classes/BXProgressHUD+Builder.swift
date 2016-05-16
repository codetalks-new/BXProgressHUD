//
//  BXProgressHUD+Builder.swift
//  Pods
//
//  Created by Haizhen Lee on 15/11/7.
//
//

import Foundation

public extension BXProgressHUD{
    
    public class Builder {
        let hud:BXProgressHUD
        let targetView:UIView
        public init(forView:UIView){
            hud = BXProgressHUD()
            targetView = forView
        }
        
        public convenience init(){
            let window = UIApplication.sharedApplication().keyWindow!
            self.init(forView:window)
        }
        
        public func mode(mode:BXProgressHUDMode) -> Self{
            hud.mode = mode
            return self
        }
        
        public func usingTextMode() -> Self{
           return mode(.Text)
        }
        
        public func animationType(type:BXProgressHUDAnimation) -> Self{
            hud.animationType = type
            return self
        }
        
        public func dimBackground(dimBackground:Bool) -> Self{
            hud.dimBackground = dimBackground
            return self
        }
        
        
        public func text(text:String) -> Self{
            hud.label.text = text
            return self
        }
        
        public func textColor(color:UIColor) -> Self{
            hud.label.textColor = color
            return self
        }
        
        public func detailText(text:String) -> Self{
            hud.detailsLabel.text = text
            return self
        }
        
        public func detailColor(color:UIColor) -> Self{
            hud.detailsLabel.textColor = color
            return self
        }
        
        
        public func customView(view:UIView) -> Self{
            hud.customView = view
            return self
        }
        
        
        public func removeFromSuperViewOnHide(remove:Bool) -> Self{
            hud.removeFromSuperViewOnHide = remove
            return self
        }
        
        
        public func margin(margin:CGFloat) -> Self{
            hud.margin = margin
            return self
        }
        
        public func cornerRadius(radius:CGFloat) -> Self{
            hud.cornerRadius = radius
            return self
        }
        
        public func xOffset(offset:CGFloat) -> Self{
            hud.xOffset = offset
            return self
        }
        
        
        public func yOffset(offset:CGFloat) -> Self{
            hud.yOffset = offset
            return self
        }
        
        public func graceTime(time:NSTimeInterval) -> Self{
            hud.graceTime = time
            return self
        }
        
        public func minShowTime(time:NSTimeInterval) -> Self{
            hud.minShowTime = time
            return self
        }
        
        public func show(animated:Bool = true) -> BXProgressHUD{
            create().show(animated)
            return hud
        }
        
        public func create() -> BXProgressHUD{
            hud.attachTo(targetView)
            return hud
        }
        
        public func delegate(delegate:BXProgressHUDDelegate?) -> Self{
            hud.delegate = delegate
            return self
        }
        
    }
}

