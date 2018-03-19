//  Territory.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/12/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Territory
{
    var name: String
    var adjacencies: [String]
    var amphibiousRoutes: [String]
    
    var defenders: Force
    var owner: Int
    
    init(terrName: String, adjacents: [String], amphibs: [String], unitsHere: Force)
    {
        name = terrName
        adjacencies = adjacents
        amphibiousRoutes = amphibs
        
        defenders = unitsHere
        //-1 means it is deserted
        owner = -1
    }
    
    func getName() -> String
    {
        return name
    }
    
    func getNumAdjacenctTerritories() -> Int
    {
        return adjacencies.count
    }
    
    func getAdjacentTerritory(index: Int) -> String
    {
        return adjacencies[index]
    }
    
    func getNumAmphibiousRoutes() -> Int
    {
        return amphibiousRoutes.count
    }
    
    func getAmphibiousRoute(index: Int) -> String
    {
        return amphibiousRoutes[index]
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
