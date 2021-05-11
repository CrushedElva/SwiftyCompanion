//
//  SkillsModel.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 29.04.2021.
//

import Foundation
import ObjectMapper

class SkillsModel: Mappable {
    var id = 0
    var level = 0
    var name = ""
        
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        level <- map["level"]
        name <- map["name"]
    }
}
