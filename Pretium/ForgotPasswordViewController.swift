//
//  ForgotPasswordViewController.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 23/06/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.configureViews()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func configureViews() {
        self.emailTF.delegate = self
    }
    
    private func checkIfEmailExistsInDB(email: String) {
        let params = ["email" : email] as Parameters
        let api_host = GlobalServices.API_HOST
        Alamofire.request(api_host+"/forgot_password", method: .post, parameters: params).responseData { (response) in
            switch response.result {
            case .success(let data):
                switch response.response?.statusCode ?? -1 {
                case 200:
                    self.performSegue(withIdentifier: "forgotPasswordToCode", sender: self)
                case 401:
                    GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "User with such an email doesn't exist")
                default:
                    GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "Unexpected error, status \(response.response?.statusCode)")
                }
            case .failure(let error):
                GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func btnNexttapped(_ sender: UIButton) {
        if (self.emailTF.text != nil) && (self.emailTF.text != "") {
            self.checkIfEmailExistsInDB(email: emailTF.text!)
        }
    }
    
}
