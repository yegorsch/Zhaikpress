//
//  NetworkManager.swift
//  news
//
//  Created by Егор on 9/29/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import Foundation
import Alamofire
import SDWebImage

fileprivate enum URLConstants {

  static let ip = "http://178.62.42.207:8080"
  static let imageBaseURL = "http://178.62.42.207:8080/banner?index="
  static let newsPath = "/news"
  static let initPath = "/init"

  static var newsURL: URL? {
    let urlString = ip + newsPath
    guard let url = URL(string: urlString)
      else { return nil }
    return url
  }

  static var initURL: URL? {
    let urlString = ip + initPath
    guard let url = URL(string: urlString)
      else { return nil }
    return url
  }

}

fileprivate enum ErrorConstants {
  static let kBadConnectionError = "Ошибка соединения"
}

struct NewsRetriever: NewsRetrievable {
  static func news(completionHandler: @escaping FetchNewsEntityGatewayCompletionHandler) {

    guard let newsURL = URLConstants.newsURL else { return }

    URLSession.shared.dataTask(with: newsURL) { (data, response, err) in
      guard let data = data else {
        completionHandler(.failure(CoreError(message: ErrorConstants.kBadConnectionError)))
        return
      }
      do {
        let decoder = JSONDecoder()
        let news = try decoder.decode([News].self, from: data)
        completionHandler(.success(news))
      } catch {
        completionHandler(.failure(CoreError(message: ErrorConstants.kBadConnectionError)))
      }
    }.resume()

  }

}

struct InitialInfoRetriever: InitialInfoRetrivable {

  static func initialInfo(completionHandler: @escaping FetchInitialEntityGatewayCompletionHandler) {

    guard let initialInfoURL = URLConstants.initURL else { return }

    URLSession.shared.dataTask(with: initialInfoURL) { (data, response, err) in
      guard let data = data else {
        completionHandler(.failure(CoreError(message: ErrorConstants.kBadConnectionError)))
        return
      }
      do {
        let decoder = JSONDecoder()
        let info = try decoder.decode(InitialInfo.self, from: data)
        completionHandler(.success(info))
      } catch {
        completionHandler(.failure(CoreError(message: ErrorConstants.kBadConnectionError)))
      }
    }.resume()

  }

  static func bannerImagesURLs(numberOfImages: Int) -> [URL] {
    var imagesURL = [URL]()
    for i in 0..<numberOfImages {
      let url = URL(string: URLConstants.imageBaseURL + i.description)
      imagesURL.append(url!)
    }
    return imagesURL
  }

}




