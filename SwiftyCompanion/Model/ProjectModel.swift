//
//  ProjectModel.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 29.04.2021.
//

import Foundation
import ObjectMapper

class ProjectModel: Mappable {
    var id = 0
    var parentId = 0
    var name = ""
        
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        parentId <- map["parent_id"]
        name <- map["name"]
    }
}
