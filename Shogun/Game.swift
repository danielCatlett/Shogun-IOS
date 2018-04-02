//  Game.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/18/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Game
{
    let numPlayers: Int
    var board = Board()
    var players = [Player]()
    
    init(numberOfPlayers: Int)
    {
        numPlayers = numberOfPlayers
        
        //draw swords
        var playerOrder = [Int]()
        for _ in 0 ..< numPlayers
        {
            var randNum = Int(arc4random_uniform(UInt32(numPlayers))) + 1
            while(playerOrder.contains(randNum))
            {
                randNum = Int(arc4random_uniform(UInt32(numPlayers))) + 1
            }
            playerOrder.append(randNum)
        }
        
        //randomly assign territories to each player
        //start by getting all the territories, and then shuffling them
        var territoriesDict = board.getTerritoryDictionary()
        let keys = territoriesDict.keys
        var territoryNames = Array(keys)
        var territoryNamesShuffled = [String]()
        while(territoryNames.count > 0)
        {
            let indexToRemove = Int(arc4random_uniform(UInt32(territoryNames.count)))
            territoryNamesShuffled.append(String(territoryNames[indexToRemove]))
            territoryNames.remove(at: indexToRemove)
        }
        
        //Then deal them to each player. Make sure to assign the
        //owner at both the player level, and the board level
        var listForPlayers = [[String]]()
        for index in 0 ..< numPlayers
        {
            var currentIndex = index
            var territoriesPlayerGets = [String]()
            
            //We want to make sure that each player has an even number of territories,
            //so we first need to calculate how many territories we can evenly deal out
            let numTerritoriesPerPlayer = territoryNamesShuffled.count / numPlayers
            while(currentIndex < territoryNamesShuffled.count && territoriesPlayerGets.count < numTerritoriesPerPlayer)
            {
                territoriesPlayerGets.append(territoryNamesShuffled[currentIndex])
                currentIndex += numPlayers
            }
            listForPlayers.append(territoriesPlayerGets)
        }
        
        //use listForPlayers to create all of the player objects
        for index in 0 ..< numPlayers
        {
            let koku = listForPlayers[index].count / 3
            let player = Player(numKoku: koku, territoryList: listForPlayers[index], swordNum: playerOrder[index])
            players.append(player)
        }
        
        //tell each territory who its owner is
        for i in 0 ..< listForPlayers.count
        {
            for j in 0 ..< listForPlayers[i].count
            {
                territoriesDict[listForPlayers[i][j]]?.setOwner(newOwner: i)
            }
        }
        
        //pass the new territory assignments back to the board
        board.setTerritoryDictionary(updatedTerrDict: territoriesDict)
        
        //illustrate that the set up is working
        for index in 0 ..< numPlayers
        {
            let currentPlayer = players[index]
            var stringToPrint = "Player " + String(index + 1) + " has " + String(currentPlayer.getKoku()) + " koku\n"
            stringToPrint += ("They drew the number " + String(currentPlayer.getSword()) + " sword\n")
            stringToPrint += ("Their territories are...\n")
            for j in 0 ..< currentPlayer.getTerritories().count
            {
                stringToPrint += (currentPlayer.getTerritories()[j] + "\n")
            }
            
            print(stringToPrint)
        }
    }
}
