//
//  SNRegistrationViewController.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 29/06/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import VK_ios_sdk
import Alamofire

class SocialNetworkRegistrationViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    var fullname : String = ""
    var email : String?
    var id : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureViews()
    }
    
    
    private func passSocialNetworkData(username: String, nilEmail : Bool) {
        var e : String = self.email ?? ""
        if nilEmail {e = ""}
        let params = ["username" : username, "email" : e, "id" : self.id, "fullname" : self.fullname] as Parameters
        let apiHost = GlobalServices.API_HOST
        Alamofire.request(apiHost+"/get_sn_data", method: .post, parameters: params).responseData { (response) in
            switch response.result {
            case .success(let data):
                switch response.response?.statusCode ?? -1 {
                case 200:
                    do {
                    User.current = try JSONDecoder().decode(User.self, from: data) // decode data that we got from the server into an instance of a user, and put it in current user
                        self.usernameTF.text = ""
                        self.view.endEditing(false)
                        self.performSegue(withIdentifier: "snRegRight", sender: self)//Move to the next view
                    } catch {
                        GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error.localizedDescription) //catch an error if we had problems in decoding data
                    }
                case 401:
                    GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "Username already exists")
                case 403:
                    self.passSocialNetworkData(username: username, nilEmail: true)
                default:
                    GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "Unexpected error, status \(response.response?.statusCode)!")
                }
            case .failure(let error):
                GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error.localizedDescription)
            }
        }
    }
    
    private func getSocialNetworkFriends() {
        if self.id.first == "f" {
            let req = GraphRequest(graphPath: "me/friends", httpMethod: HTTPMethod.init(rawValue: "GET"))
            req.start { (connection, result, error) in
                if error == nil {
                    if let dict = result as? [String : Any] {
                        if let array = dict["data"] as? NSArray {
                            self.passFriends(array: array, socialNetwork: "fb")
                        }
                    }
                } else {
                    GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error!.localizedDescription)
                }
            }
        } else if self.id.first == "v" {
            let req = VKRequest(method: "friends.getAppUsers", parameters: nil)
            req?.execute(resultBlock: { (response) in
                if let dict = response?.json as? [String : Any] {
                    if let array = dict["response"] as? NSArray {
                        self.passFriends(array: array, socialNetwork: "vk")
                    }
                }
            }, errorBlock: { (error) in
                GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error!.localizedDescription)
            })
        }
    }
    
    private func passFriends(array: NSArray, socialNetwork: String) -> Bool {
        let params = ["friends" : array, "social_network": socialNetwork] as Parameters
        let apiHost = GlobalServices.API_HOST
        var ret = false
        Alamofire.request(apiHost+"/get_friends", method: .post, parameters: params).responseData { (response) in
            switch response.result {
            case .success(let _):
                switch response.response?.statusCode ?? -1 {
                case 200:
                    ret = true
                default:
                    GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "Unexpected error!")
                }
            case .failure(let error):
                GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error.localizedDescription)
                
            }
        }
        
        return ret
        
    }
    
    

    private func configureViews() {
        self.usernameTF.delegate = self
        self.passwordTF.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func btnNextTapped(_ sender: UIButton) {
        var todo = true
        if (usernameTF.text == "") || (usernameTF.text == nil) {
            todo = false
            GlobalServices.showAlert(where: self, withTitle: "Complete all fields", andMessage: nil)
        }
        if todo {
            self.passSocialNetworkData(username: usernameTF.text!, nilEmail: false)
        }
    }
    
}
