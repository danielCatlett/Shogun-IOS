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
    
    init (numbers: Int)
    {
        isSamurai = true
        combatValue = 6
        numPresent = numbers
        ranged = false
    }
    
    func getSamurai() -> Bool { return isSamurai }
    
    func getCombatValue() -> Int { return combatValue }
    
    func getNumPresent() -> Int { return numPresent }
    
    func setNumPresent(numbers: Int) { numPresent = numbers }
    
    func getRanged() -> Bool { return ranged }
}
