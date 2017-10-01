//
//  MediaInfoView.swift
//  news
//
//  Created by Егор on 10/5/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit

protocol MediaInfoViewDelegate {
  func okButtonPressed(sender: MediaInfoView)
}

class MediaInfoView: UIView {

  @IBOutlet weak var titleLabel: UILabel!
  var delegate: MediaInfoViewDelegate?

  @IBAction func okButtonPressed(_ sender: CommonButton) {
    self.delegate?.okButtonPressed(sender: self)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.cornerRadius = 10.0
  }
  
}
