//
//  FirstSlideViewController.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 20/06/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import UIKit

class FirstSlideViewController: UIViewController {

    @IBOutlet weak var lblExploreTheCity: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateLanguage()
    }
    
    private func updateLanguage() { 
        switch GlobalServices.language {  // Ошибки здесь нет, xcode лагает
        case "en":
            self.lblExploreTheCity.text = "Explore the city"
            break
        case "ru":
            self.lblExploreTheCity.text = "Исследуйте город"
            break
        default:
            break
        }
    }
    

}
