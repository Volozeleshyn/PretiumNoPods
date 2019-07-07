//
//  GlobalServices.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 03/03/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import VK_ios_sdk

class GlobalServices {
    
    static var language = UserDefaults.standard.string(forKey: "Language") ?? "en"// current language
    
    
    static let API_HOST = "http://localhost:8000" //constant API_HOST of the server
    static let SOCK_HOST = "ws://localhost:8000" //constant SOCK_HOST of the server
    
    //Func shows alert
    //Takes: VC, where to show alert
    // title of the alert
    // message or the alert
    public static func showAlert(where vc : UIViewController, withTitle title : String?, andMessage message : String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismiss)
        vc.present(alert, animated: true, completion: nil)
    }
    
    //Func cuts spaces before and after the text
    //Takes: text to cut
    //Returns: cut text
    public static func cutCutCut(text : String?) -> String? {
        var t = text
        if t != nil {
            while (t!.last == " ") {
                t!.removeLast()
            }
            while t!.first == " " {
                t!.removeFirst()
            }
            return t
        } else {
            return nil
        }
    }
    

}

