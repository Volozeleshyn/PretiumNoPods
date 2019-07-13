//
//  SignUpViewController.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 29/03/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import VK_ios_sdk
import Alamofire
import SafariServices


class SignInViewController: UIViewController, UITextFieldDelegate, VKSdkDelegate, VKSdkUIDelegate{
    
    

    //Outlets linking to the objects in storyboard
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var btnVK: UIButton!
    
    @IBOutlet weak var btnDoNotHaveAccount: UIButton!
    
    let placeholderColor = UIColor.gray
    
    
    var fullname : String = ""
    var email : String?
    var id : String = ""
    var imageURL : String = ""
    var vkShouldGo = false
    var fbShouldGo = false
    
    let vkSDK = VKSdk.initialize(withAppId: "6896182")
   
   
    
    
    //This func triggers when the view is loaded and before starting to appear
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViews()
       
        vkSDK?.register(self)
        vkSDK?.uiDelegate = self
        
        
    }
    
    
    //This func triggers when the view is already loaded and starting to appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateLanguage()
    }
    
    //Func used to dismiss a keyboard in case the user touches space above it
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let vc = segue.destination as? SocialNetworkRegistrationViewController {
            vc.fullname = self.fullname
            vc.email = self.email
            vc.id = self.id
            vc.imageURL = self.imageURL
        }
    }
    
    /*
    //check if the user is logged in with FB, if yes, pass the access token to the global services
    private func checkFBLogin() -> Bool {
        if let FBAccessToken = AccessToken.current {
            self.btnLogin.setTitle("Уже зарегался FB", for: .normal)
            GlobalServices.FBAccessToken = FBAccessToken
            return true
        }
        return false
    }
    
    //check if the user is logged in with VK, if yes, pass the access token to the global services
    private func checkVKLogin() -> Bool {
        let scope = ["email", "friends", "photos", "offline"]
        var ret = false
        
        VKSdk.wakeUpSession(scope) { (state, error) in
            if state == VKAuthorizationState.authorized {
                self.btnLogin.setTitle("Уже зарегался VK", for: .normal)
                GlobalServices.VKAccessToken = VKSdk.accessToken()?.accessToken
                ret = true
            }
        }
        return ret
    }
    */
    
    
    private func configureViews() {
        
        // Circle angles of views
        self.btnFB.layer.cornerRadius = 25
        self.btnVK.layer.cornerRadius = 25
        
        // Set delegates for TextFields
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
        
        // Set placeholders for TextFields, using func, declared at the bottom of this code
        self.emailTF.setPlaceholder(text: "Username or Email", color: self.placeholderColor)
        self.passwordTF.setPlaceholder(text: "Password", color: self.placeholderColor)
    }
    
    
    private func updateLanguage() {
        //TODO:
    }
    
    //Func used for "shaking TextField" in case something wrong is written there
    // takes: textfield to shake
    private func shakeTF(viewToShake : UITextField) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 10, y: viewToShake.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 10, y: viewToShake.center.y))
        
        viewToShake.layer.add(animation, forKey: "position")
    }
    
    private func didLoginWithSocialNetwork(username: String, fullname: String, email: String) {
        //TODO:
     /*   let params = ["username" : username, "fullname" : fullname, "email" : email]
        let api_host = GlobalServices.API_HOST
        Alamofire.request(api_host+"/getData", method:.post,parameters:params as Parameters).responseData
            { response in switch response.result {
            case .success(let data): // case success: we check status of our response to handle some errors
                switch response.response?.statusCode ?? -1 {
                case 200: //200: everything is OK, fill current user field
                    self.didLogin(userData: data)
                default: //Something went really wrong
                    GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "Unexpected error")
                }
            case .failure(let error): // case failure: let the user see where is the problem
                GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error.localizedDescription)
                }
            } */
    }
    
   private func checkForId(id : String) {
        let params = ["id" : id] as Parameters
        let api_host = GlobalServices.API_HOST
        Alamofire.request(api_host+"/check_id", method: .post, parameters: params).responseData { (response) in
            switch response.result {
            case .success(let data):
                switch response.response?.statusCode ?? -1 {
                case 200:
                    self.didLogin(userData: data)
                case 401:
                    self.performSegue(withIdentifier: "needUsername", sender: self)
                default:
                    GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "Unexpected error, status \(response.response?.statusCode)")
                }
            case .failure(let error):
                GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error.localizedDescription)
            }
        }
    }
    
    
    //Func is used for decoding data delivered from server and filling static field current in class User
    //takes: data to decode
    private func didLogin(userData: Data) {
        do {
            User.current = try JSONDecoder().decode(User.self, from: userData)
            let def = UserDefaults.standard
            def.setValue(User.current!.username, forKey: "UserUsername")
            def.setValue(User.current!.fullname, forKey: "UserFullname")
            def.setValue(User.current!.email, forKey: "UserEmail")
            def.setValue(User.current!.id, forKey: "UserId")
            def.setValue(User.current!.imageURL, forKey: "UserImageURL")
            self.emailTF.text = "" //make empty texts of emailTF and passwordTF
            self.passwordTF.text = ""
            self.view.endEditing(false)
            self.performSegue(withIdentifier: "signInCorrect", sender: self)
        } catch {
            GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error.localizedDescription) // catch an error, show alert
        }
    }
    
    //Login with FB
    //Takes permissions we ask from the user during auth
    private func loginWithFacebook(readPermissions : [String]) {
        let login = LoginManager() // Create an instance of Login manager
        if AccessToken.current != nil {
            login.logOut()
            User.current = nil
        }//Check if the user is already logged in with FB (it is impossible, but just for security and debugging)
        login.logIn(permissions: readPermissions, from: self) //Requests data from API with following handler
        { (result, error) in
            if error != nil { // Shows user the information about current error
                GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error!.localizedDescription)
            } else if result?.isCancelled ?? false {
                //Cancel
            } else {
                let accessT = AccessToken.current!
                let req = GraphRequest(graphPath: "me", parameters: ["fields": "name,email,picture.width(480).height(480)"], tokenString: accessT.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET"))
                req.start(completionHandler: { (connection, result, error) in
                    if error == nil {
                        if let res = result as? [String : Any] {
                            print("RES: \(res)")
                           self.email = res["email"] as? String
                           if let fullname = res["name"] as? String,
                              let id = res["id"] as? String {
                                self.fullname = fullname
                                self.id = "fb"+id
                                if let imageURL = ((res["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                                    print("imageURL: \(imageURL)")
                                    self.imageURL = imageURL
                                }
                                self.perform(#selector(self.callAnotherFunc), with: nil, afterDelay: 0.5)
                                self.checkForId(id: self.id)
                            }
                        } else {
                            GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "Unexpected error!")
                        }
                    } else {
                        GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error!.localizedDescription)
                    }
                })
            }
        }
    }
    
    
    @objc func callAnotherFunc() { 
        self.checkForId(id: self.id)
    }
    
    
    
    //Login with VK
     //Takes permissions we ask from the user during auth
    private func loginWithVK(scope : [String]) {
        if VKSdk.accessToken() != nil {
            VKSdk.forceLogout()
        }//Check if user is already logged in with VK
        VKSdk.authorize(scope) //Authorize with properties above
    }
    
    
    //Func login with usernameOrEmail
    //Takes username and password
    private func loginWithUsernameOrEmail(usernameOrEmail: String, password: String, isEmail: Bool) {
        var params : Parameters
        if isEmail {
            params = ["email" : usernameOrEmail, "password" : password]
        } else {
            params = ["username" : usernameOrEmail, "password" : password]
        }//Create params for Alamofire POST
        let api_host = GlobalServices.API_HOST //Get constant from GS
        let text = isEmail ? "email" : "username" // identify which backend function we gonna trigger
        Alamofire.request(api_host+"/login/"+text, method:.post,parameters:params as Parameters).responseData // make Alamofire POST with the following response handler
            { response in switch response.result {
            case .success(let data): // case success: we check status of our response to handle some errors
                switch response.response?.statusCode ?? -1 {
                case 200: //200: everything is OK, fill current user field
                    self.didLogin(userData: data)
                case 401: //401: Username or password incorrect
                    GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "User doesnt exist")
                default: //Something went really wrong
                    GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "Unexpected error")
                }
            case .failure(let error): // case failure: let the user see where is the problem
                GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error.localizedDescription)
                }
            }
    }
    
    
    // Func, that tolds the server that the user has forgotten password
    private func forgotPassword() {
       self.performSegue(withIdentifier: "signInToForgotPassword", sender: self)
    }
    
    
    
    
    //VK DELEGATE
    
    //If VKApp wants to show user its view, we allow it
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }
    
    //Func passes VKToken in GlobalServices or shows alert
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
      /*  if (result?.token != nil) {
            self.email = result!.token?.email
            self.id = "vk"+result!.token.userId
            let req = VKRequest(method: "account.getProfileInfo", parameters: nil/*["fields" : "photo_50"]*/)
            req?.execute(resultBlock: { (response) in
                if let dict = response?.json as? [String : Any] {
                    print("DICT: \(dict)")
                    //guard let imageUrl = dict["photo_50"] as? String else {GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "Cannot convert data from VK"); return}
                    //print("IMAGEURL: \(imageUrl)")
                    guard let first = dict["first_name"] as? String else {GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "Cannot convert data from VK"); return}
                    guard let second = dict["last_name"] as? String else {GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "Cannot convert data from VK"); return}
                    self.fullname = first+" "+second
                    self.vkShouldGo = true
                }
            }, errorBlock: { (error) in
               GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error?.localizedDescription)
            })
            //Segue to the next view
        } else if result.error != nil {
            GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: result.error.localizedDescription)
        } */
        if result.token == nil {
            GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "Something wrong with VK")
        }
        
    }
    
    //Triggers if the authorization via VK is failed
    func vkSdkUserAuthorizationFailed() {
        //Вывести alert какой нибудь
    }
    
    func vkSdkAuthorizationStateUpdated(with result: VKAuthorizationResult!) {
        if result.token != nil {
            self.email = result.token.email
            self.id = result.token.userId
            self.fullname = result.token.localUser.first_name+" "+result.token.localUser.last_name
            self.imageURL = result.token.localUser.photo_100
            self.vkShouldGo = true
        }
    }
    
    func vkSdkDidDismiss(_ controller: UIViewController!) {
        if (self.vkShouldGo) && (controller is SFSafariViewController) {
            self.checkForId(id: self.id)
        }
    }
    
    //TFDelegate
    
    //Func used for jumping to the next TF the user should fill
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailTF:
            self.passwordTF.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    //Func used for rewriting placeholders in case there was a description of the error
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
            var text = GlobalServices.language == "en" ? "Username or Email" : "Имя пользователя или Email"
            self.emailTF.setPlaceholder(text: "Username or Email", color: self.placeholderColor) //исправить, когда будет язык
       
            text = GlobalServices.language == "en" ? "Password" : "Пароль"
            self.passwordTF.setPlaceholder(text: "Password", color: self.placeholderColor) //исправить, когда будет язык
       
    }
    
    
    @IBAction func btnForgotPasswordTapped(_ sender: UIButton) {
        self.forgotPassword()
    }
    
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        var todo = true //Used as a flag that answers a question: Should we try to connect to the server with current fields?
        let text = GlobalServices.language == "en" ? "Fill this field" : "Заполните это поле" //A placeholder text in case some field is empty
        
        let emailOrUsername = GlobalServices.cutCutCut(text: self.emailTF.text)
        let password = self.passwordTF.text
        
        
        //Check if emailTF is empty
        if (emailOrUsername == "") || (emailOrUsername == nil) {
            todo = false
            self.emailTF.setPlaceholder(text: text, color: self.placeholderColor)
            self.shakeTF(viewToShake: self.emailTF)
        }
        
        //Check if passwordTF is empty
        if (password == "") || (password == nil) {
            todo = false
            self.passwordTF.setPlaceholder(text: text, color: self.placeholderColor)
            self.shakeTF(viewToShake: self.passwordTF)
        }
        
        
        if todo {
            self.loginWithUsernameOrEmail(usernameOrEmail: emailOrUsername!, password: password!, isEmail: emailOrUsername!.contains("@"))
        }
        
    }
    
    //Login with Facebook
    @IBAction func btnFBTapped(_ sender: UIButton) {
        self.loginWithFacebook(readPermissions: ["public_profile", "email", "user_friends", "user_location", "user_photos"])
    }
    
    //Login  with VK
    @IBAction func btnVKTapped(_ sender: UIButton) {
        self.loginWithVK(scope: ["email", "friends", "photos", "offline"])
    }
    
    
    
    // If the user does not have an account, pass to register view
    @IBAction func btnDoNotHaveAnAccountTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "signInToSignUp", sender: self)
    }
    
    // A button with an eye for switching security of text entry in password textField
    @IBAction func btnSecureTextEntryTapped(_ sender: UIButton) {
        self.passwordTF.isSecureTextEntry = !self.passwordTF.isSecureTextEntry
    }
    
}


//An additional function for TextField which takes
//Takes: text, color
//Changes a placeholder to the placeholder with text and color it took
extension UITextField {
    func setPlaceholder(text : String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}
