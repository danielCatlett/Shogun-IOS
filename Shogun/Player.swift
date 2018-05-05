//  Player.swift
//  Shogun
//
//  Created by Daniel Catlett on 4/2/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Player
{
    private var koku: Int
    private var territories: [String]
    
    private var sword: Int
    
    init(numKoku: Int, territoryList: [String], swordNum: Int)
    {
        koku = numKoku
        territories = territoryList
        sword = swordNum
    }
    
    func getKoku() -> Int
    {
        return koku
    }
    
    //Either add or subtract koku, for when it is spent or
    //aquired by players
    func changeNumKoku(numChange: Int)
    {
        koku += numChange
    }
    
    func addTerritory(territoryName: String)
    {
        territories.append(territoryName)
    }
    
    func removeTerritory(territoryName: String) -> Bool
    {
        for index in 0 ..< territories.count
        {
            if territoryName == territories[index]
            {
                territories.remove(at: index)
                return true
            }
        }
        return false
    }
    
    func getSword() -> Int
    {
        return sword
    }
    
    func setSword(swordNum: Int)
    {
        sword = swordNum
    }
    
    func getTerritories() -> [String]
    {
        return territories
    }
}
