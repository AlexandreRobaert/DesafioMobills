//
//  Expense.swift
//  DesafioMobills
//
//  Created by Alexandre Robaert on 10/06/21.
//

import Foundation
import FirebaseFirestore

public struct Moviment: Codable {
    
    var id: String?
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
    
    internal init(id: String? = nil, value: Float, description: String, effected: Bool = false, date: Date, expose: Bool) {
        self.id = id
        self.value = value
        self.description = description
        self.effected = effected
        self.date = date
        self.expose = expose
    }
    
    init(id idDocument: String, data: [String: Any]) {
        self.id = idDocument
        self.value = data["value"] as! Float
        self.description = data["description"] as! String
        self.effected = data["effected"] as! Bool
        self.date = (data["date"] as! Timestamp).dateValue()
        self.expose = data["expose"] as! Bool
    }
    
    func toDictionary()-> [String: Any]{
        return ["value": value,
                "description": description,
                "date": Timestamp(date: date),
                "effected": effected,
                "expose": expose
        ]
    }
}
