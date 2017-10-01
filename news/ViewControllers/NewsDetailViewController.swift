//
//  NewsDetailViewController.swift
//  news
//
//  Created by Егор on 10/1/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textLabel: UILabel!
  @IBOutlet weak var mediaLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var separatorView: UIView!
  @IBOutlet weak var infoStackView: UIStackView!

  var news: News!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.titleLabel.sizeToFit()
    self.textLabel.sizeToFit()
    self.titleLabel.text = news.title
    self.textLabel.text = news.text
    self.dateLabel.text = news.dateText
    self.mediaLabel.text = news.media
    if news.hasImage {
      self.imageView.sd_setImage(with: news.imageURL, completed: nil)
    } else {
      self.imageView.removeFromSuperview()
    }
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Поделиться", style: .plain, target: self, action: #selector(shareButtonPressed(sender:)))
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if let vc = parent as? ViewController {
      vc.shouldReloadNews = false
    }
  }

  @objc private func shareButtonPressed(sender: UIBarButtonItem) {
    SharingManager.shared.messsageForSharing(from: self.news, with: self.imageView?.image) { (info) in
      let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: info, applicationActivities: nil)
      activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
      self.present(activityViewController, animated: true, completion: nil)
    }
  }


}
