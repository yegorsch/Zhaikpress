//
//  StoryboardInstantiable.swift
//  Zhaikpress
//
//  Created by Егор on 1/25/18.
//  Copyright © 2018 Yegor's Mac. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardInstantiable {
  associatedtype T
  static var storyboardName: String { get }
  static var storyboardBundle: Bundle? { get }
  static var storyboardIdentifier: String? { get }
  var model: T? { get set }
}

extension StoryboardInstantiable where Self: UIViewController {

  static var storyboardName: String { return "Main" }
  static var storyboardBundle: Bundle? { return nil }
  static var storyboardIdentifier: String? { return String(describing: self) }

  static func instantiate(with data: T) -> Self {
    let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
    if let storyboardIdentifier = storyboardIdentifier {
      var vc = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
      vc.model = data
      return vc
    } else {
      return storyboard.instantiateInitialViewController() as! Self
    }
  }

  static func instantiate() -> Self {
    let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
    if let storyboardIdentifier = storyboardIdentifier {
      let vc = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
      return vc
    } else {
      return storyboard.instantiateInitialViewController() as! Self
    }
  }

}
