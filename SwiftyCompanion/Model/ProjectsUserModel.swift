//
//  ProjectsUserModel.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 29.04.2021.
//

import Foundation
import ObjectMapper

class ProjectsUserModel: Mappable {
    var id = 0
    var finalMark = 0
    var status = ""
    var isValidated = ""
    var project: [ProjectModel] = []
        
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        finalMark <- map["final_mark"]
        status <- map["status"]
        isValidated <- map["validated?"]
        project <- map["project"]
    }
}
