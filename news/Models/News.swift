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

class News: Decodable {

  var title: String
  var imageURL: URL?
  var hasImage = false
  var text: String
  var dateText: String
  var media: String

  enum CodingKeys: String, CodingKey {
    case header
    case text
    case date
    case source
    case images
  }

  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    title = try values.decode(String.self, forKey: .header)
    text = try values.decode(String.self, forKey: .text)
    media = try values.decode(String.self, forKey: .source)
    let intTime = try values.decode(Int.self, forKey: .date)
    dateText = stringFromSeconds(seconds: intTime) ?? ""
    var imageURLRecieved = try values.decode(String.self, forKey: .images)
    guard imageURLRecieved.count > 0 else {
      return
    }
    if imageURLRecieved.contains(",") {
      imageURLRecieved = imageURLRecieved.components(separatedBy: ",")[0]
    }
    guard let url = URL(string: imageURLRecieved) else {
      return
    }
    imageURL = url
    hasImage = true
  }

}

fileprivate func stringFromSeconds(seconds: Int) -> String? {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "HH:mm dd.MM.YYYY"
  let date = Date(timeIntervalSince1970: TimeInterval(exactly: seconds)!)
  return dateFormatter.string(from: date)
}
