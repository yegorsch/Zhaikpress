//
//  AlertManager.swift
//  
//
//  Created by Егор on 9/16/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import Foundation
import UIKit

class AlertManager: UIAlertController {

  private struct Constant {
    static let okTitle = "Ок"
    static let errorTitle = "Ошибка"
    static let cancelTitle = "Отмена"
  }

  class func showOkAlert(_ title: String, message: String, okAction: (() -> Void)? = nil) {
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: Constant.okTitle, style: .default) { _ in
      okAction?()
    }
    alertVC.addAction(okAction)
    UIApplication.topViewController()?.present(alertVC, animated: true, completion: nil)
  }

  class func showOkCancelAlert(_ title: String, message: String,
                               okAction: (() -> Void)?, cancelAction: (() -> Void)? = nil) {
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: Constant.okTitle, style: .default) { _ in
      okAction?()
    }
    alertVC.addAction(okAction)
    let cancelAction = UIAlertAction(title: Constant.cancelTitle, style: .default) { _ in
      cancelAction?()
    }
    alertVC.addAction(cancelAction)
    UIApplication.topViewController()?.present(alertVC, animated: true, completion: nil)
  }

  class func showAlert(_ title: String, message: String, okTitle: String,
                       okAction: (() -> Void)?, cancelTitle: String?, cancelAction: (() -> Void)? = nil) {
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
      okAction?()
    }
    alertVC.addAction(okAction)
    if cancelTitle != nil {
      let cancelAction = UIAlertAction(title: cancelTitle!, style: .default) { _ in
        cancelAction?()
      }
      alertVC.addAction(cancelAction)
    }
    UIApplication.topViewController()?.present(alertVC, animated: true, completion: nil)
  }

  class func showErrorAlert(_ message: String? = nil, action: (() -> Void)? = nil) {
    self.showOkAlert(Constant.errorTitle, message: message ?? "", okAction: action)
  }

}
