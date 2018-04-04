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
    
    
    private var daimyoOnBoard: Int
    
    //sll of these vars are the number of each unit the player has left to deploy
    //ex: bowmen will spend most of the time at 0 throughout the game, since players
    //usually have all their bowmen on the board
    private var bowmen: Int
    private var swordsmen: Int
    private var gunners: Int
    private var spearmen: Int
    
    private var ninja: Bool
    private var sword: Int
    
    
    init(numKoku: Int, territoryList: [String], swordNum: Int)
    {
        koku = numKoku
        territories = territoryList
        sword = swordNum
        
        daimyoOnBoard = 3
        bowmen = 9
        swordsmen = 9
        gunners = 9
        spearmen = 36
        
        ninja = false
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
    
    func getBowmen() -> Int
    {
        return bowmen
    }
    
    func adjustBowmen(numChanged: Int)
    {
        bowmen += numChanged
    }
    
    func getSwordsmen() -> Int
    {
        return swordsmen
    }
    
    func adjustSwordsmen(numChanged: Int)
    {
        swordsmen += numChanged
    }
    
    func getGunners() -> Int
    {
        return gunners
    }
    
    func adjustGunners(numChanged: Int)
    {
        gunners += numChanged
    }
    
    func getSpearmen() -> Int
    {
        return spearmen
    }
    
    func adjustSpearmen(numChanged: Int)
    {
        spearmen += numChanged
    }
    
    func killDaimyo()
    {
        daimyoOnBoard -= 1
    }
    
    func resetDaimyo()
    {
        daimyoOnBoard = 3
    }
    
    func ninjaHired()
    {
        ninja = true
    }
    
    func ninjaUsed()
    {
        ninja = false
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
