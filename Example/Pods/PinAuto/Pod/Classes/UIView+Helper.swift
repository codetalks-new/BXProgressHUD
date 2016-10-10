//
//  UIView+Helper.swift
//  Pods
//
//  Created by Haizhen Lee on 16/1/17.
//
//

import UIKit

extension UIView{
  
  internal func assertHasSuperview(){
    assert(superview != nil, "NO SUPERVIEW")
  }
  
  internal func assertIsSibling(_ sibling:UIView){
    assert(superview != nil, "NO SUPERVIEW")
    assert(superview == sibling.superview, "NOT SIBLING")
  }
  
}
