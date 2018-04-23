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
    var buildingExists: Bool
    
    init(iExist: Bool)
    {
        buildingExists = iExist
        //impossible to build a fortress straight out, so we start with castle
        isCastle = true
        spearmen = Spearmen(numbers: 4)
        ronin = Ronin(numbers: 0)
    }
    
    func getBuildingExistance() -> Bool
    {
        return buildingExists
    }
    
    func getBuildingType() -> String
    {
        if !buildingExists
        {
            return "Looking for building type when building does not exist"
        }
        
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
        if !buildingExists
        {
            return -42
        }
        
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
        if !buildingExists
        {
            return
        }
        
        if(isCastle)
        {
            spearmen.adjustNumPresent(numbers: strength)
        }
        else
        {
            ronin.adjustNumPresent(numbers: strength)
        }
    }
    
    func reset()
    {
        if !buildingExists
        {
            return
        }
        
        if(isCastle)
        {
            setStrength(strength: 4)
        }
        else
        {
            setStrength(strength: 5)
        }
    }
    
    func buildCastle()
    {
        buildingExists = true
    }
    
    func upgrade()
    {
        if !buildingExists
        {
            return
        }
        
        //set spearmen strength to 0, upgrade, and then set ronin strength to 5
        setStrength(strength: 0)
        isCastle = false
        setStrength(strength: 5)
    }
}
