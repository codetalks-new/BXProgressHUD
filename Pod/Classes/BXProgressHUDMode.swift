//
//  BXProgressHUDMode.swift
//  Pods
//
//  Created by Haizhen Lee on 16/3/4.
//
//

import Foundation

public enum BXProgressHUDMode : Int {
  
  /** Progress is shown using an UIActivityIndicatorView. This is the default. */
  case indeterminate
  /** Progress is shown using a round, pie-chart like, progress view. */
  case determinate
  /** Progress is shown using a horizontal progress bar */
  case determinateHorizontalBar
  /** Progress is shown using a ring-shaped progress view. */
  case annularDeterminate
  /** Shows a custom view */
  case customView
  /** Shows only labels */
  case text
  /** Shows a Checkmark Image */
  case checkmark
}

public extension BXProgressHUDMode{
  public var isOnlyText:Bool{
    return self == BXProgressHUDMode.text
  }
  
  public var isHorizontalBar:Bool{
    return self == .determinateHorizontalBar
  }
  
  public var isCustomView:Bool{
    return self == .customView
  }
}

public typealias BXHUDMode = BXProgressHUDMode
