//  Game.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/18/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

/*                        ***DRAFT***
    ***THIS IS SUBJECT TO CHANGE AS DEVELOPMENT CONTINUES***
 The game class is for controlling the flow of the game. It tells the
 Turn Manager what to do, bridges the gap between the players and the board,
 and keeps track of pieces that are not specific to any one player
 (such as the castles)
 */

/*
class Game
{
    let numPlayers: Int
    var players = [Player]()
    
    var board: Board
    var castlesLeft: Int
    var fortificationsLeft: Int
    var roninLeft: Int
    
    init(numberOfPlayers: Int)
    {
        numPlayers = numberOfPlayers
        board = Board()
        castlesLeft =  10
        fortificationsLeft = 5
        roninLeft = 26
        
        players = setup()
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
                currentPlayer.adjustSpearmen(numChanged: -2)
            }
        }
        
        //each player places 3 armies
        for _ in 1...3
        {
            //loop through each player
            for index in 0 ..< numPlayers
            {
                let currentPlayer = players[playerOrder[index]]
                let possibleTerritories = currentPlayer.getTerritories()
                placeArmies(territoryChoices: possibleTerritories)
                currentPlayer.adjustBowmen(numChanged: -1)
                currentPlayer.adjustSwordsmen(numChanged: -1)
                currentPlayer.adjustGunners(numChanged: -2)
            }
        }
        
        //start normal turn loop
        while(checkForWinner() == false)
        {
            plan()
            takeSwords()
            build()
            levyUnits()
            hireRonin()
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
    
    func placeArmies(territoryChoices: [String])
    {
        var choosenTerritory = board.getTerritory(territoryName: getChoice(territoryChoices: territoryChoices, index: 0))
        print("Player picks what territory they will place there army")
        print("For now, we just use their first possible option")
        var index = 1
        while(choosenTerritory.getArmy().getDaimyo().getNumPresent() == 1)
        {
            //this is just a stand in for how initial army will work until player interaction
            choosenTerritory = board.getTerritory(territoryName: getChoice(territoryChoices: territoryChoices, index: index))
            index += 1
        }
        
        choosenTerritory.getArmy().armyCreated()
        print("Added an army to " + choosenTerritory.getName())
    }
    
    /*
     * MARK: ACTION PHASE FUNCTIONS
     */
    
    func plan()
    {
        //each player takes turns planning
        for index in 0 ..< numPlayers
        {
            print("You have " + String(players[index].getKoku()) + " koku to spend.")
            let allocatedKoku = allocateKoku(numKoku: players[index].getKoku())
            players[index].setAllocation(allocationArray: allocatedKoku)
        }
        print("Players have planned how they will spend their koku")
    }
    
    //this is the dumb one that only can do turn 0
    //takeSwords will be smart and handle all circumstances
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
    
    //smarter version that works on regular turns
    //TODO: MAKE THIS SMART ENOUGH TO HANDLE TURN 0
    //Note: this returns swords starting at 0
    //TODO: MAKE SURE THIS ^ IS CONSISTENT THROUGHOUT
    func takeSwords()
    {
        //put all of the players sword bids in one place, so that we can let them choose
        var swordBids = [Int]()
        for index in 0 ..< numPlayers
        {
            swordBids.append(players[index].getKokuInSlot(slotName: "swords"))
        }
        
        //figure out bid order
        var playerChoiceOrder = [Int]()
        for _ in 0 ..< swordBids.count
        {
            //this is like a max, except for it's for this round
            //ex: If we have bids at 3, 2, and 1, currentVal will end up at 3 the first time,
            //2 the second time, and 1 the final time
            var currentVal = -1
            //since multiple people can bid the same amount for a sword, we have
            //to track everyone who bid that much, and then randomly decide
            var currentValIndices = [Int]()
            for j in 0 ..< swordBids.count
            {
                //highest value that we haven't already assigned a sword picking place
                if(swordBids[j] > currentVal && !playerChoiceOrder.contains(j))
                {
                    currentValIndices.removeAll() //since any values we previously had are irrelevant, due to finding a higher value
                    currentValIndices.append(j)
                    currentVal = swordBids[j]
                }
                else if(swordBids[j] == currentVal)
                {
                    currentValIndices.append(j)
                }
            }
            //randomly pick people from current val indices until we have picked everyone
            while(currentValIndices.count > 0)
            {
                let playerToAdd = Int(arc4random_uniform(UInt32(currentValIndices.count)))
                playerChoiceOrder.append(currentValIndices[playerToAdd])
                currentValIndices.remove(at: playerToAdd)
            }
        }
        
        //give players their swords
        var swordsLeft = [0, 1, 2, 3, 4]
        for i in 0 ..< numPlayers
        {
            var swordIndex = -1
            if(swordBids[playerChoiceOrder[i]] != 0)
            {
                swordIndex = pickASword(swordsStillLeft: swordsLeft)
                
            }
            else //if we have reached a point where people haven't bid for a sword
            {
                swordIndex = Int(arc4random_uniform(UInt32(swordsLeft.count)))
            }
            players[playerChoiceOrder[i]].setSword(swordNum: swordsLeft[swordIndex])
            print("Player " + String(playerChoiceOrder[i]) + " drew sword " + String(swordsLeft[swordIndex]))
            swordsLeft.remove(at: swordIndex)
        }
    }
    
    //TODO: MAKE THIS ACCEPT PLAYER INPUT
    func pickASword(swordsStillLeft: [Int]) -> Int
    {
        return 0
    }
    
    func build()
    {
        //check if each player has spent money on build, then let them build
        for index in 0 ..< numPlayers
        {
            if(players[index].getKokuInSlot(slotName: "build") != 0)
            {
                placeBuildings(territoryChoices: players[index].getTerritories())
            }
        }
    }
    
    func placeBuildings(territoryChoices: [String])
    {
        for index in 0...territoryChoices.count
        {
            //basically, if the building doesn't exist...
            if(!board.getTerritory(territoryName: territoryChoices[index]).getDefenders().getBuilding().getBuildingExistance())
            {
                //place building
                getPlayerBuildingChoice(territoryChoices: territoryChoices)
            }
        }
    }
    
    //TODO: MAKE THIS MORE THAN A PLACEHOLDER
    func getPlayerBuildingChoice(territoryChoices: [String])
    {
        for i in 0...territoryChoices.count
        {
            //if the territory doesn't have a building
            //TODO: REEVALUATE HOW BUILDING EXISTENCE IS HANDLED
            if(board.getTerritory(territoryName: territoryChoices[i]).getDefenders().getBuilding().getBuildingExistance() == false)
            {
                board.getTerritory(territoryName: territoryChoices[i]).getDefenders().getBuilding().buildCastle()
                print("Castle built at " + territoryChoices[i])
                self.buildCastle()
                return
            }
        }
    }
    
    func levyUnits()
    {
        for i in 0 ..< numPlayers
        {
            var unitsValid = false
            var playerChoices = getUnitChoices()
            while(!unitsValid)
            {
                unitsValid = true
                
                //check to see if they have enough units left to
                //place what they asked for. Can't loop this, we
                //have to type in each unit type
                
                if(playerChoices[i] > players[i].getBowmen())
                {
                    unitsValid = false
                }
                else if(playerChoices[i] > players[i].getGunners())
                {
                    unitsValid = false
                }
                else if(playerChoices[i] > players[i].getSwordsmen())
                {
                    unitsValid = false
                }
                else if(playerChoices[i] > players[i].getSpearmen())
                {
                    unitsValid = false
                }
                
                if(!unitsValid)
                {
                    playerChoices = getUnitChoices()
                }
            }
            
            var territoryChoices = players[i].getTerritories()
            territoryChoices = putUnitsOnBoard(unitType: "bowmen", numUnits: playerChoices[0], territoryOptions: territoryChoices)
            territoryChoices = putUnitsOnBoard(unitType: "gunners", numUnits: playerChoices[1], territoryOptions: territoryChoices)
            territoryChoices = putUnitsOnBoard(unitType: "swordsmen", numUnits: playerChoices[2], territoryOptions: territoryChoices)
            territoryChoices = putUnitsOnBoard(unitType: "spearmen", numUnits: playerChoices[3], territoryOptions: territoryChoices)
            
            //reduce the number of available units the player has left
            players[i].adjustBowmen(numChanged: -1 * playerChoices[0])
            players[i].adjustGunners(numChanged: -1 * playerChoices[1])
            players[i].adjustSwordsmen(numChanged: -1 * playerChoices[2])
            players[i].adjustSpearmen(numChanged: -1 * playerChoices[3])
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
    func putUnitsOnBoard(unitType: String, numUnits: Int, territoryOptions: [String]) -> [String]
    {
        var territoryOptionsMutable = territoryOptions
        for _ in 0 ..< numUnits
        {
            let territoryIndex = selectTerritoryForUnit(territoryChoices: territoryOptionsMutable)
            board.getTerritory(territoryName: territoryOptionsMutable[territoryIndex]).getDefenders().adjustUnits(unitType: unitType, num: 1)
            territoryOptionsMutable.remove(at: territoryIndex)
        }
        
        return territoryOptionsMutable
    }
    
    func hireRonin()
    {
        //this is done in sword order, just in case there isn't enough ronin
        for i in 0 ..< numPlayers
        {
            for j in 0 ..< numPlayers
            {
                if(players[j].getSword() == i)
                {
                    var roninHired = players[j].getKokuInSlot(slotName: "ronin") * 2 //you get two ronin per koku
                    
                    //the player can't hire more ronin than there are ronin left
                    if(getRoninLeft() - roninHired < 0)
                    {
                        roninHired = getRoninLeft()
                    }
                    
                    adjustRoninLeft(numChanged: -1 * roninHired)
                    
                    while(roninHired > 0)
                    {
                        let territory = selectTerritoryForRonin(territoryChoices: players[j].getTerritories())
                        let legalLimit = board.getTerritory(territoryName: territory).getDefenders().nonRoninNumbers()
                        let numRoninToDeploy = roninToDeploy(roninLeftToDeploy: roninHired, legalLimit: legalLimit)
                        
                        board.getTerritory(territoryName: territory).getDefenders().adjustUnits(unitType: "ronin", num: numRoninToDeploy)
                        //TODO: PUT IN SOMETHING THAT BREAKS IF THERE IS NO LEGAL PLACE TO PUT RONIN LEFT
                    }
                }
            }
        }
    }
    
    //TODO: MAKE NOT A PLACEHOLDER
    //this function is different from the select territory for units in that
    //it won't give the option for deploying ronin to territories where
    //there aren't enough units for it to be legal
    func selectTerritoryForRonin(territoryChoices: [String]) -> String
    {
        return territoryChoices[0]
    }
    
    //TODO: MAKE NOT A PLACEHOLDER
    func roninToDeploy(roninLeftToDeploy: Int, legalLimit: Int) -> Int
    {
        return min(roninLeftToDeploy, legalLimit)
    }
    
    func hireNinja()
    {
        var maxBid = 0
        var maxBidIndex = 0
        var tieForFirst = false
        for i in 0 ..< numPlayers
        {
            let playerBid = players[i].getKokuInSlot(slotName: "ninja")
            if(playerBid > maxBid)
            {
                maxBid = playerBid
                maxBidIndex = i
                tieForFirst = false
            }
            else if(playerBid == maxBid)
            {
                tieForFirst = true
            }
        }
        
        if(!tieForFirst)
        {
            players[maxBidIndex].ninjaHired()
        }
    }
    
    //TODO: MAKE NOT A PLACEHOLDER
    //stand in for when the user will actually decide how to spend their koku
    func allocateKoku(numKoku: Int) -> [Int]
    {
        return [0, 2, 0, 0, 0]
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
    
    /*
     * MARK: GAME PIECE FUNCTIONS
     */
    
    func getCastlesLeft() -> Int
    {
        return castlesLeft
    }
    
    func buildCastle()
    {
        castlesLeft -= 1
    }
    
    func getFortificationsLeft() -> Int
    {
        return fortificationsLeft
    }
    
    func buildFortification()
    {
        fortificationsLeft -= 1
    }
    
    func getRoninLeft() -> Int
    {
        return roninLeft
    }
    
    func adjustRoninLeft(numChanged: Int)
    {
        roninLeft += numChanged
    }
}
*/
