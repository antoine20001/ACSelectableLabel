//
//  ViewController.swift
//  ACSelectableLabel
//
//  Created by antoine.cointepas@orange.fr on 03/14/2017.
//  Copyright (c) 2017 antoine.cointepas@orange.fr. All rights reserved.
//

import UIKit
import ACSelectableLabel

class ViewController: UIViewController, ACSelectableLabelDelegate {
    
    @IBOutlet weak var selectableLabel: ACSelectableLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        selectableLabel.delegate = self
        selectableLabel.addLinkItemWith(title: "Inventory Lookup")

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapOnCopy(sender: ACSelectableLabel) {
        
    }

    
    func tapOnLink(sender: ACSelectableLabel) {
        
    }
}

