//
//  ViewControllera+Additions.swift
//  chocolife
//
//  Created by Егор on 9/16/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit

extension UIViewController {

  func presentActivityIndicator() {
    let frame = CGRect(x: self.view.frame.midX - 40, y: self.view.frame.midY - 60, width: 80, height: 80)
    let view = UIView(frame: frame)
    view.layer.cornerRadius = 5.0
    view.backgroundColor = Colors.commonButtonColor
    view.alpha = 0.0
    view.tag = 1
    let indicator = UIActivityIndicatorView(frame: frame)
    indicator.activityIndicatorViewStyle = .whiteLarge
    indicator.startAnimating()
    indicator.color = Colors.commonButtonColor
    self.view.addSubview(view)
    self.view.addSubview(indicator)
  }

  func removeActivityIndicator() {
    for view in self.view.subviews {
      if view.classForCoder == UIActivityIndicatorView.classForCoder() {
        view.removeFromSuperview()
        view.superview?.removeFromSuperview()
      }
      if view.tag == 1 {
        view.removeFromSuperview()
      }
    }
  }

}
