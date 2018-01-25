//
//  ViewController.swift
//  news
//
//  Created by Егор on 9/29/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit
import SDWebImage

protocol StoryboardInstantiable {
  associatedtype T
  static var storyboardName: String { get }
  static var storyboardBundle: Bundle? { get }
  static var storyboardIdentifier: String? { get }
  var model: T! { get set }
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
      var vc = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
      return vc
    } else {
      return storyboard.instantiateInitialViewController() as! Self
    }
  }
}


class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet var emptyView: EmptyTableView!

  let imageManager = SDWebImageManager()

  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action:
      #selector(self.handleRefresh(_:)),
    for: UIControlEvents.valueChanged)
    refreshControl.tintColor = Colors.commonButtonColor
    return refreshControl
  }()

  var query: String {
    guard let queryExtracted = Parametizer.shared.initialQuery() else {
      return "1"
    }
    if let query = UserDefaults.standard.value(forKey: "query") as? String {
      if query.count != queryExtracted.count {
        UserDefaults.standard.set(queryExtracted, forKey: "query")
        return queryExtracted
      }
      return query
    }
    UserDefaults.standard.set(queryExtracted, forKey: "query")
    return queryExtracted
  }

  let imageCellIdentifier = "cell"
  let noImageCellIdentifier = "noImageCell"
  let noImageCellNibName = "NoImageTableViewCell"
  let promotionCellNibName = "PromotionTableViewCell"
  let promotionCellIdentifier = "promotionCell"

  var news: [News] = [] {
    didSet {
      DispatchQueue.main.async {
        self.view.layoutSubviews()
        self.tableView.reloadData()
      }
    }
  }

  lazy var bannerImagesURLS = {
    return NetworkManager.shared.bannerImagesURLs(numberOfImages: self.info.bannersCount)
  }
  var bannerImageIndex = 0

  var promotionTableViewCell: PromotionTableViewCell? {
    guard let cell = self.tableView.dequeueReusableCell(withIdentifier: self.promotionCellIdentifier) as? PromotionTableViewCell else {
      return nil
    }
    cell.bannerImageView.sd_setImage(with: bannerImagesURLS()[self.bannerImageIndex % self.info.bannersCount], completed: nil)
    self.bannerImageIndex += 1
    return cell
  }

  var shouldReloadNews = false
  var isEmptyViewPresented = false {
    didSet {
      if isEmptyViewPresented {
        guard self.news.count == 0 else {
          return
        }
        self.tableView.separatorStyle = .none
        self.emptyView.frame = self.tableView.frame
        self.tableView.backgroundView = self.emptyView
        self.tableView.reloadData()
      } else {
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
        self.tableView.reloadData()
      }
    }
  }
  var info: InitialInfo!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Zhaikpress"
    self.tableView.addSubview(self.refreshControl)
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.register(UINib(nibName: self.noImageCellNibName, bundle: nil), forCellReuseIdentifier: self.noImageCellIdentifier)
    self.tableView.register(UINib(nibName: self.promotionCellNibName, bundle: nil), forCellReuseIdentifier: self.promotionCellIdentifier)
    self.emptyView.reloadButton.addTarget(self, action: #selector(self.performNetworkLoad), for: .touchUpInside)
    let imageView = UIImageView(frame: self.tableView.frame)
    imageView.image = UIImage(named: "bg_image")
    imageView.contentMode = .top
    self.tableView.backgroundView = imageView
    performNetworkLoad()
  }

  @objc private func performNetworkLoad() {
    loadInitialInfo { (done) in
      if done {
        self.loadNews()
      } else {

      }
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if self.shouldReloadNews {
      performNetworkLoad()
    }
  }

  @IBAction func refreshNews(_ sender: UIBarButtonItem) {
    performNetworkLoad()
  }

  @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
    performNetworkLoad()
    refreshControl.endRefreshing()
    self.tableView.reloadData()
  }

  private func loadNews() {
    guard !Parametizer.shared.isQueryEmpty(query: self.query) else {
      AlertManager.showErrorAlert("Вы не подписаны на СМИ", action: {
        let settingsVC = SettingsViewController.instantiate()
        self.navigationController?.pushViewController(settingsVC, animated: true)
        self.shouldReloadNews = true
      })
      return
    }

    NetworkManager.shared.news(with: self.query, successBlock: { news in
      if self.isEmptyViewPresented {
        self.isEmptyViewPresented = false
      }
      self.news = news
      self.removeActivityIndicator()
    }, failBlock: { string in
      AlertManager.showErrorAlert(string, action: nil)
      self.removeActivityIndicator()
    })
  }

  private func loadInitialInfo(done: @escaping (Bool) -> ()) {
    self.presentActivityIndicator()
    NetworkManager.shared.initialParameter(successBlock: { (info) in
      self.info = info
      Parametizer.shared.mediaRaw = info.sourcesInfo
      done(true)
    }) { (fail) in
      AlertManager.showErrorAlert(fail, action: nil)
      self.isEmptyViewPresented = true
      done(false)
      self.removeActivityIndicator()
    }
  }

}

extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var row = indexPath.row
    let newsInstance = self.news[row]

    // Checking if we need promotion cell
    if indexPath.row % 6 == 0, self.promotionTableViewCell != nil, indexPath.row != 0 {
      row = row - row / 6
      return self.promotionTableViewCell!
    }
    switch newsInstance.hasImage {
    case true:
      guard let cell = self.tableView.dequeueReusableCell(withIdentifier: self.imageCellIdentifier, for: indexPath) as? NewsTableViewCell else {
        return UITableViewCell()
      }
      cell.titleLabel.text = newsInstance.title
      cell.newsTextPreview.text = newsInstance.text
      cell.dateLabel.text = newsInstance.dateText
      cell.mediaLabel.text = newsInstance.media
      DispatchQueue.main.async {
        cell.newsImagePreview?.sd_setImage(with: newsInstance.imageURL, completed: nil)
      }
      cell.isUserInteractionEnabled = true
      return cell
    case false:
      guard let cell = self.tableView.dequeueReusableCell(withIdentifier: self.noImageCellIdentifier, for: indexPath) as? NoImageTableViewCell else {
        return UITableViewCell()
      }
      cell.titleLabel.text = newsInstance.title
      cell.previewTextLabel.text = newsInstance.text
      cell.dateLabel.text = newsInstance.dateText
      cell.mediaLabel.text = newsInstance.media
      cell.isUserInteractionEnabled = true
      cell.previewTextLabel.isUserInteractionEnabled = true
      return cell
    }
  }

  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.sd_cancelCurrentImageLoad()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.news.count
  }


}

extension ViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let newsInstance = self.news[indexPath.row]
    self.shouldReloadNews = false
    let newsVC = NewsDetailViewController.instantiate(with: newsInstance)
    self.navigationController?.pushViewController(newsVC, animated: true)
  }

}
