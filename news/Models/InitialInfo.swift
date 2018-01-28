//
//  InitialInfo.swift
//  Zhaikpress
//
//  Created by Егор on 1/27/18.
//  Copyright © 2018 Yegor's Mac. All rights reserved.
//

import Foundation

struct InitialInfo: Decodable {

  let bannersLength: Int
  let sources: [[String: Any]]

  enum CodingKeys: String, CodingKey {
    case bannersLength
    case sources
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    bannersLength = try values.decode(Int.self, forKey: .bannersLength)
    sources = try values.decode([[String: String]].self, forKey: .sources)
  }

}
