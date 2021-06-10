//
//  Expense.swift
//  DesafioMobills
//
//  Created by Alexandre Robaert on 10/06/21.
//

import Foundation
import FirebaseFirestore

public struct Moviment: Codable {
    var value: Float
    var description: String
    var effected: Bool = false
    var date: Date
    var expose: Bool
    
    enum CodingKeys: String, CodingKey {
        case value
        case description
        case effected
        case date
        case expose
        
    }
    
    func toDictionary()-> [String: Any]{
        return ["value": value,
                "description": description,
                "date": Timestamp(date: date),
                "affected": effected,
                "expose": expose
        ]
    }
}
