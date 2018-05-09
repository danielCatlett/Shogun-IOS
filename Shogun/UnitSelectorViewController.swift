//  UnitSelectorViewController.swift
//  Shogun
//
//  Created by Daniel Catlett on 5/5/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import UIKit

protocol UnitSelectorViewControllerDelegate: class
{
    func unitsChanged(unitsPassing: (bowmen: Int, spearmen: Int)?)
}

class UnitSelectorViewController: UIViewController
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bowmenLabel: UILabel!
    @IBOutlet weak var spearmenLabel: UILabel!
    @IBOutlet weak var bowmenStepper: UIStepper!
    @IBOutlet weak var spearmenStepper: UIStepper!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var units = (bowmen: 0, spearmen: 0)
    var unitsPassing = (bowmen: 0, spearmen: 0)
    var context = ""
    var attackersDying = false
    var unitsToKill = 0
    
    weak var delegate: UnitSelectorViewControllerDelegate!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(context == "casualties")
        {
            if(unitsToKill != 0)
            {
                confirmButton.isEnabled = false
            }
            
            bowmenLabel.text = "0"
            bowmenStepper.value = 0
            bowmenStepper.maximumValue = Double(min(units.bowmen, unitsToKill))
            
            spearmenLabel.text = "0"
            spearmenStepper.value = 0
            spearmenStepper.maximumValue = Double(min(units.spearmen, unitsToKill))
        }
        else
        {
            bowmenLabel.text = String(units.bowmen)
            bowmenStepper.value = Double(units.bowmen)
            bowmenStepper.maximumValue = Double(units.bowmen)
            
            spearmenLabel.text = String(units.spearmen)
            spearmenStepper.value = Double(units.spearmen)
            spearmenStepper.maximumValue = Double(units.spearmen)
        }
        bowmenStepper.wraps = false
        spearmenStepper.wraps = false
        
        if(context == "attacking")
        {
            titleLabel.text = "Select Who Will Attack"
        }
        else if(context == "moving")
        {
            titleLabel.text = "Select Who Will Move"
        }
        else if(attackersDying)
        {
            titleLabel.text = "Attacker, Kill " + String(unitsToKill) + " of Your Units"
            cancelButton.isEnabled = false
        }
        else
        {
            titleLabel.text = "Defender, Kill " + String(unitsToKill) + " of Your Units"
            cancelButton.isEnabled = false
        }
    }
    
    @IBAction func bowmenStepped(_ sender: UIStepper)
    {
        bowmenLabel.text = String(Int(bowmenStepper.value))
        
        if(context == "casualties")
        {
            unitsPassing.bowmen = Int(sender.value)
            spearmenStepper.maximumValue = Double(min(unitsToKill - Int(bowmenStepper.value), units.spearmen))
            updateCounter()
        }
        else if(context == "attacking")
        {
            units.bowmen = Int(sender.value)
        }
    }
    
    @IBAction func spearmenStepped(_ sender: UIStepper)
    {
        spearmenLabel.text = String(Int(spearmenStepper.value))

        if(context == "casualties")
        {
            unitsPassing.spearmen = Int(sender.value)
            bowmenStepper.maximumValue = Double(min(unitsToKill - Int(spearmenStepper.value), units.bowmen))
            updateCounter()
        }
        else if(context == "attacking")
        {
            units.spearmen = Int(sender.value)
        }
    }
    
    private func updateCounter()
    {
        let unitsLeftToKill = unitsToKill - Int(bowmenStepper.value) - Int(spearmenStepper.value)
        titleLabel.text = "Kill " + String(unitsLeftToKill) + " Units"
        
        if(unitsLeftToKill == 0)
        {
            confirmButton.isEnabled = true
        }
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton)
    {
        if(context == "casualties")
        {
            delegate.unitsChanged(unitsPassing: unitsPassing)
        }
        else if(context == "attacking")
        {
            delegate.unitsChanged(unitsPassing: units)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton)
    {
        //make it obvious that this was created through hitting cancel, and
        //shouldn't be used by the view controller we are going back to
        if(context != "casualties")
        {
            units.bowmen = -100
            units.spearmen = -100
            delegate.unitsChanged(unitsPassing: units)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
