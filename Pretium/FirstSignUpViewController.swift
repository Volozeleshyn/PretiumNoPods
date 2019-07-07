//
//  FirstSignUpViewController.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 09/03/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import VK_ios_sdk
import SCSDKLoginKit

class FirstSignUpViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {
    
    @IBOutlet weak var lblSignUpVia: UILabel!
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var btnVK: UIButton!
    @IBOutlet weak var btnSnapchat: UIButton!
    @IBOutlet weak var btnContinueWithEmail: UIButton!
   
    var globalServices : GlobalServices?
    let sdkInstance = VKSdk.initialize(withAppId: "6896182")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        
        self.sdkInstance?.register(self)
        self.sdkInstance?.uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateLanguage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let vc = segue.destination as? EmailSignUpViewController {
           vc.globalServices = self.globalServices
        }
    }
    
    private func configureViews() {
        self.btnFB.layer.cornerRadius = 25
        self.btnVK.layer.cornerRadius = 25
        self.btnSnapchat.layer.cornerRadius = 25
        self.btnContinueWithEmail.layer.cornerRadius = 25
    }
    
    private func updateLanguage() {
        if self.globalServices?.language == "en" {
            self.lblSignUpVia.text = "Sign up via"
            self.btnContinueWithEmail.setTitle("Continue with email", for: .normal)
        } else if self.globalServices?.language == "ru" {
            self.lblSignUpVia.text = "Регистрация через"
            self.btnContinueWithEmail.setTitle("Продолжить с email", for: .normal)
        }
    }
    
    // VKDELEGATE
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if ((result?.token) != nil) {
            self.globalServices?.VKAccessToken = result!.token
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        //Вывести ошибку
    }
    
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnVKTapped(_ sender: UIButton) {
        if VKSdk.accessToken() == nil {
            let scope = ["email", "friends", "photos", "offline"]
            VKSdk.authorize(scope)
        } else {
            VKSdk.forceLogout()
            self.globalServices?.VKAccessToken = nil
            print("Logged out")
        }
    }
    
    
    @IBAction func btnSnapchatTapped(_ sender: UIButton) {
        if !(SCSDKLoginClient.isUserLoggedIn) {
            SCSDKLoginClient.login(from: self) { (success, error) in
                if success {
                    self.globalServices?.SCUserLoggedIn = true
                    print("success")
                } else {
                    print(error!.localizedDescription)
                }
            }
        } else {
            SCSDKLoginClient.unlinkAllSessions { (success) in
                self.globalServices?.SCUserLoggedIn = false
            }
        }
    }
    
    @IBAction func btnFBTapped(_ sender: UIButton) {
        let login = FBSDKLoginManager()
        if FBSDKAccessToken.current() == nil {
            login.logIn(withReadPermissions: ["public_profile", "email", "user_friends", "user_photos", "user_location"], from: self) { (result, error) in
                if error != nil {
                    print("error")
                } else if result?.isCancelled ?? false {
                    print("cancelled")
                } else {
                    self.globalServices?.FBAccessToken = FBSDKAccessToken.current()
                }
            }
        } else {
            login.logOut()
            self.globalServices?.FBAccessToken = nil
            print("Logged out")
        }
    }
    
    @IBAction func btnContinueWithEmailTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SignUpToRegister", sender: self)
    }
    
    
}
