//
//  SettingsViewController.swift
//  news
//
//  Created by Егор on 9/29/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import UIKit

fileprivate enum Constants {
  static let kVCTitle = "СМИ"
  static let kMediaCellName = "MediaViewCell"
  static let kMediaCellNameIdentifier = "MediaViewCell"
  static let kAboutUsName = "О нас"
  static let kCellHeight: CGFloat = 70.0
  static let kStoryboardIdentifier = "SettingsViewController"
}

class SettingsViewController: UIViewController, StoryboardInstantiable {
  
  var model: AnyObject!
  typealias T = AnyObject


  // Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet var mediaInfoView: MediaInfoView!
  // Attributes
  private var effect: UIVisualEffect!
  private var blurView: UIVisualEffectView!
  private var mediaInfoFrame: CGRect!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.register(UINib(nibName: Constants.kMediaCellName, bundle: nil), forCellReuseIdentifier: Constants.kMediaCellNameIdentifier)
    self.title = Constants.kVCTitle
    // Effect
    self.effect = UIBlurEffect(style: .dark)
    self.blurView = UIVisualEffectView(effect: nil)
    self.blurView.frame = UIScreen.main.bounds
    // Media info view
    self.mediaInfoFrame = CGRect(x: self.view.frame.minX + 12, y: self.view.frame.midY - 210, width: self.view.frame.width - 25, height: 430)
    self.mediaInfoView.frame = self.mediaInfoFrame
    self.mediaInfoView.alpha = 0.0
    self.mediaInfoView.delegate = self
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.kAboutUsName, style: .plain, target: self, action: #selector(self.addMediaInfoView))
  }

  @objc private func addMediaInfoView() {
    UIView.animate(withDuration: 0.3) {
      self.blurView.isHidden = false
      self.blurView.frame = UIScreen.main.bounds
      self.navigationController?.view.addSubview(self.blurView)
      self.navigationController?.view.addSubview(self.mediaInfoView)
      self.mediaInfoView.alpha = 1.0
      self.blurView.effect = self.effect
    }
  }

}



extension SettingsViewController: MediaInfoViewDelegate {

  func okButtonPressed(sender: MediaInfoView) {
    UIView.animate(withDuration: 0.2, animations: {
      self.mediaInfoView.alpha = 0
      self.blurView.effect = nil
    }) { (complete) in
      self.mediaInfoView.removeFromSuperview()
      self.blurView.removeFromSuperview()
    }
  }

}

extension SettingsViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Parametizer.shared.mediaNames.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.kMediaCellNameIdentifier, for: indexPath) as? MediaViewCell else {
      return UITableViewCell()
    }
    cell.mediaNameLabel.text = Parametizer.shared.mediaNames[indexPath.row]
    if Parametizer.shared.isMediaOn(media: Parametizer.shared.mediaNames[indexPath.row]) {
      cell.mediaSwitch.isOn = true
    } else {
      cell.mediaSwitch.isOn = false
    }
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.kCellHeight
  }

}

extension SettingsViewController: UITableViewDelegate {

  @objc private func infoButtonPressed(sender: UIButton) {
    self.mediaInfoView.titleLabel.text = Parametizer.shared.mediaNames[sender.tag]
    addMediaInfoView()
  }

}

