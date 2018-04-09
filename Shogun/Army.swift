//  Army.swift
//  Shogun
//
//  Created by Daniel Catlett on 4/9/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Army
{
    var daimyo: Daimyo
    var bowmen: Bowmen
    var swordsmen: Swordsmen
    var gunners: Gunners
    var spearmen: Spearmen
    var ronin: Ronin
    
    init()
    {
        daimyo = Daimyo(exists: false)
        bowmen = Bowmen(numbers: 0)
        swordsmen = Swordsmen(numbers: 0)
        gunners = Gunners(numbers: 0)
        spearmen = Spearmen(numbers: 0)
        ronin = Ronin(numbers: 0)
    }
    
    func armyCreated()
    {
        daimyo.newDaimyo()
        bowmen.adjustNumPresent(numbers: 1)
        swordsmen.adjustNumPresent(numbers: 1)
        gunners.adjustNumPresent(numbers: 2)
    }
    
    func getDaimyo() -> Daimyo
    {
        return daimyo
    }
}
