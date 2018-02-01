//
//  MediaView.swift
//  news
//
//  Created by Егор on 9/29/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit

class MediaViewCell: UITableViewCell {

  @IBOutlet weak var mediaNameLabel: UILabel!
  @IBOutlet weak var mediaSwitch: UISwitch!
  @IBOutlet weak var isOnLabel: UILabel!

  var isMediaSelected: Bool = true {
    didSet {
      let index = Parametizer.shared.mediaNames.index(of: self.mediaNameLabel.text!)
      if isMediaSelected {
        self.isOnLabel.text = "Включено"
        guard var query = UserDefaults.standard.value(forKey: "query") as? String, let strIndex = index else {
          return
        }
        query = query.replace(strIndex, "1")
        UserDefaults.standard.set(query, forKey: "query")
      } else {
        self.isOnLabel.text = "Отключено"
        guard var query = UserDefaults.standard.value(forKey: "query") as? String, let strIndex = index else {
          return
        }
        query = query.replace(strIndex, "0")
        UserDefaults.standard.set(query, forKey: "query")
      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    self.mediaSwitch.addTarget(self, action: #selector(switchChanged(sender:)), for: .valueChanged)
  }

  @objc func switchChanged(sender: UISwitch) {
    self.isMediaSelected = sender.isOn
  }

  func setMediaSelected(_ bool: Bool) {
    self.isMediaSelected = bool
    self.mediaSwitch.isOn = bool
  }


}
