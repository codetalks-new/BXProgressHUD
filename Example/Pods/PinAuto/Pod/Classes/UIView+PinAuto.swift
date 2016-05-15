//
//  UIView+PinAuto.swift
//  Pods
//
//  Created by Haizhen Lee on 16/1/14.
//
//

import UIKit

// PinAuto Chian Style Method Value Container
public class LayoutConstraintParams{
  public var priority:UILayoutPriority = UILayoutPriorityRequired
  public var relation: NSLayoutRelation = NSLayoutRelation.Equal
  public var firstItemAttribute:NSLayoutAttribute = NSLayoutAttribute.NotAnAttribute
  public var secondItemAttribute:NSLayoutAttribute = NSLayoutAttribute.NotAnAttribute
  public var multiplier:CGFloat = 1.0
  public var constant:CGFloat  = 0
  public let firstItem:UIView
  public var secondItem:AnyObject?
  public var identifier:String? = LayoutConstraintParams.constraintIdentifier
 
  public static let constraintIdentifier = "pin_auto"
  private let attributesOfOpposite: [NSLayoutAttribute] = [.Right,.RightMargin,.Trailing,.TrailingMargin,.Bottom,.BottomMargin]
  
  private var shouldReverseValue:Bool{
    if firstItemAttribute == secondItemAttribute{
      return attributesOfOpposite.contains(firstItemAttribute)
    }
    return false
  }
  
  public init(firstItem:UIView){
    self.firstItem = firstItem
  }
 
  public var required:LayoutConstraintParams{
    priority = UILayoutPriorityRequired
    return self
  }
  
  public func withPriority(value:UILayoutPriority) -> LayoutConstraintParams{
    priority = value
    return self
  }
  

  
  public var withLowPriority:LayoutConstraintParams{
    priority = UILayoutPriorityDefaultLow
    return self
  }
  
  public var withHighPriority:LayoutConstraintParams{
    priority = UILayoutPriorityDefaultHigh
    return self
  }
  
  
  @warn_unused_result
  public func decrPriorityBy(value:UILayoutPriority) -> LayoutConstraintParams{
    priority = priority - value
    return self
  }
  
  
  @warn_unused_result
  public func incrPriorityBy(value:UILayoutPriority) -> LayoutConstraintParams{
    priority = priority - value
    return self
  }
  
  @warn_unused_result
  public func withRelation(relation:NSLayoutRelation){
    self.relation = relation
  }
  
  public var withGteRelation:LayoutConstraintParams{
    self.relation = .GreaterThanOrEqual
    return self
  }
  
  public var withLteRelation:LayoutConstraintParams{
    self.relation =  .LessThanOrEqual
    return self
  }
  
  public var withEqRelation:LayoutConstraintParams{
    self.relation =  .Equal
    return self
  }
  
  @warn_unused_result
  public func to(value:CGFloat) -> LayoutConstraintParams{
    constant = value
    relation = .Equal
    return self
  }
  
  @warn_unused_result
  public func equal(value:CGFloat) -> LayoutConstraintParams{
    constant = value
    relation = .Equal
    return self
  }
  
  @warn_unused_result
  public func equalTo(value:CGFloat) -> LayoutConstraintParams{
    constant = value
    relation = .Equal
    return self
  }
  
  @warn_unused_result
  public func eq(value:CGFloat) -> LayoutConstraintParams{
    constant = value
    relation = .Equal
    return self
  }
  
  @warn_unused_result
  public func lte(value:CGFloat) -> LayoutConstraintParams{
    constant = value
    relation = .LessThanOrEqual
    return self
  }
  
  @warn_unused_result
  public func gte(value:CGFloat) -> LayoutConstraintParams{
    constant = value
    relation = .GreaterThanOrEqual
    return self
  }
  
  @warn_unused_result
  public func to(item:UIView) -> LayoutConstraintParams{
    secondItem = item
    return self
  }
  
  @warn_unused_result
  public func to(item:UILayoutSupport) -> LayoutConstraintParams{
    secondItem = item
    return self
  }
  
  
  @warn_unused_result
  public func equalTo(item:UIView) -> LayoutConstraintParams{
    secondItem = item
    relation = .Equal
    secondItemAttribute = firstItemAttribute
    return self
  }
 
