//  Building.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/12/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Building
{
    var isCastle: Bool
    var spearmen: Spearmen
    var ronin: Ronin
    
    init()
    {
        //impossible to build a fortress straight out, so we start with castle
        isCastle = true
        spearmen = Spearmen(numbers: 4)
        ronin = Ronin(numbers: 0)
    }
    
    func getBuildingType() -> String
    {
        if(isCastle)
        {
            return "Castle"
        }
        else
        {
            return "Fortress"
        }
    }
    
    func getStrength() -> Int
    {
        if(isCastle)
        {
            return spearmen.getNumPresent()
        }
        else
        {
            return ronin.getNumPresent()
        }
    }
    
    func setStrength(strength: Int)
    {
        if(isCastle)
        {
            spearmen.setNumPresent(numbers: strength)
        }
        else
        {
            ronin.setNumPresent(numbers: strength)
        }
    }
    
    func reset()
    {
        if(isCastle)
        {
            setStrength(strength: 4)
        }
        else
        {
            setStrength(strength: 5)
        }
    }
    
    func upgrade()
    {
        //set spearmen strength to 0, upgrade, and then set ronin strength to 5
        setStrength(strength: 0)
        isCastle = false
        setStrength(strength: 5)
    }
}
