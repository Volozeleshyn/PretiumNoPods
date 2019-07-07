//
//  ThirdSlideViewController.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 20/06/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import UIKit

class ThirdSlideViewController: UIViewController {

    @IBOutlet weak var lblHelpThoseInNeed: UILabel!
    
    @IBOutlet weak var btnGetStarted: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateLanguage()
    }
    
    private func updateLanguage() {
        switch GlobalServices.language {  // Ошибки здесь нет, xcode лагает
        case "en":
            self.lblHelpThoseInNeed.text = "Help those in need"
            self.btnGetStarted.setTitle("Get started!", for: .normal)
            break
        case "ru":
            self.lblHelpThoseInNeed.text = "Помогайте нуждающимся"
            self.btnGetStarted.setTitle("Начать!", for: .normal)
            break
        default:
            break
        }
    }
    
    
    
    @IBAction func btnGetStartedTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "presentationToSignIn", sender: self)
    }
    

}
