//
//  SecondSlideViewController.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 20/06/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import UIKit

class SecondSlideViewController: UIViewController {

    @IBOutlet weak var lblTravelMore: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateLanguage()
    }
    
    private func updateLanguage() {
        switch GlobalServices.language {  // Ошибки здесь нет, xcode лагает
        case "en":
            self.lblTravelMore.text = "Travel more"
            break
        case "ru":
            self.lblTravelMore.text = "Гуляйте больше"
            break
        default:
            break
        }
    }
   

}
