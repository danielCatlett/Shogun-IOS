//  Battle.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/12/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Battle
{
    var attackerForce: Force
    var defenderForce: Force
    
    var isAmphibiousAssault: Bool
    
    init(attackers: Force, defenders: Force, amphibious: Bool)
    {
        attackerForce = attackers;
        defenderForce = defenders;
        isAmphibiousAssault = amphibious;
    }
    
    func conductBattle() -> Int
    {
        var battleInconclusive = false;
        
        if(isAmphibiousAssault)
        {
            var numHits = 0
            numHits += defenderForce.rangedAttacks()
            numHits += defenderForce.meleeAttacks()
            
            attackerForce.casulities(numDead: numHits);
        }
        
        while(attackerForce.troopsLeft() > 0 && defenderForce.troopsLeft() > 0)
        {
            var attackersKilled = 0
            var defendersKilled = 0
            
            defendersKilled += attackerForce.rangedAttacks()
            attackersKilled += defenderForce.rangedAttacks()
            
            attackerForce.casulities(numDead: attackersKilled)
            defenderForce.casulities(numDead: defendersKilled)
            
            //reset for melee attacks
            attackersKilled = 0
            defendersKilled = 0
            
            defendersKilled += attackerForce.meleeAttacks()
            attackersKilled += defenderForce.meleeAttacks()
            
            attackerForce.casulities(numDead: attackersKilled)
            defenderForce.casulities(numDead: defendersKilled)
            
            //if the attacker retreats, end the fight here
            if(checkForRetreat())
            {
                battleInconclusive = true
                break
            }
        }
        
        //get the results of the battle
        
        //returning 3 means that the attacker retreats
        if(battleInconclusive)
        {
            return 3
        }
        //returning 2 means that everyone died
        else if(attackerForce.troopsLeft() == 0 && defenderForce.troopsLeft() == 0)
        {
            return 2
        }
        //returning 1 means that defender won
        else if(attackerForce.troopsLeft() == 0)
        {
            return 1
        }
        //returning 0 means that attacker won
        else if(defenderForce.troopsLeft() == 0)
        {
            return 0
        }
        //-1 means that there is a problem
        else
        {
            return -1
        }
    }
    
    func checkForRetreat() -> Bool
    {
        return false
    }
}
