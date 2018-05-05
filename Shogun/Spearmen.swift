//  Spearmen.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/12/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Spearmen
{
    var combatValue: Int
    var numPresent: Int
    
    init (numbers: Int)
    {
        combatValue = 4
        numPresent = numbers
    }
    
    func getCombatValue() -> Int { return combatValue }
    
    func getNumPresent() -> Int { return numPresent }
    
    func adjustNumPresent(numbers: Int) { numPresent += numbers }
}
