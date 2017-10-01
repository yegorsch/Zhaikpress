//
//  NewsTableViewCell.swift
//  news
//
//  Created by Егор on 9/29/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var newsImagePreview: UIImageView!
  @IBOutlet weak var newsTextPreview: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var mediaLabel: UILabel!



  override func awakeFromNib() {
    super.awakeFromNib()
    self.titleLabel.sizeToFit()
    self.newsTextPreview.sizeToFit()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    guard (self.newsImagePreview) != nil else {
      return
    }
    self.newsImagePreview.image = nil
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

}
