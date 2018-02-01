//
//  ViewController.swift
//  news
//
//  Created by Егор on 9/29/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit
import SDWebImage

fileprivate enum Constants {
  static let kImageCellIdentifier = "cell"
  static let kNoImageCellIdentifier = "noImageCell"
  static let kNoImageCellNibName = "NoImageTableViewCell"
  static let kPromotionCellNibName = "PromotionTableViewCell"
  static let kPromotionCellIdentifier = "promotionCell"
  static let kVcTitle = "Zhaikpress"
  static let kEmptySelectionAlert = "Вы не подписаны на СМИ"
  static let kBackgrounImageName = "bg_image"
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

  var news: [News] = [] {
    didSet {
      DispatchQueue.main.async {
        self.view.layoutSubviews()
        self.tableView.reloadData()
      }
    }
  }

  lazy var bannerImagesURLS = {
    return InitialInfoRetriever.bannerImagesURLs(numberOfImages: self.info.bannersLength)
  }
  var bannerImageIndex = 0

  var promotionTableViewCell: PromotionTableViewCell? {
    guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.kPromotionCellIdentifier) as? PromotionTableViewCell else {
      return nil
    }
    cell.bannerImageView.sd_setImage(with: bannerImagesURLS()[self.bannerImageIndex % self.info.bannersLength], completed: nil)
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
    self.title = Constants.kVcTitle
    self.tableView.addSubview(self.refreshControl)
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.register(UINib(nibName: Constants.kNoImageCellNibName, bundle: nil), forCellReuseIdentifier: Constants.kNoImageCellIdentifier)
    self.tableView.register(UINib(nibName: Constants.kPromotionCellNibName, bundle: nil), forCellReuseIdentifier: Constants.kPromotionCellIdentifier)
    self.emptyView.reloadButton.addTarget(self, action: #selector(self.performNetworkLoad), for: .touchUpInside)
    setBackgroundImage()
    performNetworkLoad()
  }

  fileprivate func setBackgroundImage() {
    let imageView = UIImageView(frame: self.tableView.frame)
    imageView.image = UIImage(named: Constants.kBackgrounImageName)
    imageView.contentMode = .top
    self.tableView.backgroundView = imageView
  }

  @objc private func performNetworkLoad() {
    loadInitialInfo { (done) in
      if done {
        self.loadNews()
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
      AlertManager.showErrorAlert(Constants.kEmptySelectionAlert, action: {
        let settingsVC = SettingsViewController.instantiate()
        self.navigationController?.pushViewController(settingsVC, animated: true)
        self.shouldReloadNews = true
      })
      return
    }
    NewsRetriever.news { [unowned self] (result) in
      switch result {
      case .success(let news):
        if self.isEmptyViewPresented {
          self.isEmptyViewPresented = false
        }
        self.news = news
        self.removeActivityIndicator()
      case .failure(let error):
        AlertManager.showErrorAlert(error.message, action: nil)
        self.removeActivityIndicator()
      }
    }

  }

  private func loadInitialInfo(done: @escaping (Bool) -> ()) {
    self.presentActivityIndicator()
    InitialInfoRetriever.initialInfo { [unowned self] (result) in
      switch result {
      case .success(let info):
        self.info = info
        Parametizer.shared.mediaRaw = info.sources
        done(true)
      case .failure(let error):
        AlertManager.showErrorAlert(error.message, action: nil)
        self.isEmptyViewPresented = true
        done(false)
        self.removeActivityIndicator()
      }
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
      guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.kImageCellIdentifier, for: indexPath) as? NewsTableViewCell else {
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
      guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.kNoImageCellIdentifier, for: indexPath) as? NoImageTableViewCell else {
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
