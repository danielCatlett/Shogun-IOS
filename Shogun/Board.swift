//  Board.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/12/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Board
{
    var territoryNames = [String]()
    var territories = [Territory]()

    init()
    {
        grabTerritoryNames()
        buildBoard()
    }
    
    func buildBoard()
    {
        var territoryNamesMutable = territoryNames //we want to be able to pull names out
        for i in 0...69
        {
            let nameIndex = Int(arc4random_uniform(UInt32(territoryNamesMutable.count)))
            let terr = Territory(terrName: territoryNamesMutable[nameIndex], indexOfTerritory: i)
            territories.append(terr)
            territoryNamesMutable.remove(at: nameIndex)
        }
    }
    
    func getTerritoryList() -> [Territory]
    {
        return territories
    }
    
    func setTerritoryList(updatedTerrDict: [Territory])
    {
        territories = updatedTerrDict
    }
    
    func getTerritory(index: Int) -> Territory
    {
        return territories[index]
    }
    
    func getNumTerritories() -> Int
    {
        return territories.count
    }
    
    func grabTerritoryNames()
    {
        let path = Bundle.main.path(forResource: "classicboard", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        
        do
        {
            //import all the data on the board
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let allTerritories = try decoder.decode(JSONTerritoryList.self, from: data)
            
            //save it all to the Territory dictionary
            for index in 0 ..< allTerritories.territories.count
            {
                //get all the board info
                let territoryJSON = allTerritories.territories[index]
                let name = territoryJSON.name
                territoryNames.append(name)
            }
        }

        //maybe post a message saying "failed to load board" or something here
        catch
        {
            print ("error -> \(error)")
        }
    }
}

//our structures used for json decoding
struct JSONTerritoryList: Codable
{
    let territories: [JSONTerritory]
}

struct JSONTerritory: Codable
{
    let name: String
    let adjacencies: [String]
    let aquatic: [String]
}
