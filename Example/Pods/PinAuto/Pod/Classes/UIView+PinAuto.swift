//
//  UIView+PinAuto.swift
//  Pods
//
//  Created by Haizhen Lee on 16/1/14.
//
//

import UIKit

// PinAuto Chian Style Method Value Container
open class LayoutConstraintParams{
  open var priority:UILayoutPriority = UILayoutPriorityRequired
  open var relation: NSLayoutRelation = NSLayoutRelation.equal
  open var firstItemAttribute:NSLayoutAttribute = NSLayoutAttribute.notAnAttribute
  open var secondItemAttribute:NSLayoutAttribute = NSLayoutAttribute.notAnAttribute
  open var multiplier:CGFloat = 1.0
  open var constant:CGFloat  = 0
  open let firstItem:UIView
  open var secondItem:AnyObject?
  open var identifier:String? = LayoutConstraintParams.constraintIdentifier
 
  open static let constraintIdentifier = "pin_auto"
  fileprivate let attributesOfOpposite: [NSLayoutAttribute] = [.right,.rightMargin,.trailing,.trailingMargin,.bottom,.bottomMargin]
  
  fileprivate var shouldReverseValue:Bool{
    if firstItemAttribute == secondItemAttribute{
      return attributesOfOpposite.contains(firstItemAttribute)
    }
    return false
  }
  
  public init(firstItem:UIView){
    self.firstItem = firstItem
  }
 
  open var required:LayoutConstraintParams{
    priority = UILayoutPriorityRequired
    return self
  }
  
  open func withPriority(_ value:UILayoutPriority) -> LayoutConstraintParams{
    priority = value
    return self
  }
  

  
  open var withLowPriority:LayoutConstraintParams{
    priority = UILayoutPriorityDefaultLow
    return self
  }
  
  open var withHighPriority:LayoutConstraintParams{
    priority = UILayoutPriorityDefaultHigh
    return self
  }
  
  
  
  open func decrPriorityBy(_ value:UILayoutPriority) -> LayoutConstraintParams{
    priority = priority - value
    return self
  }
  
  
  
  open func incrPriorityBy(_ value:UILayoutPriority) -> LayoutConstraintParams{
    priority = priority - value
    return self
  }
  
  
  open func withRelation(_ relation:NSLayoutRelation){
    self.relation = relation
  }
  
  open var withGteRelation:LayoutConstraintParams{
    self.relation = .greaterThanOrEqual
    return self
  }
  
  open var withLteRelation:LayoutConstraintParams{
    self.relation =  .lessThanOrEqual
    return self
  }
  
  open var withEqRelation:LayoutConstraintParams{
    self.relation =  .equal
    return self
  }
  
  
  
  open func multiplyBy(_ multiplier:CGFloat) -> LayoutConstraintParams{
    self.multiplier = multiplier
    return self
  }
  
  
  
  open func to(_ value:CGFloat) -> LayoutConstraintParams{
    constant = value
    relation = .equal
    return self
  }
  
  
  open func equal(_ value:CGFloat) -> LayoutConstraintParams{
    constant = value
    relation = .equal
    return self
  }
  
  
  open func equalTo(_ value:CGFloat) -> LayoutConstraintParams{
    constant = value
    relation = .equal
    return self
  }
  
  
  open func eq(_ value:CGFloat) -> LayoutConstraintParams{
    constant = value
    relation = .equal
    return self
  }
  
  
  open func lte(_ value:CGFloat) -> LayoutConstraintParams{
    constant = value
    relation = .lessThanOrEqual
    return self
  }
  
  
  open func gte(_ value:CGFloat) -> LayoutConstraintParams{
    constant = value
    relation = .greaterThanOrEqual
    return self
  }
  
  
  open func to(_ item:UIView) -> LayoutConstraintParams{
    secondItem = item
    return self
  }
  
  
  open func to(_ item:UILayoutSupport) -> LayoutConstraintParams{
    secondItem = item
    return self
  }
  
  
  
  open func equalTo(_ item:UIView) -> LayoutConstraintParams{
    secondItem = item
    relation = .equal
    secondItemAttribute = firstItemAttribute
    return self
  }
 
  
  open func eqTo(_ item:UIView) -> LayoutConstraintParams{
    secondItem = item
    relation = .equal
    secondItemAttribute = firstItemAttribute
    return self
  }
  
  
  open func offset(_ value:CGFloat) -> LayoutConstraintParams{
    constant = value
    return self
  }
  
  
  
  open func lteTo(_ item:UIView) -> LayoutConstraintParams{
    secondItem = item
    relation = .lessThanOrEqual
    secondItemAttribute = firstItemAttribute
    return self
  }
  
  
  
  open func gteTo(_ item:UIView) -> LayoutConstraintParams{
    secondItem = item
    relation = .greaterThanOrEqual
    secondItemAttribute = firstItemAttribute
    return self
  }

  
  
  open func lessThanOrEqualTo(_ item:UIView) -> LayoutConstraintParams{
    secondItem = item
    relation = .lessThanOrEqual
    secondItemAttribute = firstItemAttribute
    return self
  }
  
  
  
  open func greaterThanOrEqualTo(_ item:UIView) -> LayoutConstraintParams{
    secondItem = item
    relation = .greaterThanOrEqual
    secondItemAttribute = firstItemAttribute
    return self
  }
 
  
  open func identifier(_ id:String?) -> LayoutConstraintParams{
    self.identifier = id
    return self
  }
  
 
  
  open func equalTo(_ itemAttribute:NSLayoutAttribute,ofView view:UIView) -> LayoutConstraintParams{
    self.secondItem = view
    self.relation = .equal
    self.secondItemAttribute = itemAttribute
    return self
  }
  
