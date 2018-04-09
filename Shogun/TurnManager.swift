//  TurnManager.swift
//  Shogun
//
//  Created by Daniel Catlett on 4/2/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

/*                        ***DRAFT***
    ***THIS IS SUBJECT TO CHANGE AS DEVELOPMENT CONTINUES***
 Turn manager is for handling the users interaction with the board.
 It does not control the flow of the game, or decide to start a new turn,
 it simply carries out what must be done to the board within a turn. It also
 creates a battle object and tell it to begin combat when it is time to do so.
 Turn manager does not have direct access to the player objects.
 */

class TurnManager
{
    var board: Board
    let numPlayers: Int
    
    init(numberOfPlayers: Int)
    {
        board = Board()
        numPlayers = numberOfPlayers
    }
    
    func setup() -> [Player]
    {
        let playerOrder = drawSwords(numPlayers: numPlayers)
        var players = [Player]()
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
        //also add one spearmen to each claimied territory
        for i in 0 ..< listForPlayers.count
        {
            for j in 0 ..< listForPlayers[i].count
            {
                territoriesDict[listForPlayers[i][j]]?.setOwner(newOwner: i)
                territoriesDict[listForPlayers[i][j]]?.getDefenders().adjustUnits(unitType: "spearmen", num: 1)
                
                //don't forget to subtract a spearmen from the current players total
                players[i].adjustSpearmen(numChanged: -1)
            }
        }
        
        //pass the new territory dictionary back to the board
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
        
        return players
    }
    
    func initialReinforcements(territoryChoices: [String])
    {
        var choosenTerritory = board.getTerritory(territoryName: getChoice(territoryChoices: territoryChoices, index: 0))
//        print("Player picks what territory they will want to initially reinforce here")
//        print("For now, we just use their first possible option")
        var index = 1
        while(choosenTerritory.getDefenders().getSpearmen().getNumPresent() == 3)
        {
            //this is just a stand in for how initial unit reinforcement works with player interaction
            choosenTerritory = board.getTerritory(territoryName: getChoice(territoryChoices: territoryChoices, index: index))
            index += 1
        }
        
        choosenTerritory.getDefenders().getSpearmen().adjustNumPresent(numbers: 2)
        print("Add two spearmen to " + choosenTerritory.getName())
    }
    
    func getChoice(territoryChoices: [String], index: Int) -> String
    {
        return territoryChoices[index]
    }
    
    func drawSwords(numPlayers: Int) -> [Int]
    {
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
        
        return playerOrder
    }
}
