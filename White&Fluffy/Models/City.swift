//
//  City.swift
//  White&Fluffy
//
//  Created by Алексей Муренцев on 07.09.2020.
//  Copyright © 2020 Алексей Муренцев. All rights reserved.
//

import Foundation
import RealmSwift

final class City: Object, Decodable {
    
    //@objc dynamic let name: String
    @objc dynamic var lat: Double
    @objc dynamic var lon: Double
    @objc dynamic var url: String
    
    override static func primaryKey() -> String? {
           return "url"
       }
}

struct TableData {
    var city: City
    var degree: Int
    var icon: String
}
