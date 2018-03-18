//  Daimyo.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/12/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Daimyo
{
    var isSamurai: Bool
    var combatValue: Int
    var numPresent: Int
    var ranged: Bool
    
    init ()
    {
        isSamurai = true
        combatValue = 6
        numPresent = 1
        ranged = false
    }
    
    func getSamurai() -> Bool { return isSamurai }
    
    func getCombatValue() -> Int { return combatValue }
    
    func getNumPresent() -> Int { return numPresent }
    
    func killDaimyo() { numPresent = 0 }
    
    func getRanged() -> Bool { return ranged }
}
