//
//  BXHUD.swift
//  Pods
//
//  Created by Haizhen Lee on 15/11/21.
//
//

import UIKit

public protocol BXResult{
  var bx_ok:Bool { get }
  var bx_message:String { get }
}

public struct BXHUD{
  public static var errorColor : UIColor = UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 1.0)
  
  private static var window:UIWindow?{
    if let win =  UIApplication.sharedApplication().delegate?.window{
      return win
    }
    return nil
  }
  
  public static func showProgress(label:String="") -> BXProgressHUD{
    let hud = globalHUD()
    guard let window = window else{
      return hud
    }
    window.bringSubviewToFront(hud)
    hud.label.text = label
    hud.label.textColor = .whiteColor()
    hud.graceTime = 0
    hud.removeFromSuperViewOnHide = false
    hud.mode = .Indeterminate
    hud.show(false)
    return hud
  }
  
  public static func globalHUD() -> BXProgressHUD{
    guard let window = window else{
      // 此 HUD 将不会显示，并且使用之后马上被内存回收，所以没什么坏的影响
      return BXProgressHUD()
    }
    let hud:BXProgressHUD
    if let existsHUD = BXProgressHUD.HUDForView(window){
      hud = existsHUD
    }else{
      hud = BXProgressHUD.Builder(forView: window).removeFromSuperViewOnHide(false).create()
    }
    return hud
  }
  
  
  public static func hideSuccess(text:String = ""){
    guard let window = window else{
      return
    }
    let hud = globalHUD()
    window.bringSubviewToFront(hud)
    hud.label.text = text
    hud.mode = .Checkmark
    hud.hide(afterDelay: 0.5)
  }
  
  public static func hideProgress(label:String=""){
    guard let window = window else{
      return
    }
    let hud = globalHUD()
    window.bringSubviewToFront(hud)
    if !label.isEmpty{
      hud.label.text = label
      hud.hide(afterDelay: 1.5)
    }else{
      hud.hide()
    }
  }
  
  public static func showToast(label:String){
    guard let window = window else{
      return
    }
    let hud = globalHUD()
    window.bringSubviewToFront(hud)
    hud.label.text = label
    hud.mode = .Text
    hud.graceTime = 0
    hud.show()
    hud.hide(afterDelay: 1)
  }
  
  public static func showErrorTip(label:String,detail:String=""){
    guard let window = window else{
      return
    }
    let hud = globalHUD()
    window.bringSubviewToFront(hud)
    hud.mode = .Text
    hud.graceTime = 0
    hud.label.textColor = errorColor
    hud.label.text = label
    hud.detailsLabel.text = detail
    hud.show()
    hud.hide(afterDelay: 1.0)
  }

}
