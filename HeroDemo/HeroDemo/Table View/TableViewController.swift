//
//  TableViewController.swift
//  HeroDemo
//
//  Created by John Sanderson on 05/02/2017.
//  Copyright © 2017 JSanderson. All rights reserved.
//

import UIKit
import Hero

class TabberCell: UITableViewCell {
  
  @IBOutlet private weak var tabberImageView: UIImageView!
  @IBOutlet private weak var name: UILabel!
  @IBOutlet private weak var position: UILabel!
  
  func update(withTabber tabber: Tabber) {
    
    if let image = UIImage(named: tabber.name) {
      tabberImageView.image = image
    } else {
      tabberImageView.image = UIImage(named: "John Sanderson")
    }
    
    name.text = tabber.name
    position.text = tabber.position
    
    // DEMO: - Assign views with heroIDs matching each tabber
    tabberImageView.heroID = "\(tabber.name)image"
    name.heroID = tabber.name
    position.heroID = tabber.name + tabber.position
  }
}

class TableViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var tabbers = [Tabber]()
  fileprivate let reuseIdentifier = "tabberCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // DEMO: - Enable Hero debug
//    HeroDebugPlugin.isEnabled = true
    
    title = "Tabbers"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Collection", style: .plain, target: self, action: #selector(didTapCollectionView))
    fetchTabbers()
    tableView.reloadData()
  }
  
  func fetchTabbers() {
    
    guard let mockURL = Bundle.main.url(forResource: "tabbers", withExtension: "json"), let data = try? Data(contentsOf: mockURL), let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] else {
      return
    }
    
    guard let newTabbers = json?["tabbers"] as? [[String: AnyObject]] else {
      return
    }
    
    tabbers = newTabbers.flatMap { (jsonDict) -> Tabber? in
      return Tabber.tabberFromJSON(json: jsonDict)
    }
  }
  
  @objc private func didTapCollectionView() {
    let vc = UIStoryboard(name: "CollectionViewController", bundle: nil).instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
    
    // DEMO: - Add hero modifiers to transition to collection view (slides name off, use .ignoreSubviewModifiers to apply to all)
    tableView.heroModifiers = [.translate(x: 400, y: 0, z: 0)]
    navigationController?.pushViewController(vc, animated: true)
  }
  
}

extension TableViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tabbers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? TabberCell else {
      fatalError("could not dequeue cell with identifier \(reuseIdentifier)")
    }
    let tabber = tabbers[indexPath.row]
    
    cell.update(withTabber: tabber)
    
    return cell
  }
}

extension TableViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = UIStoryboard(name: "EmojiViewController", bundle: nil).instantiateViewController(withIdentifier: "EmojiViewController") as! EmojiViewController
    let tabber = tabbers[indexPath.row]
    vc.update(withTabber: tabber)
    navigationController?.pushViewController(vc, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
