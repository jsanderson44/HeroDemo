//
//  Tabber.swift
//  HeroDemo
//
//  Created by John Sanderson on 05/02/2017.
//  Copyright © 2017 JSanderson. All rights reserved.
//

import Foundation

struct Tabber {
    let name: String
    let position: String
    let emoji: String
}

extension Tabber {
    
    static func tabberFromJSON(json: [String: AnyObject]) -> Tabber? {
        
        guard let name = json["name"] as? String,
        let position = json["position"] as? String,
            let emoji = json["emoji"] as? String else {
                return nil
        }
        
        return Tabber(name: name, position: position, emoji: emoji)
    }
    
}