  @warn_unused_result
  public func eqTo(item:UIView) -> LayoutConstraintParams{
    secondItem = item
    relation = .Equal
    secondItemAttribute = firstItemAttribute
    return self
  }
  
  @warn_unused_result
  public func offset(value:CGFloat) -> LayoutConstraintParams{
    constant = value
    return self
  }
  
  
  @warn_unused_result
  public func lteTo(item:UIView) -> LayoutConstraintParams{
    secondItem = item
    relation = .LessThanOrEqual
    secondItemAttribute = firstItemAttribute
    return self
  }
  
  
  @warn_unused_result
  public func gteTo(item:UIView) -> LayoutConstraintParams{
    secondItem = item
    relation = .GreaterThanOrEqual
    secondItemAttribute = firstItemAttribute
    return self
  }

  
  @warn_unused_result
  public func lessThanOrEqualTo(item:UIView) -> LayoutConstraintParams{
    secondItem = item
    relation = .LessThanOrEqual
    secondItemAttribute = firstItemAttribute
    return self
  }
  
  
  @warn_unused_result
  public func greaterThanOrEqualTo(item:UIView) -> LayoutConstraintParams{
    secondItem = item
    relation = .GreaterThanOrEqual
    secondItemAttribute = firstItemAttribute
    return self
  }
 
  @warn_unused_result
  public func identifier(id:String?) -> LayoutConstraintParams{
    self.identifier = id
    return self
  }
  
 
  @warn_unused_result
  public func equalTo(itemAttribute:NSLayoutAttribute,ofView view:UIView) -> LayoutConstraintParams{
    self.secondItem = view
    self.relation = .Equal
    self.secondItemAttribute = itemAttribute
    return self
  }
  
  public var inSuperview: LayoutConstraintParams{
    secondItem = firstItem.superview
    return self
  }
  
  public var toSuperview: LayoutConstraintParams{
    secondItem = firstItem.superview
    return self
  }
  
  public func autoadd() -> NSLayoutConstraint{
    return install()
  }
  
  public func install() -> NSLayoutConstraint{
    let finalConstanValue  = shouldReverseValue ? -constant : constant
    let constraint = NSLayoutConstraint(item: firstItem,
      attribute: firstItemAttribute,
      relatedBy: relation,
      toItem: secondItem,
      attribute: secondItemAttribute,
      multiplier: multiplier,
      constant: finalConstanValue)
    constraint.identifier = identifier
    firstItem.translatesAutoresizingMaskIntoConstraints = false
    
    if let secondItem = secondItem{
      firstItem.assertHasSuperview()
      let containerView:UIView
      if let secondItemView = secondItem as? UIView{
        if firstItem.superview == secondItemView{
          containerView = secondItemView
        }else if firstItem.superview == secondItemView.superview{
          containerView = firstItem.superview!
        }else{
          fatalError("Second Item Should be First Item 's superview or sibling view")
        }
      }else if secondItem is UILayoutSupport{
        containerView = firstItem.superview!
      }else{
        fatalError("Second Item Should be UIView or UILayoutSupport")
      }
      containerView.addConstraint(constraint)
    }else{
      firstItem.addConstraint(constraint)
    }
    
    return constraint
  }
  
  
}

// PinAuto Core Method
public extension UIView{
  
  private var pa_makeConstraint:LayoutConstraintParams{
    assertHasSuperview()
    return LayoutConstraintParams(firstItem: self)
  }
  
