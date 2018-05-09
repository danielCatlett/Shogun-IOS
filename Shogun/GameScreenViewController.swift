//  GameScreenViewController.swift
//  Shogun
//
//  Created by Daniel Catlett on 5/2/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import UIKit

class GameScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UnitSelectorViewControllerDelegate
{
    @IBOutlet weak var boardView: UICollectionView!
    @IBOutlet weak var textbox: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var numPlayers = 0
    
    var board = Board()
    var attackingForce = Force(units: (bowmen: 4, spearmen: 0))
    var defendingForce = Force(units: (bowmen: 4, spearmen: 0))
    var territoryName = "Bingo"
    
    var territoryNumbers = [String]()
    var territoryOwners = [Int]()
    var players = [Player]()
    let playerColors = ["Blue", "Green", "Red", "Orange", "Yellow"]
    
    var gameState = "spearmen placement"
    var turn = 0
    var round = 0
    var roundZeroRound = 0
    var unitsPlaced = 0
    
    var unitSelectorNums = (bowmen: 0, spearmen: 0)
    var unitSelectorSent = (bowmen: 0, spearmen: 0)
    
    var validTargets = [Int]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        //confirmButton.isEnabled = false
        cancelButton.isEnabled = false
        
        setup()
        setTroopNums()
        setOwners()
        textbox.text = "Blue, place two spearmen."
    }
    
    @IBAction func confirmButton(_ sender: UIButton)
    {
        performSegue(withIdentifier: "battleScreenSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? BattleScreenViewController
        {
            destination.attackingForce = attackingForce
            destination.defendingForce = defendingForce
            destination.territoryName = territoryName
        }
        if let destination = segue.destination as? UnitSelectorViewController
        {
            destination.units = unitSelectorNums
            destination.delegate = self as UnitSelectorViewControllerDelegate
            if(gameState == "picking attack force")
            {
                destination.context = "attacking"
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton)
    {
    
    }
    
    //MARK: UICollectionView DataSource and Delegate functions
    
    //number of territories that should be in the collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return territoryNumbers.count
    }
    
    //put the label in the cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CellController
        cell.cellLabel.text = territoryNumbers[indexPath.row]
        cell.cellLabel.textColor = UIColor.white
        
        //set the color
        switch territoryOwners[indexPath.row]
        {
            case 0:
                cell.cellLabel.backgroundColor = UIColor.blue
            case 1:
                cell.cellLabel.backgroundColor = UIColor.green
            case 2:
                cell.cellLabel.backgroundColor = UIColor.red
            case 3:
                cell.cellLabel.backgroundColor = UIColor.orange
            case 4:
                cell.cellLabel.backgroundColor = UIColor.yellow
            default:
                cell.cellLabel.textColor = UIColor.black
                cell.cellLabel.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    //when a cell is tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let territory = board.getTerritory(index: indexPath.row)
        let territoryIsOwned = (turn == territory.getOwner())
        
        if(gameState == "spearmen placement")
        {
            if(territoryIsOwned)
            {
                territory.getDefenders().adjustUnits(adjustingBowmen: false, num: 1)
                fireUpdate()
            }
        }
        else if(gameState == "bowmen placement")
        {
            if(territoryIsOwned)
            {
                territory.getDefenders().adjustUnits(adjustingBowmen: true, num: 1)
                fireUpdate()
            }
        }
        else if(gameState == "picking attack force")
        {
            validTargets = getValidTargets(index: indexPath.row)
            if(validTargets.count > 0)
            {
                unitSelectorNums.bowmen = territory.getDefenders().getBowmen().getNumPresent()
                unitSelectorNums.spearmen = territory.getDefenders().getSpearmen().getNumPresent()
                performSegue(withIdentifier: "unitSelectorScreenSegue2", sender: self)
            }
        }
        else if(gameState == "picking target")
        {
            if(!validTargets.contains(indexPath.row))
            {
                textbox.text = "That is not a valid target"
            }
            else
            {
                territoryName = territory.getName()
                defendingForce = territory.getDefenders()
                performSegue(withIdentifier: "battleScreenSegue", sender: self)
            }
        }
    }
    
    //unit selector delegate
    func unitsChanged(unitsPassing: (bowmen: Int, spearmen: Int)?)
    {
        if(gameState == "picking attack force" && unitsPassing!.bowmen != -100)
        {
            attackingForce = Force(units: unitsPassing!)
            gameState = "picking target"
            textbox.text = "Pick a target next to this force."
        }
    }
    
    //MARK: Game logic functions
    
    func setup()
    {
        let playerOrder = takeSwords()
        
        //randomly assign territories to each player
        //start by making an int list for each player
        var territoriesLeft = [Int]()
        for i in 0 ..< board.getNumTerritories()
        {
            territoriesLeft.append(i)
        }
        
        var territoryLists = [[Int]]()
        for _ in 0 ..< numPlayers
        {
            var currentList = [Int]()
            for _ in 0 ..< (board.getNumTerritories() / numPlayers)
            {
                let index = Int(arc4random_uniform(UInt32(territoriesLeft.count)))
                currentList.append(territoriesLeft[index])
                territoriesLeft.remove(at: index)
            }
            territoryLists.append(currentList)
        }
        
        //use the number of territories they have to create all of the player objects
        for index in 0 ..< numPlayers
        {
            let koku = territoryLists[index].count / 3
            let player = Player(numKoku: koku, territoryList: territoryLists[index], swordNum: playerOrder[index])
            players.append(player)
        }
        
        //tell each territory who its owner is
        //also add one spearmen to each claimied territory
        for playerNum in 0 ..< territoryLists.count
        {
            for i in 0 ..< territoryLists[playerNum].count
            {
                let terrIndex = territoryLists[playerNum][i]
                board.getTerritory(index: terrIndex).setOwner(newOwner: playerNum)
                board.getTerritory(index: terrIndex).getDefenders().adjustUnits(adjustingBowmen: false, num: 1)
            }
        }
    }
    
    //pull a unique sword for each player
    func takeSwords() -> [Int]
    {
        var playerOrder = [Int]()
        for _ in 0 ..< numPlayers
        {
            var randNum = Int(arc4random_uniform(UInt32(numPlayers)))
            while(playerOrder.contains(randNum))
            {
                randNum = Int(arc4random_uniform(UInt32(numPlayers)))
            }
            playerOrder.append(randNum)
        }
        
        return playerOrder
    }
    
    //tell us what order people will be in this turn
    func getPlayerOrder() -> [Int]
    {
        var playerOrder = [Int]()
        for i in 0 ..< numPlayers
        {
            for j in 0 ..< numPlayers
            {
                if(players[j].getSword() == i)
                {
                    playerOrder.append(j)
                }
            }
        }
        
        return playerOrder
    }
    
    func setTroopNums()
    {
        territoryNumbers.removeAll()
        for i in 0 ..< board.getNumTerritories()
        {
            let numTroops = board.getTerritory(index: i).getDefenders().troopsLeft()
            territoryNumbers.append(String(numTroops))
        }
    }
    
    func setOwners()
    {
        territoryOwners.removeAll()
        for i in 0 ..< board.getNumTerritories()
        {
            territoryOwners.append(board.getTerritory(index: i).getOwner())
        }
    }
    
    func getValidTargets(index: Int) -> [Int]
    {
        var possibleTargets = [index - 7, index - 1, index + 1, index + 7]
        var possibleValidTargets = [Int]()
        for i in 0 ..< possibleTargets.count
        {
            let territoryOffScreen = isOffScreen(startIndex: index, endIndex: possibleTargets[i])
            if(!territoryOffScreen)
            {
                if(board.getTerritory(index: possibleTargets[i]).getOwner() != turn)
                {
                    possibleValidTargets.append(possibleTargets[i])
                }
            }
        }
        
        return possibleValidTargets
    }
    
    func isOffScreen(startIndex: Int, endIndex: Int) -> Bool
    {
        //startIndex is on the top or bottom row
        if(endIndex < 0 || endIndex > 69)
        {
            return true
        }
        //startIndex is on the leftmost column
        else if(startIndex % 7 == 0)
        {
            return true
        }
        //startIndex is on the rightmost column
        else if(startIndex - 1 % 7 == 0)
        {
            return true
        }
        return false
    }
    
    func fireUpdate()
    {
        //place first spearmen
        if(round == 0 && unitsPlaced < 1 && gameState == "spearmen placement")
        {
            unitsPlaced += 1
            textbox.text = playerColors[turn] + ", place another spearmen."
        }
        //place second spearmen, move on to next player
        else if(round == 0 && gameState == "spearmen placement" && turn < (numPlayers - 1))
        {
            unitsPlaced = 0
            turn += 1
            textbox.text = playerColors[turn] + ", place two spearmen."
        }
        //place second spearmen, move back to first player
        else if(round == 0 && gameState == "spearmen placement" && roundZeroRound < 2)
        {
            unitsPlaced = 0
            turn = 0
            roundZeroRound += 1
            textbox.text = playerColors[turn] + ", place two spearmen."
        }
        //place second spearmen, move on to bowmen
        else if(round == 0 && gameState == "spearmen placement")
        {
            unitsPlaced = 0
            turn = 0
            roundZeroRound = 0
            gameState = "bowmen placement"
            textbox.text = playerColors[turn] + ", place a bowmen."
        }
        //place a bowmen, move on to next player
        else if(round == 0 && gameState == "bowmen placement" && turn < (numPlayers - 1))
        {
            turn += 1
            textbox.text = playerColors[turn] + ", place a bowmen."
        }
        //place a bowmen, move back to first player
        else if(round == 0 && gameState == "bowmen placement" && roundZeroRound < 2)
        {
            turn = 0
            roundZeroRound += 1
            textbox.text = playerColors[turn] + ", place a bowmen."
        }
        //place a bowmen, end round zero
        else if(round == 0 && gameState == "bowmen placement")
        {
            turn = 0
            round = 1
            gameState = "picking attack force"
            textbox.text = playerColors[turn] + ", pick a force to attack with."
        }
        setTroopNums()
        setOwners()
        boardView.reloadData()
    }
}
