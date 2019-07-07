//
//  WelcomeViewController.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 12/06/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import UIKit
import Foundation

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = User.current {
            let mas = user.fullname.components(separatedBy: " ")
            welcomeLbl.text = "Welcome, \(mas[0])"
        }
    }
    

   

}
