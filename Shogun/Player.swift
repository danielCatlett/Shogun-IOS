//  Player.swift
//  Shogun
//
//  Created by Daniel Catlett on 4/2/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Player
{
    private var koku: Int
    private var territories: [Int]
    
    private var sword: Int
    
    init(numKoku: Int, territoryList: [Int], swordNum: Int)
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
    
    func addTerritory(index: Int)
    {
        territories.append(index)
    }
    
    func removeTerritory(index: Int) -> Bool
    {
        for i in 0 ..< territories.count
        {
            if index == territories[i]
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
    
    func getTerritories() -> [Int]
    {
        return territories
    }
}
