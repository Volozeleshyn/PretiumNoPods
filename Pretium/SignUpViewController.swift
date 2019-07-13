//
//  SignUpViewController.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 30/03/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import UIKit
import Alamofire


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    //Outlets linking to the objects in storyboard
    @IBOutlet weak var btnSignUp: UIButton!
  
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var fullNameTxtField: UITextField!
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    
    
    let placeholderColor = UIColor.gray
     
    var moved = false // a boolean variable, that shows if the screen was moved up because of the keyboard 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.configureViews()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateLanguage()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
        if self.moved {
            self.moveBack()
        }
    }
    
    
    private func configureViews() {
        
        //make TFs follow self as a delegate
        self.fullNameTxtField.delegate = self
        self.userNameTxtField.delegate = self
        self.emailTxtField.delegate = self
        self.passwordTxtField.delegate = self
        self.confirmPasswordTxtField.delegate = self
        
        //set placeholders
        self.fullNameTxtField.setPlaceholder(text: "First name", color: self.placeholderColor)
        self.userNameTxtField.setPlaceholder(text: "Username", color: self.placeholderColor)
        self.emailTxtField.setPlaceholder(text: "E-mail", color: self.placeholderColor)
        self.passwordTxtField.setPlaceholder(text: "Password", color: self.placeholderColor)
        self.confirmPasswordTxtField.setPlaceholder(text: "Password confirmation", color: self.placeholderColor)
        
        //set a color and an image for button back
        let origImage = UIImage(named: "outline_keyboard_arrow_left_white_48pt_3x");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)//we need this rendering mode so that when we change tint color of button, the image changes its color too
        self.btnBack.setImage(tintedImage, for: .normal)
        let color =  UIColor(red: 227/255, green: 170/255, blue: 159/255, alpha: 1) //be careful: this init of UIColor takes CGFloat from 0 to 1, that's why we should divide a normal RGB by 255
        self.btnBack.tintColor = color
    }
    
    private func updateLanguage() {
        //DO !!!
    }
    
    private func shakeTF(viewToShake : UITextField) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 10, y: viewToShake.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 10, y: viewToShake.center.y))
        
        viewToShake.layer.add(animation, forKey: "position")
    }
    
    private func move() {
        let movementRange : CGFloat = 148
        self.view.center.y -= movementRange
        self.moved = true
    }
    
    private func moveBack() {
        let movementRange : CGFloat = 148
        self.view.center.y += movementRange
        self.moved = false
    }
    
    //Func is used for signing in via server
    // Takes: a future username, a real name, an email and password
    private func signUpWithServer(username: String, fullname: String, email: String, password: String) {
        let params = ["username" : username, "fullname" : fullname, "email" : email, "password" : password] // make params for POST
        let api_host = GlobalServices.API_HOST // get const from GS
        Alamofire.request(api_host+"/signup",method:.post,parameters:params as Parameters).responseData // make request to the server with API, method POST, POST params and following answer handler
            { response in switch response.result {
            case .success(let data): // success, we got something, that looks like an answer
                switch response.response?.statusCode ?? -1 {
                case 200: //everything OK, put the user in User, make fields of TFs empty and pass to the next VC
                    do {
                        
                        User.current = try JSONDecoder().decode(User.self, from: data) // decode data that we got from the server into an instance of a user, and put it in current user
                        let def = UserDefaults.standard
                        def.setValue(User.current!.username, forKey: "UserUsername")
                        def.setValue(User.current!.fullname, forKey: "UserFullname")
                        def.setValue(User.current!.email, forKey: "UserEmail")
                        def.setValue(User.current!.id, forKey: "UserId")
                        def.setValue(User.current!.imageURL, forKey: "UserImageURL")
                        def.setValue(User.current!.metersWalked, forKey: "UserMetersWalked")
                        def.setValue(User.current!.adsPrefered, forKey: "UserAdsPrefered")
                        self.fullNameTxtField.text = ""
                        self.userNameTxtField.text = ""
                        self.emailTxtField.text = ""
                        self.passwordTxtField.text = ""
                        self.confirmPasswordTxtField.text = ""
                        self.performSegue(withIdentifier: "signUpCorrect", sender: self)//Move to the next view
                    } catch {
                        GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error.localizedDescription) //catch an error if we had problems in decoding data
                    }
                case 403: // error 403: Username already taken, change placeholder, and shake username TF
                    self.userNameTxtField.text = ""
                    let text = GlobalServices.language == "en" ? "Username already taken" : "Имя пользователя уже выбрано"
                    self.userNameTxtField.setPlaceholder(text: text, color: self.placeholderColor)
                    self.shakeTF(viewToShake: self.userNameTxtField)
                case 405: //error 405: User with this email already exists, change placeholder and shake username TF (maybe we should ask him if he forgot his password)
                    self.emailTxtField.text = ""
                    let text = GlobalServices.language == "en" ? "Email already registered" : "Email уже зарегестрирован"
                    self.emailTxtField.setPlaceholder(text: text, color: self.placeholderColor)
                    self.shakeTF(viewToShake: self.emailTxtField)
                    //Предложить типо забыли пароль
                    
                default: //Something went really wrong with the data we got and we can't even understand why (often it is because of the broken connection)
                    GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: "Unexpected error")
                }
            case .failure(let error): //failure, we didn't get anything from the server
                GlobalServices.showAlert(where: self, withTitle: "Ooops!", andMessage: error.localizedDescription)
                }
        }
    }
    
    
    //TF DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fullNameTxtField:
            self.userNameTxtField.becomeFirstResponder()
        case userNameTxtField:
            self.emailTxtField.becomeFirstResponder()
        case emailTxtField:
            self.passwordTxtField.becomeFirstResponder()
        case passwordTxtField:
            self.confirmPasswordTxtField.becomeFirstResponder()
        case self.confirmPasswordTxtField:
            self.moveBack()
            fallthrough
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !moved {
            self.move()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
            var text = GlobalServices.language == "en" ? "First name" : "Настоящее имя"
            self.fullNameTxtField.setPlaceholder(text: text, color: self.placeholderColor)
        
            text = GlobalServices.language == "en" ? "Username" : "Имя пользователя"
            self.userNameTxtField.setPlaceholder(text: text, color: self.placeholderColor)
        
            self.emailTxtField.setPlaceholder(text: "E-mail", color: self.placeholderColor)
       
            text = GlobalServices.language == "en" ? "Password" : "Пароль"
            self.passwordTxtField.setPlaceholder(text: text, color: self.placeholderColor)
       
            text = GlobalServices.language == "en" ? "Password confirmation" : "Повторите пароль"
            self.confirmPasswordTxtField.setPlaceholder(text: text, color: self.placeholderColor)
       
    }


    
    
    
    
    @IBAction func btnSignUpTapped(_ sender: UIButton) {
        var todo = true
        let username = GlobalServices.cutCutCut(text: self.userNameTxtField.text)
        let fullname = self.fullNameTxtField.text
        let email = self.emailTxtField.text
        let password = self.passwordTxtField.text
        let confirmPassword = self.confirmPasswordTxtField.text
        
        let text = GlobalServices.language == "en" ? "Fill this field" : "Заполните это поле"
        if (fullname == "") || (fullname == nil) {
            todo = false
            self.fullNameTxtField.setPlaceholder(text: text, color: self.placeholderColor)
            self.shakeTF(viewToShake: self.fullNameTxtField)
        }
        if (username == "") || (username == nil) {
            todo = false
            self.userNameTxtField.setPlaceholder(text: text, color: self.placeholderColor)
            self.shakeTF(viewToShake: self.userNameTxtField)
        }
        if username?.contains("@") ?? false {
            todo = false
            self.userNameTxtField.text = ""
            self.userNameTxtField.setPlaceholder(text: "Username shouldn't contain @", color: self.placeholderColor)
            self.shakeTF(viewToShake: self.userNameTxtField)
        }
        if (!(email?.contains("@") ?? true)) { // } || (!(email?.contains(".") ?? true)) { А надо ли?
            todo = false
            self.emailTxtField.text = ""
            self.emailTxtField.setPlaceholder(text: "That's not an email adress", color: self.placeholderColor)
            self.shakeTF(viewToShake: self.emailTxtField)
        }
        if (email == "") || (email == nil) {
            todo = false
            self.emailTxtField.setPlaceholder(text: text, color: self.placeholderColor)
            self.shakeTF(viewToShake: self.emailTxtField)
        }
        if (password == "") || (password == nil) {
            todo = false
            self.passwordTxtField.setPlaceholder(text: text, color: self.placeholderColor)
            self.shakeTF(viewToShake: self.passwordTxtField)
        }
        if (password != confirmPassword) {
            todo = false
            self.confirmPasswordTxtField.text = ""
            let t = GlobalServices.language == "en" ? "Passwords do not match" : "Пароли не совпадают"
            self.confirmPasswordTxtField.setPlaceholder(text: t, color: self.placeholderColor)
            self.shakeTF(viewToShake: self.confirmPasswordTxtField)
        }
        
        if todo {
            self.signUpWithServer(username: username!, fullname: fullname!, email: email!, password: password!)
        }
    }
    
    
    @IBAction func btnSecureTextEntryPasswordTapped(_ sender: UIButton) {
        self.passwordTxtField.isSecureTextEntry = !self.passwordTxtField.isSecureTextEntry
    }
    
    
    @IBAction func btnSecureTextEntryConfirmPasswordTapped(_ sender: UIButton) {
        self.confirmPasswordTxtField.isSecureTextEntry = !self.confirmPasswordTxtField.isSecureTextEntry
    }
    
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

