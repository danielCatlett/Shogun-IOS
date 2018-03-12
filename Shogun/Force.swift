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
    var buildingExists: Bool
    var isAttacker: Bool
    
    init(units: [Int], buildingStatus: Int, notDefender: Bool)
    {
        bowmen = Bowmen(numbers: units[0])
        gunners = Gunners(numbers: units[1])
        swordsmen = Swordsmen(numbers: units[2])
        ronin = Ronin(numbers: units[3])
        spearmen = Spearmen(numbers: units[4])
        daimyo = Daimyo(numbers: 1)
    
        if(buildingStatus == 0)
        {
            building = Building()
            buildingExists = true
        }
        else if(buildingStatus == 1)
        {
            building = Building()
            building.upgrade()
            buildingExists = true
        }
        else
        {
            buildingExists = false
        }
    
        isAttacker = notDefender;
    }
    
    func getStrength() -> String
    {
        var returnValue = bowmen.getNumPresent() + " bowmen\n"
        + gunners.getNumPresent() + " gunners\n"
        + swordsmen.getNumPresent() + " swordsmen\n"
        + ronin.getNumPresent() + " ronin\n"
        + spearmen.getNumPresent() + " spearmen\n"
        + daimyo.getNumPresent() + " daimyo\n";
        if(buildingExists)
        {
            returnValue = returnValue.concat(getBuildingStrength())
        }
    
        return returnValue;
    }
    
    func getBuildingStrength() -> String
    {
        if(building.getBuildingType().equals("Castle"))
        {
            return "and " + building.getStrength() + " spearmen for your castle"
        }
        else
        {
            return "and " + building.getStrength() + " ronin for your fortress"
        }
    }
    
    func rangedAttacks() -> Int
    {
        var numHits = 0
    
        //roll bowmen and gunners
        numHits += unitAttack(bowmen.getCombatValue(), bowmen.getNumPresent())
        numHits += unitAttack(gunners.getCombatValue(), gunners.getNumPresent())
    
        return numHits;
    }
    
    func meleeAttacks() -> Int
    {
        var numHits = 0
    
        //roll bowmen and gunners
        numHits += unitAttack(swordsmen.getCombatValue(), swordsmen.getNumPresent())
        numHits += unitAttack(ronin.getCombatValue(), ronin.getNumPresent())
        numHits += unitAttack(spearmen.getCombatValue(), spearmen.getNumPresent())
        numHits += unitAttack(daimyo.getCombatValue(), daimyo.getNumPresent())
    
        return numHits
    }
    
    func buildingAttack() -> Int
    {
        var numHits = 0
        if(buildingExists)
        {
            if(building.getBuildingType().equals("castle"))
            {
                numHits += unitAttack(spearmen.getCombatValue(), building.getStrength())
            }
            else
            {
                numHits += unitAttack(ronin.getCombatValue(), building.getStrength())
            }
        }
    
        return numHits
    }
    
    func unitAttack(attackValue: Int, strength: Int) -> Int
    {
        Random rngesus = new Random();
        int numHits = 0;
        for(int i = 0; i < strength; i++)
        {
            int roll = rngesus.nextInt(attackValue) + 1; //num between 1 and attackValue, inclusive
            if(roll <= attackValue)
                numHits++;
        }
    
        return numHits;
    }
    
    func casulities(numDead: Int)
    {
        if(buildingExists && building.getStrength() > 0)
        {
            var buildingStrength = building.getStrength()
            if(buildingStrength > numDead)
            {
                buildingStrength -= numDead
                building.setStrength(buildingStrength)
                return
            }
            else
            {
                numDead -= buildingStrength
                building.setStrength(0)
            }
        }
        else
        {
            //num still alive (minus daimyo, since he must die last)
            var remainingStrength = troopsLeft() - 1
    
            if(remainingStrength > numDead)
            {
                var numToKill = chooseDead(numDead)
                adjustStrength(numToKill)
            }
            else if(remainingStrength <= numDead)
            {
                //set all of them to 0
                var numToKill = [Int]
    
                numToKill.append(bowmen.getNumPresent())
                numToKill.append(gunners.getNumPresent())
                numToKill.append(swordsmen.getNumPresent())
                numToKill.append(ronin.getNumPresent())
                numToKill.append(spearmen.getNumPresent())
    
                adjustStrength(numToKill)
            }
    
            //if everyone is going to be dead, kill the daimyo last
            if(remainingStrength < numDead)
            {
                daimyo.killDaimyo()
            }
        }
    }
    
    func adjustStrength(numToKill: [Int])
    {
        //set the strength to the current strength minus numToKill
        bowmen.setNumPresent(bowmen.getNumPresent() - numToKill[0])
        gunners.setNumPresent(gunners.getNumPresent() - numToKill[1])
        swordsmen.setNumPresent(swordsmen.getNumPresent() - numToKill[2])
        ronin.setNumPresent(ronin.getNumPresent() - numToKill[3])
        spearmen.setNumPresent(spearmen.getNumPresent() - numToKill[4])
    }
    
    func chooseDead(numDead: Int) -> [Int]
    {
        var choosenCasualities: [Int]
        for index in 1...numDead
        {
            choosenCasualities.append(1);
        }
        return choosenCasualities
    }
    
    func troopsLeft() -> Int
    {
        var remainingStrength = bowmen.getNumPresent()
        + gunners.getNumPresent()
        + swordsmen.getNumPresent()
        + ronin.getNumPresent()
        + spearmen.getNumPresent()
        + daimyo.getNumPresent();
    
        if(buildingExists)
        {
            remainingStrength += building.getStrength();
        }
    
        return remainingStrength;
    }
}
