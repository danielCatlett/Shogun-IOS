//  ViewController.swift
//  Shogun
//
//  Created by Daniel Catlett on 3/12/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numPlayersLabel: UILabel!
    
    var numPlayers = 3
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func stepperChanged(_ sender: UIStepper)
    {
        numPlayersLabel.text = Int(sender.value).description
        numPlayers = Int(sender.value)
    }
    
    @IBAction func startGame(_ sender: UIButton)
    {
        performSegue(withIdentifier: "gameScreenVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? GameScreenViewController
        {
            destination.numPlayers = numPlayers
        }
        
    }
}
