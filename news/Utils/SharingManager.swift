//
//  SharingManager.swift
//  news
//
//  Created by Егор on 10/3/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import Foundation
import SDWebImage
import UIKit

class SharingManager {

  static let shared = SharingManager()

  typealias SuccessBlock = ([Any]) -> ()

  func messsageForSharing(from news: News, with image: UIImage?, successBlock: @escaping SuccessBlock) {
    var sharedInfo = [Any]()
    switch news.hasImage {
    case true:
      sharedInfo.append(image)
      sharedInfo.append(news.title)
      successBlock(sharedInfo)
    case false:
      sharedInfo.append(news.title)
      successBlock(sharedInfo)
    }
  }

}
