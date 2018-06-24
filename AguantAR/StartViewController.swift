//
//  StartViewController.swift
//  AguantAR
//
//  Created by Jesus M Martínez de Juan on 28/5/18.
//  Copyright © 2018 CHECHU. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet var startButton : UIButton!
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    @IBAction func showARSimulation(){
        print("Boton presionado")
        performSegue(withIdentifier: "showARSimulation", sender: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func unwindFromSimulation(segue: UIStoryboardSegue){
        //Do Nothing
    }
    
}


