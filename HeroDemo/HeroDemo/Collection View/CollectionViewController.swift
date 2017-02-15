//
//  CollectionViewController.swift
//  HeroDemo
//
//  Created by John Sanderson on 05/02/2017.
//  Copyright © 2017 JSanderson. All rights reserved.
//

import UIKit
import Hero

class TabberCollectionCell: UICollectionViewCell {
  
  @IBOutlet private weak var tabberImageView: UIImageView!
  
  func update(withTabber tabber: Tabber) {
    if let image = UIImage(named: tabber.name) {
      tabberImageView.image = image
    } else {
      tabberImageView.image = UIImage(named: "John Sanderson")
    }
    
    tabberImageView.heroID = "\(tabber.name)image"
  }
}

class CollectionViewController: UIViewController {
  
  @IBOutlet fileprivate weak var collectionView: UICollectionView!
  
  var tabbers = [Tabber]()
  fileprivate let reuseIdentifier = "tabberCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.heroModifiers = [.cascade]
    title = "Tabbers"
    fetchTabbers()
    collectionView.reloadData()
    
    collectionView.heroModifiers = [.cascade]
    
    for cell in collectionView.visibleCells {
      cell.heroModifiers = [.scale(0.5), .rotate(x: 10, y: 0, z: 0)]
    }
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
  
}

extension CollectionViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tabbers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TabberCollectionCell else {
      fatalError("could not dequeue cell with identifier \(reuseIdentifier)")
    }
    let tabber = tabbers[indexPath.row]
    
    cell.update(withTabber: tabber)
    
    return cell
  }
}

extension CollectionViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vc = UIStoryboard(name: "EmojiViewController", bundle: nil).instantiateViewController(withIdentifier: "EmojiViewController") as! EmojiViewController
    let tabber = tabbers[indexPath.row]
    vc.update(withTabber: tabber)
    navigationController?.pushViewController(vc, animated: true)
  }
}


extension CollectionViewController: HeroViewControllerDelegate{
  func heroWillStartAnimatingFrom(viewController: UIViewController) {
    if let vc = viewController as? TableViewController,
      let currentCellIndex = vc.tableView?.indexPathsForVisibleRows?[0] {
      collectionView!.heroModifiers = [.cascade]
      if !collectionView!.indexPathsForVisibleItems.contains(currentCellIndex){
        // make the cell visible
        collectionView!.scrollToItem(at: currentCellIndex,
                                     at: IndexPath(row: 0, section: 0) < currentCellIndex ? .bottom : .top,
                                     animated: false)
      }
    } else {
      collectionView!.heroModifiers = [.cascade, .delay(0.2)]
    }
  }
}
