//  BattleScreenViewController.swift
//  Shogun
//
//  Created by Daniel Catlett on 5/5/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import UIKit

protocol BattleScreenViewControllerDelegate: class
{
    func attackersChanged(force: Force?)
    func defendersChanged(force: Force?)
}

class BattleScreenViewController: UIViewController
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLable: UILabel!
    
    @IBOutlet weak var attackBowmenLabel: UILabel!
    @IBOutlet weak var attackSpearmenLabel: UILabel!
    @IBOutlet weak var defendBowmenLabel: UILabel!
    @IBOutlet weak var defendSpearmenLabel: UILabel!
    
    @IBOutlet weak var attackButton: UIButton!
    @IBOutlet weak var retreatButton: UIButton!
    
    var attackingForce = Force(units: (bowmen: 0, spearmen: 0))
    var defendingForce = Force(units: (bowmen: 0, spearmen: 0))
    var territoryName = ""
    
    var turn = "attacker"
    var attackerCasualties = (bowmen: 0, spearmen: 0)
    var defenderCasualties = (bowmen: 0, spearmen: 0)
    
    var unitsKilled = 0
    
    weak var delegate: BattleScreenViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        titleLabel.text = "Battle of " + territoryName
        
        attackBowmenLabel.text = String(attackingForce.getBowmen().getNumPresent())
        attackSpearmenLabel.text = String(attackingForce.getSpearmen().getNumPresent())
        
        defendBowmenLabel.text = String(defendingForce.getBowmen().getNumPresent())
        defendSpearmenLabel.text = String(defendingForce.getSpearmen().getNumPresent())
        
        retreatButton.isEnabled = false
    }
    
    @IBAction func attackButtonPressed(_ sender: UIButton)
    {
        unitsKilled = 0
        if(turn == "attacker")
        {
            unitsKilled += attackingForce.attacks()
            if(unitsKilled > defendingForce.troopsLeft())
            {
                unitsKilled = defendingForce.troopsLeft()
            }
            performSegue(withIdentifier: "unitSelectorScreenSegue", sender: self)
            unitsKilled = 0
            
            turn = "defender"
            retreatButton.isEnabled = false
        }
        else
        {
            unitsKilled += defendingForce.attacks()
            if(unitsKilled > attackingForce.troopsLeft())
            {
                unitsKilled = attackingForce.troopsLeft()
            }
            performSegue(withIdentifier: "unitSelectorScreenSegue", sender: self)
            
            attackingForce.killUnits(numToKill: attackerCasualties)
            delegate?.attackersChanged(force: attackingForce)
            defendingForce.killUnits(numToKill: defenderCasualties)
            delegate?.defendersChanged(force: defendingForce)
            
            //if the battle has been won
            if(attackingForce.troopsLeft() == 0 || defendingForce.troopsLeft() == 0)
            {
                var message = ""
                if(attackingForce.troopsLeft() == 0)
                {
                    message = "The defending force held strong!"
                }
                else
                {
                    message = "The attackers won the day!"
                }
                
                let alertController = UIAlertController(title: "The Battle Has Been Won", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Huzzah!", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
                self.dismiss(animated: true, completion: nil)
            }
            //reset everything for the next round
            else
            {
                unitsKilled = 0
                defenderCasualties.bowmen = 0
                defenderCasualties.spearmen = 0
                retreatButton.isEnabled = true
            }
        }
    }
    
    @IBAction func retreatButtonPressed(_ sender: UIButton)
    {
        let message = "Are you sure you want to retreat?"
        let alertController = UIAlertController(title: "Stand and fight you coward!", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
            action in
            
            self.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? UnitSelectorViewController
        {
            if(turn == "attacker")
            {
                destination.units = (bowmen: attackingForce.getBowmen().getNumPresent(), spearmen: attackingForce.getSpearmen().getNumPresent())
            }
            else
            {
                destination.units = (bowmen: defendingForce.getBowmen().getNumPresent(), spearmen: defendingForce.getSpearmen().getNumPresent())
            }
            destination.context = "casualties"
            destination.unitsToKill = unitsKilled
            destination.delegate = self as? UnitSelectorViewControllerDelegate
        }
    }
    
    func unitsChanged(units: (bowmen: Int, spearmen: Int)?)
    {
        if(turn == "attacker")
        {
            attackerCasualties = units!
        }
        else
        {
            defenderCasualties = units!
        }
    }
}
