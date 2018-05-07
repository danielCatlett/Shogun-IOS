//  Territory.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/12/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Territory
{
    var name: String
    var coordinates: [(x: Int, y: Int)]
    
    var defenders: Force
    var owner: Int
    
    init(terrName: String, coordinateList: [(x: Int, y: Int)])
    {
        name = terrName
        coordinates = coordinateList
        
        //territory starts out deserted
        defenders = Force(units: (bowmen: 0, spearmen: 0))
        
        //-1 means it is deserted
        owner = -1
    }
    
    func getName() -> String
    {
        return name
    }
    
    func getCoordinates() -> [(x: Int, y: Int)]
    {
        return coordinates
    }
    
    func getDefenders() -> Force
    {
        return defenders
    }
    
    func setDefenders(newDefenders: Force)
    {
        defenders = newDefenders
    }
    
    func getOwner() -> Int
    {
        return owner
    }
    
    func setOwner(newOwner: Int)
    {
        owner = newOwner
    }
}
