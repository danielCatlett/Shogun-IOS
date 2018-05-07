//  GameScreenViewController.swift
//  Shogun
//
//  Created by Daniel Catlett on 5/2/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import UIKit

class GameScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var boardView: UICollectionView!
    @IBOutlet weak var textbox: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var numPlayers = 0
    
    let attackingForce = Force(units: (bowmen: 8, spearmen: 12))
    let defendingForce = Force(units: (bowmen: 8, spearmen: 12))
    let territoryName = "Bingo"
    
    var territoryNumbers = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        for _ in 0...69
        {
            territoryNumbers.append("0")
        }
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
    }
    
    @IBAction func cancelButton(_ sender: UIButton)
    {
    
    }
    
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
        
        return cell
    }
}
