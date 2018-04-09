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

class Game
{
    let numPlayers: Int
    var players = [Player]()
    
    var castlesLeft: Int
    var fortificationsLeft: Int
    var roninLeft: Int
    
    let turnManager: TurnManager
    
    init(numberOfPlayers: Int)
    {
        numPlayers = numberOfPlayers
        castlesLeft =  10
        fortificationsLeft = 5
        roninLeft = 26
        
        turnManager = TurnManager(numberOfPlayers: numPlayers)
        players = turnManager.setup()
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
                turnManager.initialReinforcements(territoryChoices: possibleTerritories)
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
                turnManager.placeArmies(territoryChoices: possibleTerritories)
                currentPlayer.adjustBowmen(numChanged: -1)
                currentPlayer.adjustSwordsmen(numChanged: -1)
                currentPlayer.adjustGunners(numChanged: -2)
            }
        }
        
        //start normal turn loop
//        while(checkForWinner() == false)
//        {
            plan()
//        }
    }
    
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
    
    func takeSwords()
    {
        //put all of the players sword bids in one place, so that we can let them choose
        var swordBids = [Int]()
        for index in 0 ..< numPlayers
        {
            swordBids.append(players[index].getKokuInSlot(slotName: "swords"))
        }
    }
    
    //don't feel like doing this now, so it just returns an empty value
    func checkSwordBids(swordBids: [Int]) -> [Int]
    {
        var rv = [Int]()
        
        let maxBid = swordBids.max()
        if(maxBid == 0)
        {
            return rv
        }
        else
        {
            return rv
        }
    }
    
    func build()
    {
        //check if each player has spent money on build, then let them build
        for index in 0 ..< numPlayers
        {
            if(players[index].getKokuInSlot(slotName: "build") != 0)
            {
                
            }
        }
    }
    
    //stand in for when the user will actually decide how to spend their koku
    func allocateKoku(numKoku: Int) -> [Int]
    {
        return [0, 0, numKoku, 0, 0]
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
