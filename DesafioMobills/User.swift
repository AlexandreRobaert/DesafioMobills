//
//  User.swift
//  DesafioMobills
//
//  Created by Alexandre Robaert on 10/06/21.
//

import Foundation

struct User {
    var id: String
    var name: String
    var email: String
    var password: String
    
    func toDictinary() -> [String: Any]{
        return ["name": name,
                "email": email,
                "password": password
        ]
    }
}