  open var inSuperview: LayoutConstraintParams{
    secondItem = firstItem.superview
    return self
  }
  
  open var toSuperview: LayoutConstraintParams{
    secondItem = firstItem.superview
    return self
  }
  
  open func autoadd() -> NSLayoutConstraint{
    return install()
  }
  
  @discardableResult
  open func install() -> NSLayoutConstraint{
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
  
  fileprivate var pa_makeConstraint:LayoutConstraintParams{
    assertHasSuperview()
    return LayoutConstraintParams(firstItem: self)
  }
  
  public var pa_width:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.firstItemAttribute = .width
    pa.secondItem = nil
    pa.secondItemAttribute = .notAnAttribute
    return pa
  }
  
  public var pa_height:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.firstItemAttribute = .height
    pa.secondItem = nil
    pa.secondItemAttribute = .notAnAttribute
    return pa
  }
 
  
  
  @available(*,introduced: 1.2)
  public func pa_aspectRatio(_ ratio:CGFloat) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.firstItemAttribute = .height
    pa.secondItemAttribute = .width
    pa.secondItem = self
    pa.multiplier = ratio // height = width * ratio
    // ratio = width:height
    return pa
  }
  
  public var pa_leading:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.firstItemAttribute = .leading
    pa.secondItem = superview
    pa.secondItemAttribute = .leading
    return pa
  }
  
  public var pa_trailing:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .trailing
    pa.secondItemAttribute = .trailing
    return pa
  }
  
  public var pa_top:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .top
    pa.secondItemAttribute = .top
    return pa
  }
  
  public var pa_bottom:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .bottom
    pa.secondItemAttribute = .bottom
    return pa
  }
  
  public var pa_centerX:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .centerX
    pa.secondItemAttribute = .centerX
    return pa
  }
  
  public var pa_centerY:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .centerY
    pa.secondItemAttribute = .centerY
    return pa
  }
  
  public var pa_left:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .left
    pa.secondItemAttribute = .left
    return pa
  }
  
  public var pa_right:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .right
    pa.secondItemAttribute  = .right
    return pa
  }
  
  public var pa_leadingMargin:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .leadingMargin
    pa.secondItemAttribute = .leadingMargin
    
    return pa
  }
  
  public var pa_trailingMargin:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .trailingMargin
    pa.secondItemAttribute = .trailingMargin
    return pa
  }
  
  public var pa_topMargin:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .topMargin
    pa.secondItemAttribute = .topMargin
    return pa
  }
  
  public var pa_bottomMargin:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .bottomMargin
    pa.secondItemAttribute = .bottomMargin
    return pa
  }
  
  public var pa_leftMargin:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .leftMargin
    pa.secondItemAttribute = .leadingMargin
    return pa
  }
  
  public var pa_rightMargin:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .rightMargin
    pa.secondItemAttribute = .rightMargin
    return pa
  }
  
  public var pa_centerXWithinMargins:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .centerXWithinMargins
    pa.secondItemAttribute = .centerXWithinMargins
    return pa
  }
  
  public var pa_centerYWithinMargins:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = superview
    pa.firstItemAttribute = .centerYWithinMargins
    pa.secondItemAttribute = .centerYWithinMargins
    return pa
  }
  
  public var pa_baseline:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.firstItemAttribute = .lastBaseline
    return pa
  }
  
  public var pa_firstBaseline:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.firstItemAttribute = .firstBaseline
    return pa
  }
  
  public var pa_lastBaseline:LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.firstItemAttribute =  NSLayoutAttribute.lastBaseline
    return pa
  }
  
  
  public func pa_below(_ item:UILayoutSupport,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .top
    pa.relation = .equal
    pa.secondItemAttribute = .bottom
    pa.constant = offset
    return pa
  }
  
  
  public func pa_below(_ item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .top
    pa.relation = .equal
    pa.secondItemAttribute = .bottom
    pa.constant = offset
    return pa
  }
  
  
  public func pa_above(_ item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .bottom
    pa.relation = .equal
    pa.secondItemAttribute = .top
    pa.constant = -offset
    return pa
  }
  
  
  public func pa_above(_ item:UILayoutSupport,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .bottom
    pa.relation = .equal
    pa.secondItemAttribute = .top
    pa.constant = -offset
    return pa
  }
  
  
  public func pa_toLeadingOf(_ item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .trailing
    pa.relation = .equal
    pa.secondItemAttribute = .leading
    pa.constant = -offset
    return pa
  }
  
  
  public func pa_before(_ item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .trailing
    pa.relation = .equal
    pa.secondItemAttribute = .leading
    pa.constant = -offset
    return pa
  }
  
  
  public func pa_toLeftOf(_ item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .right
    pa.relation = .equal
    pa.secondItemAttribute = .left
    pa.constant = -offset
    return pa
  }
  
  
  
  
  public func pa_toTrailingOf(_ item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .leading
    pa.relation = .equal
    pa.secondItemAttribute = .trailing
    pa.constant = offset
    return pa
  }
  
  
  public func pa_after(_ item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .leading
    pa.relation = .equal
    pa.secondItemAttribute = .trailing
    pa.constant = offset
    return pa
  }
  
  
  public func pa_toRightOf(_ item:UIView,offset:CGFloat = 0) -> LayoutConstraintParams{
    let pa = pa_makeConstraint
    pa.secondItem = item
    pa.firstItemAttribute = .left
    pa.relation = .equal
    pa.secondItemAttribute = .right
    pa.constant = offset
    return pa
  }

  
}
