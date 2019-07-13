//
//  ProfileViewController.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 13/07/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var metresPassedLabel: UILabel!
    @IBOutlet weak var adsSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.configureViews()
    }
    
    
    private func configureViews() {
        
        self.nameLabel.text = User.current!.fullname
        
        self.usernameLabel.text = User.current!.username
        
        self.metresPassedLabel.text = "metres walked: \(User.current!.metersWalked)"
        
        self.adsSlider.value = User.current!.adsPrefered
        
        
        guard let url = URL(string: User.current!.imageURL) else {return}
        do {
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data) {
                self.profilePhotoImageView.image = image
            }
        } catch {
            self.profilePhotoImageView.image = UIImage(named: "pretium_logo")
        }
        
        
    }
    
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        User.current!.adsPrefered = sender.value
    }
    
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        let def = UserDefaults.standard
        def.setValue(self.adsSlider.value, forKey: "UserAdsPrefered")
        
        
        let params = ["ads_prefered" : self.adsSlider.value] as Parameters
        let api_host = GlobalServices.API_HOST
        Alamofire.request(api_host+"/change_ads_prefered", method: .post, parameters: params).responseData { (response) in
            switch response.result {
            case .success(let data):
                if response.response?.statusCode != 200 {
                    GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "Unexpected error, status \(response.response?.statusCode)")
                }
            case .failure(let error):
                GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error.localizedDescription)
            }
        }
    }
    

}
