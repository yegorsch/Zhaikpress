//
//  NoImageTableViewCell.swift
//  news
//
//  Created by Егор on 10/1/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit

class NoImageTableViewCell: UITableViewCell {

  @IBOutlet weak var mediaLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var previewTextLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    self.titleLabel.sizeToFit()
  }

}
