//  Force.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/12/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Force
{
    var bowmen: Bowmen
    var spearmen: Spearmen
    
    init(units: (bowmen: Int, spearmen: Int))
    {
        bowmen = Bowmen(numbers: units.bowmen)
        spearmen = Spearmen(numbers: units.spearmen)
    }
    
    func adjustUnits(adjustingBowmen: Bool, num: Int)
    {
        if(adjustingBowmen)
        {
            bowmen.adjustNumPresent(numbers: num)
        }
        else
        {
            spearmen.adjustNumPresent(numbers: num)
        }
    }
    
    func troopsLeft() -> Int
    {
        return bowmen.getNumPresent() + spearmen.getNumPresent()
    }
    
    func printStrength() -> String
    {
        var rv = String(bowmen.getNumPresent()) + " bowmen\n"
        rv += String(spearmen.getNumPresent()) + " spearmen\n"
    
        return rv;
    }
    
    func getBowmen() -> Bowmen
    {
        return bowmen
    }
    
    func getSpearmen() -> Spearmen
    {
        return spearmen
    }
    
    func attacks() -> Int
    {
        var numHits = 0
        numHits += unitAttack(attackValue: bowmen.getCombatValue(), strength: bowmen.getNumPresent())
        numHits += unitAttack(attackValue: spearmen.getCombatValue(), strength: spearmen.getNumPresent())
    
        return numHits
    }
    
    private func unitAttack(attackValue: Int, strength: Int) -> Int
    {
        var numHits = 0
        for _ in 0...strength
        {
            let roll = arc4random_uniform(UInt32(12)) + 1; //num between 1 and 12, inclusive
            if(roll <= attackValue)
            {
                numHits += 1
            }
        }
    
        return numHits;
    }
    
    func killUnits(numToKill: (bowmen: Int, spearmen: Int))
    {
        //Kill the number of units we've been told to
        bowmen.adjustNumPresent(numbers: numToKill.bowmen)
        spearmen.adjustNumPresent(numbers: numToKill.spearmen)
    }
}
