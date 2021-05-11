//
//  AchievementsModel.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 29.04.2021.
//

import Foundation
import ObjectMapper

class AchievementsModel: Mappable {
    var id = 0
    var description = ""
    var name = ""
    var kind = ""
    var image = ""
        
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        description <- map["description"]
        name <- map["name"]
        kind <- map["kind"]
        image <- map["image"]
    }
}
