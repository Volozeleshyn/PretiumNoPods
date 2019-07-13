//
//  UserModel.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 18/03/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import Foundation

struct User : Codable { // Codable because we need to encode and decode our user to pass it to the server and get it from the server correctly
    static var current : User? // current user
    var id : String
    var username : String
    var fullname : String
    var email : String
    var imageURL : String
}
