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
    var isAttacker: Bool
    
    init(units: (bowmen: Int, spearmen: Int), notDefender: Bool)
    {
        bowmen = Bowmen(numbers: units.bowmen)
        spearmen = Spearmen(numbers: units.spearmen)
    
        isAttacker = notDefender
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
    
    func unitAttack(attackValue: Int, strength: Int) -> Int
    {
        var numHits = 0
        for _ in 0...strength
        {
            let roll = arc4random_uniform(UInt32(attackValue)) + 1; //num between 1 and attackValue, inclusive
            if(roll <= attackValue)
            {
                numHits += 1
            }
        }
    
        return numHits;
    }
    
    func casulities(numDead: Int)
    {
        //num still alive
        let remainingStrength = troopsLeft()
    
        if(remainingStrength > numDead)
        {
            let numToKill = chooseDead(numDead: numDead)
            killUnits(numToKill: numToKill)
        }
        else if(remainingStrength <= numDead)
        {
            //set all of them to 0
            var numToKill = [0]
    
            numToKill[0] = (bowmen.getNumPresent())
            numToKill.append(spearmen.getNumPresent())
     
            killUnits(numToKill: numToKill)
        }
    }
    
    func killUnits(numToKill: [Int])
    {
        //Kill the number of units we've been told to
        bowmen.adjustNumPresent(numbers: numToKill[0])
        spearmen.adjustNumPresent(numbers: numToKill[4])
    }
    
    //this function is incomplete
    //will need to take who to kill from the user
    //instead of just putting 1 of each
    func chooseDead(numDead: Int) -> [Int]
    {
        var choosenCasualities = [0]
        var firstValSet = false
        for _ in 1...numDead
        {
            if !firstValSet
            {
                choosenCasualities[0] = 1
                firstValSet = true
            }
            else
            {
                choosenCasualities.append(1)
            }
        }
        return choosenCasualities
    }
}
