//
//  UIApplication+Additions.swift
//  chocolife
//
//  Created by Егор on 9/16/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit

extension UIApplication {
  class func topViewController(controller: UIViewController? =
    UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    } else if let tabController = controller as? UITabBarController,
      let selected = tabController.selectedViewController {
      return topViewController(controller: selected)
    } else if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
}

