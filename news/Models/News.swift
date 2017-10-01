//
//  News.swift
//  news
//
//  Created by Егор on 9/29/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SDWebImage

class News {

  var title: String!
  var imageURL: URL?
  var hasImage = false
  var text: String!
  var dateText: String!
  var media: String!

  convenience init?(dictionary: [String: Any]) {
    self.init()
    guard let title = dictionary["header"] as? String,
      let text = dictionary["text"] as? String,
      let intTime = dictionary["date"] as? Int,
      let media = dictionary["source"] as? String else {
        return nil
    }
    self.title = title
    self.text = text
    self.dateText = stringFromSeconds(seconds: intTime)
    self.media = media
    guard var imageURLRecieved = dictionary["images"] as? String, imageURLRecieved.characters.count > 0 else {
      return
    }
    self.hasImage = true
    if imageURLRecieved.characters.contains(",") {
      imageURLRecieved = imageURLRecieved.components(separatedBy: ",")[0]
    }
    guard let url = URL(string: imageURLRecieved) else {
      self.hasImage = false
      return
    }
    self.imageURL = url
  }

  func stringFromSeconds(seconds: Int) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm dd.MM.YYYY"

    let date = Date(timeIntervalSince1970: TimeInterval(exactly: seconds)!)

    return dateFormatter.string(from: date)
  }


}
