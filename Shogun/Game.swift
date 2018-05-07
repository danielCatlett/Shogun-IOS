//  Game.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/18/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

/*
class Game
{
    let numPlayers: Int
    var players = [Player]()
    
    var board: Board
    
    init(numberOfPlayers: Int)
    {
        numPlayers = numberOfPlayers
        var board = Board()
        players = setup()
    }
    
    func setup() -> [Player]
    {
        let playerOrder = takeSwords()
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
                territoriesDict[listForPlayers[i][j]]?.getDefenders().adjustUnits(adjustingBowmen: false, num: 1)
            }
        }
        
        //pass the new territory dictionary back to the board
        board.setTerritoryDictionary(updatedTerrDict: territoriesDict)
        
        return players
    }
    
    func playGame()
    {
        //conduct turn 0
        let playerOrder = getPlayerOrder()
        //three rounds
        for _ in 1...3
        {
            //each player places 2 spearmen
            for index in 0 ..< numPlayers
            {
                let currentPlayer = players[playerOrder[index]]
                let possibleTerritories = currentPlayer.getTerritories()
                initialReinforcements(territoryChoices: possibleTerritories)
            }
        }
        
        //start normal turn loop
        while(checkForWinner() == false)
        {
            takeSwords()
            levyUnits()
        }
    }
    
    /*
    * MARK: TURN 0 FUNCTIONS
    */
    
    func initialReinforcements(territoryChoices: [String])
    {
        var choosenTerritory = board.getTerritory(territoryName: getChoice(territoryChoices: territoryChoices, index: 0))
        print("Player picks what territory they will want to initially reinforce here")
        print("For now, we just use their first possible option")
        var index = 1
        while(choosenTerritory.getDefenders().getSpearmen().getNumPresent() == 3)
        {
            //this is just a stand in for how initial unit reinforcement will work until player interaction
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
    
    /*
     * MARK: ACTION PHASE FUNCTIONS
     */
    
    //this is the dumb one that only can do turn 0
    //takeSwords will be smart and handle all circumstances
    func takeSwords() -> [Int]
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
    
    func levyUnits()
    {
        for i in 0 ..< numPlayers
        {
            var playerChoices = getUnitChoices()
            
            var territoryChoices = players[i].getTerritories()
            territoryChoices = putUnitsOnBoard(isBowmen: true, numUnits: playerChoices[0], territoryOptions: territoryChoices)
            territoryChoices = putUnitsOnBoard(isBowmen: false, numUnits: playerChoices[3], territoryOptions: territoryChoices)
            
        }
    }
    
    //TODO: MAKE THIS NOT A PLACEHOLDER
    func getUnitChoices() -> [Int]
    {
        return [3, 0, 0, 0] //this is three bowmen
    }
    
    //TODO: MAKE THIS NOT A PLACEHOLDER
    //returns the index of the territory rather than the string, so that
    //it can easily be removed when we are adding other units, while observing
    //the rule of one unit per territory
    func selectTerritoryForUnit(territoryChoices: [String]) -> Int
    {
        return 0
    }
    
    //add the units onto the board, and return the new valid territory list they can use
    func putUnitsOnBoard(isBowmen: Bool, numUnits: Int, territoryOptions: [String]) -> [String]
    {
        var territoryOptionsMutable = territoryOptions
        for _ in 0 ..< numUnits
        {
            let territoryIndex = selectTerritoryForUnit(territoryChoices: territoryOptionsMutable)
            board.getTerritory(territoryName: territoryOptionsMutable[territoryIndex]).getDefenders().adjustUnits(adjustingBowmen: isBowmen, num: 1)
            territoryOptionsMutable.remove(at: territoryIndex)
        }
        
        return territoryOptionsMutable
    }
    
    //check the order of the swords that were drawn, so that we know who goes when
    func getPlayerOrder() -> [Int]
    {
        var playerOrder = [Int]()
        for index in 0 ..< numPlayers
        {
            playerOrder.append(players[index].getSword() - 1)
        }
        
        //reorganize the the array so the index corresponds to the
        //player order, and the value is the player going then
        var rv = [Int]()
        for _ in 0 ..< numPlayers
        {
            var currentMin = 100
            var currentMinIndex = 100
            for nextCheckForMin in 0 ..< playerOrder.count
            {
                if(playerOrder[nextCheckForMin] < currentMin && !rv.contains(nextCheckForMin))
                {
                    currentMin = playerOrder[nextCheckForMin]
                    currentMinIndex = nextCheckForMin
                }
                
            }
            rv.append(currentMinIndex)
        }
        return rv
    }
    
    //check to see if any player has 35 territories
    func checkForWinner() -> Bool
    {
        for index in 0 ..< numPlayers
        {
            if(players[index].getTerritories().count >= 35)
            {
                return true
            }
        }
        return false
    }
}
 */
