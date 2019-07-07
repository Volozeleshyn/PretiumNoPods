//
//  InitiialViewController.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 12/06/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import UIKit

class InitiialViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var lblSelectLanguage: UILabel!
    @IBOutlet weak var lblByDoingThis: UILabel!
    @IBOutlet weak var btnTermsOfUse: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    @IBAction func btnEngtapped(_ sender: UIButton) {
        UserDefaults.standard.setValue("en", forKey: "Language") //set new value for language in Userdefaults
        GlobalServices.language = "en"  //set value for language in GlobalServices
        self.performSegue(withIdentifier: "initialToPresentation", sender: self) // go to presentation
    }
    
    @IBAction func btnRusTapped(_ sender: UIButton) {
        UserDefaults.standard.setValue("ru", forKey: "Language") //set new value for language in Userdefaults
        GlobalServices.language = "ru" //set value for language in GlobalServices
        self.performSegue(withIdentifier: "initialToPresentation", sender: self) // go to presentation
    }
    
    @IBAction func buttonTermsOfUseTapped(_ sender: UIButton) {
        //TODO:
    }
}
