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
    
    func setKoku(numKoku: Int)
    {
        koku = numKoku
    }
    
    func addTerritory(index: Int)
    {
        territories.append(index)
    }
    
    func removeTerritory(territoryIndex: Int)
    {
        for i in 0 ..< territories.count
        {
            if territoryIndex == territories[i]
            {
                territories.remove(at: i)
                break
            }
        }
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
