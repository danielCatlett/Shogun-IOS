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
        print("exited loop")
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
