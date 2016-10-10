//
//  BXProgressHUD+Builder.swift
//  Pods
//
//  Created by Haizhen Lee on 15/11/7.
//
//

import Foundation

public extension BXProgressHUD{
    
    open class Builder {
        let hud:BXProgressHUD
        let targetView:UIView
        public init(forView:UIView){
            hud = BXProgressHUD()
            targetView = forView
        }
        
        public convenience init(){
            let window = UIApplication.shared.keyWindow!
            self.init(forView:window)
        }
        
        open func mode(_ mode:BXProgressHUDMode) -> Self{
            hud.mode = mode
            return self
        }
        
        open func usingTextMode() -> Self{
           return mode(.text)
        }
        
        open func animationType(_ type:BXProgressHUDAnimation) -> Self{
            hud.animationType = type
            return self
        }
        
        open func dimBackground(_ dimBackground:Bool) -> Self{
            hud.dimBackground = dimBackground
            return self
        }
        
        
        open func text(_ text:String) -> Self{
            hud.label.text = text
            return self
        }
        
        open func textColor(_ color:UIColor) -> Self{
            hud.label.textColor = color
            return self
        }
        
        open func detailText(_ text:String) -> Self{
            hud.detailsLabel.text = text
            return self
        }
        
        open func detailColor(_ color:UIColor) -> Self{
            hud.detailsLabel.textColor = color
            return self
        }
        
        
        open func customView(_ view:UIView) -> Self{
            hud.customView = view
            return self
        }
        
        
        open func removeFromSuperViewOnHide(_ remove:Bool) -> Self{
            hud.removeFromSuperViewOnHide = remove
            return self
        }
        
        
        open func margin(_ margin:CGFloat) -> Self{
            hud.margin = margin
            return self
        }
        
        open func cornerRadius(_ radius:CGFloat) -> Self{
            hud.cornerRadius = radius
            return self
        }
        
        open func xOffset(_ offset:CGFloat) -> Self{
            hud.xOffset = offset
            return self
        }
        
        
        open func yOffset(_ offset:CGFloat) -> Self{
            hud.yOffset = offset
            return self
        }
        
        open func graceTime(_ time:TimeInterval) -> Self{
            hud.graceTime = time
            return self
        }
        
        open func minShowTime(_ time:TimeInterval) -> Self{
            hud.minShowTime = time
            return self
        }
        
        open func show(_ animated:Bool = true) -> BXProgressHUD{
            create().show(animated)
            return hud
        }
        
        open func create() -> BXProgressHUD{
            hud.attachTo(targetView)
            return hud
        }
        
        open func delegate(_ delegate:BXProgressHUDDelegate?) -> Self{
            hud.delegate = delegate
            return self
        }
        
    }
}

