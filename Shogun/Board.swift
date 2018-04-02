//  Board.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/12/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Board
{
    var territories = [String: Territory]()
    
    init()
    {
        /*
         * We are setting up the board here
         */
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
                let adjacencies = territoryJSON.adjacencies
                let aquatics = territoryJSON.aquatic
                
                //set up an empty force for the territory
                let units = [0, 0, 0, 0, 0, 0]
                let emptyForce = Force(units: units, buildingStatus: 0, notDefender: false)
                
                //put that all together to create a Territory object, then add it to the Territory dictionary
                let currentTerritory = Territory(terrName: name, adjacents: adjacencies, amphibs: aquatics, unitsHere: emptyForce)
                territories[name] = currentTerritory
            }
        }
        //maybe post a message saying "failed to load board" or something here
        catch
        {
            print ("error -> \(error)")
        }
    }
    
    func getTerritoryDictionary() -> [String: Territory]
    {
        return territories
    }
    
    func setTerritoryDictionary(updatedTerrDict: [String: Territory])
    {
        territories = updatedTerrDict
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
