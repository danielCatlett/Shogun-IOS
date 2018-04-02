//  TurnManager.swift
//  Shogun
//
//  Created by Daniel Catlett on 4/2/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class TurnManager
{
    var players: [Player]
    var board: Board
    
    init(playerArray: [Player], theBoard: Board)
    {
        players = playerArray
        board = theBoard
    }
    
}
