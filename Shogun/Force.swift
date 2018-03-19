//  Force.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/12/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Force
{
    var bowmen: Bowmen
    var gunners: Gunners
    var swordsmen: Swordsmen
    var ronin: Ronin
    var spearmen: Spearmen
    var daimyo: Daimyo
    var building: Building
    var isAttacker: Bool
    
    init(units: [Int], buildingStatus: Int, notDefender: Bool)
    {
        bowmen = Bowmen(numbers: units[0])
        gunners = Gunners(numbers: units[1])
        swordsmen = Swordsmen(numbers: units[2])
        ronin = Ronin(numbers: units[3])
        spearmen = Spearmen(numbers: units[4])
        if(units[5] == 1)
        {
            daimyo = Daimyo(exists: true)
        }
        else
        {
            daimyo = Daimyo(exists: false)
        }
    
        if(buildingStatus == 0)
        {
            //no building
            building = Building(iExist: false)
        }
        else if(buildingStatus == 1)
        {
            //castle
            building = Building(iExist: true)
        }
        else
        {
            //fortress
            building = Building(iExist: true)
            building.upgrade()
        }
    
        isAttacker = notDefender;
    }
    
    func getStrength() -> String
    {
        var returnValue = String(bowmen.getNumPresent()) + " bowmen\n"
        returnValue += String(gunners.getNumPresent()) + " gunners\n"
        returnValue += String(swordsmen.getNumPresent()) + " swordsmen\n"
        returnValue += String(ronin.getNumPresent()) + " ronin\n"
        returnValue += String(spearmen.getNumPresent()) + " spearmen\n"
        returnValue += String(daimyo.getNumPresent()) + " daimyo\n"
        if(building.getBuildingExistance())
        {
            returnValue += getBuildingStrength()
        }
    
        return returnValue;
    }
    
    func getBuildingStrength() -> String
    {
        if(building.getBuildingType() == "Castle")
        {
            return "and " + String(building.getStrength()) + " spearmen for your castle"
        }
        else
        {
            return "and " + String(building.getStrength()) + " ronin for your fortress"
        }
    }
    
    func rangedAttacks() -> Int
    {
        var numHits = 0
    
        //roll bowmen and gunners
        numHits += unitAttack(attackValue: bowmen.getCombatValue(), strength: bowmen.getNumPresent())
        numHits += unitAttack(attackValue: gunners.getCombatValue(), strength: gunners.getNumPresent())
    
        return numHits;
    }
    
    func meleeAttacks() -> Int
    {
        var numHits = 0
    
        //roll bowmen and gunners
        numHits += unitAttack(attackValue: swordsmen.getCombatValue(), strength: swordsmen.getNumPresent())
        numHits += unitAttack(attackValue: ronin.getCombatValue(), strength: ronin.getNumPresent())
        numHits += unitAttack(attackValue: spearmen.getCombatValue(), strength: spearmen.getNumPresent())
        numHits += unitAttack(attackValue: daimyo.getCombatValue(), strength: daimyo.getNumPresent())
    
        return numHits
    }
    
    func buildingAttack() -> Int
    {
        var numHits = 0
        if(building.getBuildingExistance())
        {
            if(building.getBuildingType() == "castle")
            {
                numHits += unitAttack(attackValue: spearmen.getCombatValue(), strength: building.getStrength())
            }
            else
            {
                numHits += unitAttack(attackValue: ronin.getCombatValue(), strength: building.getStrength())
            }
        }
    
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
        //Apparently Swift doesn't like it when you change the
        //var that was passed in (it makes it a constant), so this exists
        //so that we can have a numDead that we can change
        var numDeadMutable = numDead
        if(building.getBuildingExistance() && building.getStrength() > 0)
        {
            var buildingStrength = building.getStrength()
            if(buildingStrength > numDeadMutable)
            {
                buildingStrength -= numDeadMutable
                building.setStrength(strength: buildingStrength)
                return
            }
            else
            {
                numDeadMutable -= buildingStrength
                building.setStrength(strength: 0)
            }
        }
        else
        {
            //num still alive (minus daimyo, since he must die last)
            let remainingStrength = troopsLeft() - 1
    
            if(remainingStrength > numDeadMutable)
            {
                let numToKill = chooseDead(numDead: numDeadMutable)
                adjustStrength(numToKill: numToKill)
            }
            else if(remainingStrength <= numDeadMutable)
            {
                //set all of them to 0
                var numToKill = [0]
    
                numToKill[0] = (bowmen.getNumPresent())
                numToKill.append(gunners.getNumPresent())
                numToKill.append(swordsmen.getNumPresent())
                numToKill.append(ronin.getNumPresent())
                numToKill.append(spearmen.getNumPresent())
    
                adjustStrength(numToKill: numToKill)
            }
    
            //if everyone is going to be dead, kill the daimyo last
            if(remainingStrength < numDeadMutable)
            {
                daimyo.killDaimyo()
            }
        }
    }
    
    func adjustStrength(numToKill: [Int])
    {
        //set the strength to the current strength minus numToKill
        bowmen.setNumPresent(numbers: bowmen.getNumPresent() - numToKill[0])
        gunners.setNumPresent(numbers: gunners.getNumPresent() - numToKill[1])
        swordsmen.setNumPresent(numbers: swordsmen.getNumPresent() - numToKill[2])
        ronin.setNumPresent(numbers: ronin.getNumPresent() - numToKill[3])
        spearmen.setNumPresent(numbers: spearmen.getNumPresent() - numToKill[4])
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
    
    func troopsLeft() -> Int
    {
        var remainingStrength = bowmen.getNumPresent() + gunners.getNumPresent() + swordsmen.getNumPresent() + ronin.getNumPresent() + spearmen.getNumPresent() + daimyo.getNumPresent()
    
        if(building.getBuildingExistance())
        {
            remainingStrength += building.getStrength();
        }
    
        return remainingStrength;
    }
}
