//  Territory.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/12/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Territory
{
    var name: String
    var index: Int
    
    var defenders: Force
    var owner: Int
    
    init(terrName: String, indexOfTerritory: Int)
    {
        name = terrName
        index = indexOfTerritory
        
        //territory starts out deserted
        defenders = Force(units: (bowmen: 0, spearmen: 0))
        
        //-1 means it is unowned
        owner = -1
    }
    
    func getName() -> String
    {
        return name
    }
    
    func getIndex() -> Int
    {
        return index
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
