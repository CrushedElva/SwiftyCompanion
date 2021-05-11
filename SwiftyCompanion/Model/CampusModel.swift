//
//  CampusModel.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 30.04.2021.
//

import Foundation
import ObjectMapper

class CampusModel: Mappable {
    var id = 0
    /// Город в котором находится кампус
    var name = ""
        
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
