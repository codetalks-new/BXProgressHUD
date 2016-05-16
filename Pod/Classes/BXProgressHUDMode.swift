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

public extension BXProgressHUDMode{
  public var isOnlyText:Bool{
    return self == Text
  }
  
  public var isHorizontalBar:Bool{
    return self == .DeterminateHorizontalBar
  }
  
  public var isCustomView:Bool{
    return self == .CustomView
  }
}

public typealias BXHUDMode = BXProgressHUDMode