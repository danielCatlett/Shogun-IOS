//  GameScreenViewController.swift
//  Shogun
//
//  Created by Daniel Catlett on 5/2/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import UIKit

class GameScreenViewController: UIViewController
{
    var numPlayers = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        var board = Board()
    }
}
