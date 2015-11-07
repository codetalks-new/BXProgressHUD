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
            hud = BXProgressHUD(view: forView)
            targetView = forView
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
            hud.labelText = text
            return self
        }
        
        public func detailText(text:String) -> Self{
            hud.detailsLabelText = text
            return self
        }
        
        public func customView(view:UIView) -> Self{
            hud.customView = view
            return self
        }
        
        public func color(color:UIColor) -> Self{
            hud.color = color
            return self
        }
        
        
        public func show(animated:Bool = true) -> BXProgressHUD{
            create().show(animated)
            return hud
        }
        
        public func create() -> BXProgressHUD{
            targetView.addSubview(hud)
            return hud
        }
        
        public func delegate(delegate:BXProgressHUDDelegate?) -> Self{
            hud.delegate = delegate
            return self
        }
        
    }
}

