//
//  EmojiViewController.swift
//  HeroDemo
//
//  Created by John Sanderson on 06/02/2017.
//  Copyright © 2017 JSanderson. All rights reserved.
//

import UIKit
import Hero

class EmojiViewController: UIViewController {
  
  @IBOutlet private weak var tabberImageView: UIImageView!
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var positionLabel: UILabel!
  @IBOutlet private weak var emoji: UILabel!
  
  private var newTabber: Tabber!
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    styleWithTabber()
  }
  
  func update(withTabber tabber: Tabber) {
    newTabber = tabber
  }
  
  private func styleWithTabber() {
    if let image = UIImage(named: newTabber.name) {
      tabberImageView.image = image
    } else {
      tabberImageView.image = UIImage(named: "John Sanderson")
    }
    
    emoji.text = newTabber.emoji
    nameLabel.text = newTabber.name
    positionLabel.text = newTabber.position
    tabberImageView.heroID = "\(newTabber.name)image"
    nameLabel.heroID = newTabber.name
    positionLabel.heroID = newTabber.name + newTabber.position
    
    emoji.heroModifiers = [.translate(x: 0, y: 400, z: 0)]
    nameLabel.heroModifiers = [.translate(x: 400, y: 0, z: 0)]
    positionLabel.heroModifiers = [.translate(x: 400, y: 0, z: 0)]
  }
  
}
