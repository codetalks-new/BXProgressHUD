//
//  BXHUDContainerView.swift
//  Pods
//
//  Created by Haizhen Lee on 16/5/16.
//
//

import Foundation
import UIKit
import PinAuto


class BXHUDContainerView : UIView{
  let mode : BXHUDMode
  let backgroundView:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
  init(mode:BXHUDMode){
    self.mode = mode
    super.init(frame: CGRect.zero)
    commonInit()
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var allOutlets :[UIView]{
    return []
  }
  var allUILabelOutlets :[UILabel]{
    return []
  }
  
  private func commonInit(){
    translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(backgroundView)
    backgroundView.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
    
    for childView in allOutlets{
      addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    installConstaints()
    setupAttrs()
    
    
  }
  
  class override func requiresConstraintBasedLayout() -> Bool{
    return true
  }
  
  func installConstaints(){
  }
  
  func setupAttrs(){
  }
  
  
}

public struct BXHUDOptions{
  public static var padding : CGFloat = 22
}

class BXHUDTextContainerView:BXHUDContainerView{
  let detailsLabel : UILabel // (frame:CGRectZero)
  let titleLabel : UILabel // (frame:CGRectZero)
  
  init(mode: BXHUDMode,titleLabel:UILabel, detailsLabel:UILabel) {
    self.titleLabel = titleLabel
    self.detailsLabel = detailsLabel
    super.init(mode: mode)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var allOutlets :[UIView]{
    return [titleLabel,detailsLabel]
  }
  override var allUILabelOutlets :[UILabel]{
    return [titleLabel,detailsLabel]
  }
  
  override func installConstaints() {
    super.installConstaints()
    let padding = BXHUDOptions.padding
    titleLabel.pa_top.eq(padding).install()
    titleLabel.pa_centerX.install()
    
    detailsLabel.pa_below(titleLabel, offset: 4).install()
    detailsLabel.pa_bottom.eq(padding).install()
    detailsLabel.pa_centerX.install()
  }
  
  override func intrinsicContentSize() -> CGSize {
    let padding = BXHUDOptions.padding
    let titleSize = titleLabel.intrinsicContentSize()
    let detailsSize = detailsLabel.intrinsicContentSize()
    
    let width = max(titleSize.width, detailsSize.width) + padding * 2
    let height = padding + titleSize.height + 4 + detailsSize.height + padding
    
    return CGSize(width: width, height: height)
  }
  
}

class BXHUDIndicatorContainerView:BXHUDContainerView{
  let indicator:UIView
  let titleLabel : UILabel //= UILabel(frame:CGRectZero)
  
  convenience init(){
    self.init(mode:BXHUDMode.Indeterminate,indicator: UIActivityIndicatorView(activityIndicatorStyle: .White),titleLabel: UILabel())
  }
  
  override var allOutlets :[UIView]{
    return [titleLabel,indicator]
  }
  override var allUILabelOutlets :[UILabel]{
    return [titleLabel]
  }
  
  init(mode:BXHUDMode,indicator:UIView,titleLabel:UILabel){
    self.indicator = indicator
    self.titleLabel = titleLabel
    super.init(mode: mode)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func installConstaints() {
    super.installConstaints()
    
    let padding = BXHUDOptions.padding
    indicator.pa_top.eq(padding).install()
    indicator.pa_centerX.install()
    indicator.setContentHuggingPriority(1000, forAxis: .Horizontal)
    
    titleLabel.pa_below(indicator, offset: 8).install()
    titleLabel.pa_bottom.eq(padding).install()
    titleLabel.pa_centerX.install()
    
    titleLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
    
  }
  
  override func intrinsicContentSize() -> CGSize {
    let padding = BXHUDOptions.padding
    let titleSize = titleLabel.intrinsicContentSize()
    let indicatorSize = indicator.intrinsicContentSize()
    
    let width = max(titleSize.width,indicatorSize.width) + padding * 2
    let height = padding + titleSize.height + 8 + indicatorSize.height + padding
    return CGSize(width: width, height: height)
  }
  
}



