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
  
  private static var window:UIWindow{
    return UIApplication.sharedApplication().keyWindow!
  }
  
  public static func showProgress(label:String="") -> BXProgressHUD{
    let hud:BXProgressHUD
    if let existsHUD = BXProgressHUD.HUDForView(window){
      hud = existsHUD
    }else{
      hud = BXProgressHUD.Builder(forView: window).text(label).removeFromSuperViewOnHide(false).show()
    }
    hud.labelText = label
    hud.removeFromSuperViewOnHide = false
    hud.mode = .Indeterminate
    hud.show(false)
    return hud
  }
  
  public static func hideProgress(result:BXResult){
    guard let hud = BXProgressHUD.HUDForView(window) else{
      return
    }
    if result.bx_ok{
      hud.mode = .Checkmark
      hud.hide(afterDelay: 0.5)
    }else{
      hud.mode = .Text
      hud.labelColor = errorColor
      hud.labelText = result.bx_message
      hud.hide(afterDelay: 1.5)
    }
  }
  
  public static func hideProgress(label:String=""){
    guard let hud = BXProgressHUD.HUDForView(window) else{
      return
    }
    if !label.isEmpty{
      hud.labelText = label
      hud.hide(afterDelay: 1.5)
    }else{
      hud.hide()
    }
  }
  
  public static var ProgressBuilder:BXProgressHUD.Builder{
    return BXProgressHUD.Builder(forView: window)
  }
  
  public static func showToast(label:String){
    ProgressBuilder.text(label).mode(.Text).show().hide(afterDelay: 1)
  }
  
  public static func showErrorTip(label:String,detail:String=""){
    ProgressBuilder.mode(.Text).text(label).textColor(errorColor).detailText(detail).show().hide(afterDelay: 2)
  }
}
