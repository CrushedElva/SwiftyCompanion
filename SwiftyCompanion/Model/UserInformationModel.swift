//
//  UserInformationModel.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 29.04.2021.
//

import Foundation
import ObjectMapper

class UserInformationModel: Mappable {
    var id = 0
    var email = ""
    var login = ""
    var fullName = ""
    var imageUrl = ""
    var correctionPoint = 0
    var wallet = 0
    var anonymizeDate = ""
    var userCourse: [UserCourseModel] = []
    var projectsUser: [ProjectsUserModel] = []
    var achievements: [AchievementsModel] = []
    var campus: [CampusModel] = []
        
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        email <- map["email"]
        login <- map["login"]
        fullName <- map["usual_full_name"]
        imageUrl <- map["image_url"]
        correctionPoint <- map["correction_point"]
        wallet <- map["wallet"]
        anonymizeDate <- map["anonymize_date"]
        userCourse <- map["cursus_users"]
        projectsUser <- map["projects_users"]
        achievements <- map["achievements"]
        campus <- map["campus"]
    }
}
