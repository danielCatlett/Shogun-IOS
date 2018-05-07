//  Board.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/12/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import Foundation

class Board
{
    var territoryNames = [String]()
    var territories = [String: Territory]()
    var boardGrid = [[String]]()

    init()
    {
        //this var is hiding below
        //it only has a global scope because it has to
        //see the big comment
        currentTerritorySize = 0
        
        grabTerritoryNames()
        buildBoard()
    }
    
    func buildBoard()
    {
        //put initial values in the grid
        for i in 0...9
        {
            boardGrid.append([String]())
            for _ in 0...9
            {
                boardGrid[i].append("")
            }
        }
        
        var unusedNames = territoryNames
        //create all the territories
        //TODO: MAKE IT A SPIRAL
        for i in 0 ..< boardGrid.count
        {
            for j in 0 ..< boardGrid[0].count
            {
                if(unusedNames.count > 0)
                {
                    unusedNames = createTerritory(namesLeft: unusedNames, coordinate: (x: i, y: j))
                }
                else
                {
                    unusedNames = territoryNames
                    unusedNames = createTerritory(namesLeft: unusedNames, coordinate: (x: i, y: j))
                }
            }
        }
    }
    
    /*
     This is a global variable because this information needs
     to be known in real time by addGridspaceToTerritory,
     and that function is recursive. This isn't by the other
     classvars because nobody else should really be using it except
     for the functions that deal with creating a territory
    */
    private var currentTerritorySize: Int
    
    func createTerritory(namesLeft: [String], coordinate: (x: Int, y: Int)) -> [String]
    {
        //start by checking that this coordinate isn't already in a territory
        if(boardGrid[coordinate.x][coordinate.y] != "")
        {
            return namesLeft
        }
        
        var namesLeftMutable = namesLeft
        
        //pick a name for the tile
        let index = Int(arc4random_uniform(UInt32(namesLeftMutable.count)))
        let choosenName = namesLeftMutable[index]
        namesLeftMutable.remove(at: index)
        
        currentTerritorySize = 0
        addGridspaceToTerritory(coordinate: coordinate, name: choosenName)
        
        return namesLeftMutable
    }
    
    func addGridspaceToTerritory(coordinate: (x: Int, y: Int), name: String)
    {
        //handle adding the first tile
        if(currentTerritorySize == 5)
        {
            return
        }
        else
        {
            boardGrid[coordinate.x][coordinate.y] = name
            currentTerritorySize += 1
        }
        
        var availableNeighbors = [(x: Int, y: Int)]()
        
        //check the four surrounding neighbors to see if
        //they are able to join a territory
        
        //above
        if(coordinate.y - 1 >= 0 && boardGrid[coordinate.x][coordinate.y - 1] == "")
        {
            availableNeighbors.append((x: coordinate.x, y: coordinate.y - 1))
        }
        //left
        if(coordinate.x - 1 >= 0 && boardGrid[coordinate.x - 1][coordinate.y] == "")
        {
            availableNeighbors.append((x: coordinate.x - 1, y: coordinate.y))
        }
        //right
        if(coordinate.x + 1 < boardGrid.count && boardGrid[coordinate.x + 1][coordinate.y] == "")
        {
            availableNeighbors.append((x: coordinate.x + 1, y: coordinate.y))
        }
        //below
        if(coordinate.y + 1 < boardGrid[0].count && boardGrid[coordinate.x][coordinate.y + 1] == "")
        {
            availableNeighbors.append((x: coordinate.x, y: coordinate.y + 1))
        }
        
        var territoriesToAdd = [(x: Int, y: Int)]()
        //see if we are adding each neighbor
        for i in 0 ..< availableNeighbors.count
        {
            if(Int(arc4random_uniform(UInt32(3))) == 0)
            {
                territoriesToAdd.append((x: availableNeighbors[i].x, y: availableNeighbors[i].y))
            }
        }
        
        //recursively call for each territory freshly added
        for i in 0 ..< territoriesToAdd.count
        {
            addGridspaceToTerritory(coordinate: territoriesToAdd[i], name: name)
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
    
    func getTerritory(territoryName: String) -> Territory
    {
        return territories[territoryName]!
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
