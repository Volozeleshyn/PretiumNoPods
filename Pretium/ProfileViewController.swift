//
//  ProfileViewController.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 13/07/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.configureViews()
    }
    
    private func configureViews() {
        
        self.nameLabel.text = User.current!.fullname
        
        print("USER: \(User.current!.imageURL)")
        
        guard let url = URL(string: User.current!.imageURL) else {return}
        print(url)
        do {
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data) {
                self.profilePhotoImageView.image = image
            }
        } catch {
            self.profilePhotoImageView.image = UIImage(named: "pretium_logo")
        }
    }
    

}
