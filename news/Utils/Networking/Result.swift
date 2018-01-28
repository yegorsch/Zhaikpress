//
//  Result.swift
//  Zhaikpress
//
//  Created by Егор on 1/25/18.
//  Copyright © 2018 Yegor's Mac. All rights reserved.
//

import Foundation

struct CoreError: Error {
  var localizedDescription: String {
    return message
  }

  var message = ""
}

enum Result<T> {
  case success(T)
  case failure(Error)

  public func dematerialize() throws -> T {
    switch self {
    case let .success(value):
      return value
    case let .failure(error):
      throw error
    }
  }
}
