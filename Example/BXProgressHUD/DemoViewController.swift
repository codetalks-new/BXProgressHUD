//
//  ViewController.swift
//  BXProgressHUD
//
//  Created by banxi1988 on 11/06/2015.
//  Copyright (c) 2015 banxi1988. All rights reserved.
//

import UIKit
import BXProgressHUD

class DemoViewController: UITableViewController,BXProgressHUDDelegate{

    @IBOutlet var buttons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons.forEach{ button in button.layer.cornerRadius = 5.0 }
        
    }

    @IBAction func showSimple(sender: AnyObject) {
        let targetView = self.navigationController!.view
        let hud = BXProgressHUD(view: targetView)
        targetView.addSubview(hud)
        hud.delegate = self
        hud.showAnimated(true, whileExecutingBlock: myTaskBlock)
        
        
        
    }
    
    func hudWasHidden(hud: BXProgressHUD) {
        hud.removeFromSuperview()
    }

    var myTaskBlock:dispatch_block_t = {
        sleep(3)
    }

}

