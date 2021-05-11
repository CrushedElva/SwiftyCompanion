//
//  Constants.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 30.04.2021.
//

import Foundation
import UIKit

enum Constants {
    static let clientId = "f476b13cde49ba6a26c8c50402b4785ffe31ebd12934abeed20f7c45cd995bcf"
    static let clientSecret = "8fc4c6e7c5da1f9c6996da054e982cb1a743d3a3c5a6832b085193455357c32a"
    static let tokenURL = "https://api.intra.42.fr/oauth/token"
    static let baseURL = "https://api.intra.42.fr"
    static let scope = "public"
    static let redirectURL = "https://api.intra.42.fr/apidoc/guides/getting_started"
    static let parameters: [String : String] = ["grant_type":"client_credentials"]
    static let appDelegate = UIApplication.shared.delegate as? AppDelegate
}