  public var pa_width:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.firstItemAttribute = .Width
    pa.secondItem = nil
    pa.secondItemAttribute = .NotAnAttribute
    return pa
  }
  
  public var pa_height:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.firstItemAttribute = .Height
    pa.secondItem = nil
    pa.secondItemAttribute = .NotAnAttribute
    return pa
  }
 
  
  @warn_unused_result
  @available(*,introduced=1.2)
  public func pa_aspectRatio(ratio:CGFloat) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.firstItemAttribute = .Height
    pa.secondItemAttribute = .Width
    pa.secondItem = self
    pa.multiplier = ratio // height = width * ratio
    // ratio = width:height
    return pa
  }
  
  public var pa_leading:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.firstItemAttribute = .Leading
    pa.secondItem = superview
    pa.secondItemAttribute = .Leading
    return pa
  }
  
  public var pa_trailing:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .Trailing
    pa.secondItemAttribute = .Trailing
    return pa
  }
  
  public var pa_top:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .Top
    pa.secondItemAttribute = .Top
    return pa
  }
  
  public var pa_bottom:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .Bottom
    pa.secondItemAttribute = .Bottom
    return pa
  }
  
  public var pa_centerX:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .CenterX
    pa.secondItemAttribute = .CenterX
    return pa
  }
  
  public var pa_centerY:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .CenterY
    pa.secondItemAttribute = .CenterY
    return pa
  }
  
  public var pa_left:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .Left
    pa.secondItemAttribute = .Left
    return pa
  }
  
  public var pa_right:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .Right
    pa.secondItemAttribute  = .Right
    return pa
  }
  
  public var pa_leadingMargin:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .LeadingMargin
    pa.secondItemAttribute = .LeadingMargin
    
    return pa
  }
  
  public var pa_trailingMargin:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .TrailingMargin
    pa.secondItemAttribute = .TrailingMargin
    return pa
  }
  
  public var pa_topMargin:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .TopMargin
    pa.secondItemAttribute = .TopMargin
    return pa
  }
  
  public var pa_bottomMargin:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .BottomMargin
    pa.secondItemAttribute = .BottomMargin
    return pa
  }
  
  public var pa_leftMargin:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .LeftMargin
    pa.secondItemAttribute = .LeadingMargin
    return pa
  }
  
  public var pa_rightMargin:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .RightMargin
    pa.secondItemAttribute = .RightMargin
    return pa
  }
  
  public var pa_centerXWithinMargins:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .CenterXWithinMargins
    pa.secondItemAttribute = .CenterXWithinMargins
    return pa
  }
  
  public var pa_centerYWithinMargins:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .CenterYWithinMargins
    pa.secondItemAttribute = .CenterYWithinMargins
    return pa
  }
  
  public var pa_baseline:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.firstItemAttribute = .Baseline
    return pa
  }
  
  public var pa_firstBaseline:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.firstItemAttribute = .FirstBaseline
    return pa
  }
  
  public var pa_lastBaseline:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.firstItemAttribute =  NSLayoutAttribute.LastBaseline
    return pa
  }
  
  @warn_unused_result
  public func pa_below(item:UILayoutSupport,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .Top
    pa.relation = .Equal
    pa.secondItemAttribute = .Bottom
    pa.constant = offset
    return pa
  }
  
  @warn_unused_result
  public func pa_below(item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .Top
    pa.relation = .Equal
    pa.secondItemAttribute = .Bottom
    pa.constant = offset
    return pa
  }
  
  @warn_unused_result
  public func pa_above(item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .Bottom
    pa.relation = .Equal
    pa.secondItemAttribute = .Top
    pa.constant = -offset
    return pa
  }
  
  @warn_unused_result
  public func pa_above(item:UILayoutSupport,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .Bottom
    pa.relation = .Equal
    pa.secondItemAttribute = .Top
    pa.constant = -offset
    return pa
  }
  
  @warn_unused_result
  public func pa_toLeadingOf(item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .Trailing
    pa.relation = .Equal
    pa.secondItemAttribute = .Leading
    pa.constant = -offset
    return pa
  }
  
  @warn_unused_result
  public func pa_before(item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .Trailing
    pa.relation = .Equal
    pa.secondItemAttribute = .Leading
    pa.constant = -offset
    return pa
  }
  
  @warn_unused_result
  public func pa_toLeftOf(item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .Right
    pa.relation = .Equal
    pa.secondItemAttribute = .Left
    pa.constant = -offset
    return pa
  }
  
  
  
  @warn_unused_result
  public func pa_toTrailingOf(item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .Leading
    pa.relation = .Equal
    pa.secondItemAttribute = .Trailing
    pa.constant = offset
    return pa
  }
  
  @warn_unused_result
  public func pa_after(item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .Leading
    pa.relation = .Equal
    pa.secondItemAttribute = .Trailing
    pa.constant = offset
    return pa
  }
  
  @warn_unused_result
  public func pa_toRightOf(item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .Left
    pa.relation = .Equal
    pa.secondItemAttribute = .Right
    pa.constant = offset
    return pa
  }

  
}