//
//  NewsGateway.swift
//  Zhaikpress
//
//  Created by Егор on 1/27/18.
//  Copyright © 2018 Yegor's Mac. All rights reserved.
//

import Foundation

typealias FetchNewsEntityGatewayCompletionHandler = (Result<[News]>) -> ()
typealias FetchInitialEntityGatewayCompletionHandler = (Result<InitialInfo>) -> ()

protocol NewsRetrievable {
  static func news(completionHandler: @escaping FetchNewsEntityGatewayCompletionHandler)
}

protocol InitialInfoRetrivable {
  static func initialInfo(completionHandler: @escaping FetchInitialEntityGatewayCompletionHandler)
}
