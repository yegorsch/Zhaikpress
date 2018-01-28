//
//  CommonButton.swift
//  news
//
//  Created by Егор on 10/13/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit

class CommonButton: UIButton {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  private func commonInit() {
    self.backgroundColor = Colors.commonButtonColor
    self.setTitleColor(Colors.commonButtonTitleColor, for: .normal)
    self.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
    setupBorder()
  }

  private func setupBorder() {
    self.layer.cornerRadius = 5.0
  }

}

