//  Game.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/18/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

/*
                        ***DRAFT***
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
    
    init(numberOfPlayers: Int)
    {
        numPlayers = numberOfPlayers
        castlesLeft =  10
        fortificationsLeft = 5
        roninLeft = 26
        
        let turnManager = TurnManager(numberOfPlayers: numPlayers)
        players = turnManager.setup()
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
