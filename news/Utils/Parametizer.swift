//
//  Parametizer.swift
//  news
//
//  Created by Егор on 10/1/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import Foundation

class Parametizer {

  static let shared = Parametizer()

  private init() { }

  var mediaRaw: [[String: Any]]! {
    didSet {
      setupMediaNames()
    }
  }
  var mediaNames: [String] = []

  func isMediaOn(media: String) -> Bool {
    guard let query = UserDefaults.standard.value(forKey: "query") as? String, let index = self.mediaNames.index(of: media) else {
      return false
    }
    return query[index] == "1"
  }

  func isQueryEmpty(query: String) -> Bool {
    return !query.contains("1")
  }

  func initialQuery() -> String? {
    guard self.mediaRaw != nil else {
      return nil
    }
    var parameter = ""
    for element in self.mediaRaw {
      guard let number = element["defaultValue"] as? String else {
        return nil
      }
      parameter.append(number)
    }
    return parameter
  }

  private func setupMediaNames() {
    guard self.mediaNames.count == 0 else {
      return 
    }
    for element in self.mediaRaw {
      guard let name = element["name"] as? String else {
        return
      }
      self.mediaNames.append(name)
    }
  }



}

