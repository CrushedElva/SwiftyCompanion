//
//  AppDelegate.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 13.04.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var auth = OAuth2Client(configuration: OAuth2Configuration())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let app = Constants.appDelegate {
            app.auth = OAuth2Client(configuration: OAuth2Configuration(
                                        clientId: Constants.clientId,
                                        clientSecret: Constants.clientSecret,
                                        tokenURL: Constants.tokenURL,
                                        scope: Constants.scope,
                                        redirectURL: Constants.redirectURL,
                                        parameters: Constants.parameters))
            
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

