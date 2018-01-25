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

struct InitialInfo {
  var bannersCount: Int!
  var sourcesInfo: [[String: Any]]!
}



class NetworkManager {

  static let shared = NetworkManager()

  private init() { }

  private let ip = "http://178.62.42.207:8080"
  private let newsPath = "/news"
  private var newsURL: URLConvertible {
    let url = ip + newsPath
    return URL(string: url)!
  }
  private let initPath = "/init"
  private var initURL: URLConvertible {
    let url = ip + initPath
    return URL(string: url)!
  }
  private let imageBaseURL = "http://178.62.42.207:8080/banner?index="

  typealias SuccessBlock = ([News]) -> ()
  typealias InitSuccessBlock = (InitialInfo) -> ()
  typealias ImageSuccessBlock = (UIImage) -> ()
  typealias FailBlock = (String) -> ()

  func news(with parameter: String, successBlock: @escaping SuccessBlock, failBlock: @escaping FailBlock) {
    Alamofire.request(newsURL, method: .get, parameters: ["query": parameter]).responseJSON(completionHandler: { response in

      guard let json = response.result.value as? [[String: Any]] else {
        failBlock("Ошибка соединения")
        return
      }
      var news = [News]()
      for dict in json {
        let newsInstance = News(dictionary: dict)
        news.append(newsInstance!)
      }
      successBlock(news)
    })
  }

  func initialParameter(successBlock: @escaping InitSuccessBlock, failBlock: @escaping FailBlock) {
    Alamofire.request(initURL, method: .get).responseJSON(completionHandler: { response in
      guard let json = response.result.value as? [String: Any] else {
        failBlock("Ошибка соединения")
        return
      }
      var info = InitialInfo()
      guard let bannerCount = json["bannersLength"] as? Int else {
        failBlock("Ошибка соединения")
        return
      }
      info.bannersCount = bannerCount
      guard let sources = json["sources"] as? [[String: Any]] else {
        failBlock("Ошибка соединения")
        return
      }
      info.sourcesInfo = sources
      successBlock(info)
    })
  }

  func bannerImagesURLs(numberOfImages: Int) -> [URL] {
    var imagesURL = [URL]()
    for i in 0..<numberOfImages {
      let url = URL(string: self.imageBaseURL + i.description)
      imagesURL.append(url!)
    }
    return imagesURL
  }
}




