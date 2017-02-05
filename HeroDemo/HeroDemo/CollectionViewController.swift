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
        
        tabberImageView.heroID = tabber.name
    }
}

class CollectionViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var tabbers = [Tabber]()
    fileprivate let reuseIdentifier = "tabberCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTabbers()
        collectionView.reloadData()
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
