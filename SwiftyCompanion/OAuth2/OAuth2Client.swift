//
//  OAuth2Client.swift
//  OAuth2
//
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import SafariServices
import KeychainAccess
import AlamofireObjectMapper
import Alamofire
import SwiftyJSON

open class OAuth2Client {
  
  /// The OAuth2 client configuration.
    private(set) public var configuration: OAuth2Configuration
  
  /// The OAuth2 fetched access token.
    private(set)  public var token: OAuth2Token?
  
    private var safariAuthenticator: Any? = nil

    public var clientIsLoadingToken:(() -> Void) = {}
    public var clientDidFinishLoadingToken:(() -> Void) = {}
    public var clientDidFailLoadingToken:((_ NKError:Error) -> Void) = { error in

    }
  
    public init(configuration: OAuth2Configuration) {
        self.configuration = configuration
        self.token = nil
        self.loadToken()
    }
  
  /// Override to implement your own logic in subclass.
    open func loadToken() {
        if configuration.clientId != "" &&
            configuration.clientSecret != "" &&
            configuration.tokenURL != "" {
            var parameters = configuration.parameters
            parameters["client_id"] = configuration.clientId
            parameters["client_secret"] = configuration.clientSecret
        //        let parameters = ["grant_type":"client_credentials",
        //                          "client_id": configuration.clientId,
        //                          "client_secret": configuration.clientSecret]
            Alamofire.request(URL(string: configuration.tokenURL)!,
                              method: .post,
                              parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let result):
                        self.token = OAuth2Token()
                        if let json = result as? NSDictionary {
                            if let accessToken = json["access_token"] as? String {
                                self.token?.accessToken = accessToken
                                print("Token: \(accessToken)")
                            }
                            if let tokenType = json["token_type"] as? String {
                                self.token?.tokenType = tokenType
                            }
                        }
                    case .failure(let error):
                        print("\n\n===========Error===========")
                        print(error)
                        if let data = response.data, let str = String(data: data, encoding: .utf8) {
                            print("Server Error: " + str)
                        }
                        print("===========================\n\n")
                        return
                    }
            }
        } else {
            print("error: No client Id or client secret provided")
        }
    }
    
    func getDataUser(login: String,
                     completion: @escaping (UserInformationModel?, Error?) -> Void) {
        Alamofire.request(Router.getUserInformation(login: login))
            .validate(statusCode: 200..<300)
            .responseObject { (response: DataResponse<UserInformationModel>) in
                switch response.result {
                case .success(let data):
                    print(data)
                    completion(data, nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error)
                }
            }
    }
  
  /// Override to implement your own logic in subclass.
    open func saveToken() {
        if self.configuration.clientId != "" {
            let keychain = Keychain(service: "OAuth2Client.\(self.configuration.clientId)")
            if let accessToken = self.token?.accessToken, let type = self.token?.tokenType, let refreshToken = self.token?.refreshToken {
                do {
                    try keychain.synchronizable(true).set("\(accessToken)", key: "accessToken.accessToken")
                    try keychain.synchronizable(true).set("\(type)", key: "accessToken.tokenType")
                    try keychain.synchronizable(true).set("\(refreshToken)", key: "accessToken.refreshToken")
                    if let idToken = self.token?.idToken {
                    try keychain.synchronizable(true).set("\(idToken)", key: "accessToken.idToken")
                    }
                    if let accessTokenExpiry = self.token?.accessTokenExpiry {
                        let timeInterval = accessTokenExpiry.timeIntervalSinceReferenceDate
                        try keychain.synchronizable(true).set("\(timeInterval)", key: "accessToken.accessTokenExpiry")
                    }
                } catch let error {
                    print("saveToken error: \(error)")
                }
            }
        } else {
          print("error: No client Id provided")
        }
    }
  
  /// Override to implement your own logic in subclass.
    open func clearToken() {
        if self.configuration.clientId != "" {
          let keychain = Keychain(service: "OAuth2Client.\(self.configuration.clientId)")
          do {
            try keychain.remove("accessToken.accessToken")
            try keychain.remove("accessToken.tokenType")
            try keychain.remove("accessToken.refreshToken")
            try keychain.remove("accessToken.idToken")
            try keychain.remove("accessToken.accessTokenExpiry")
          } catch let error {
            print("error: \(error)")
          }
        } else {
            print("clearToken error: No client Id provided")
        }
    }
  
  open func authorize(from controller:UIViewController) {
    var urltext = "\(self.configuration.authURL)?client_id=\(self.configuration.clientId)&redirect_uri=\(self.configuration.redirectURL)"
    if self.configuration.scope != "" {
      urltext = "\(urltext)&scope=\(self.configuration.scope)"
    }
    if self.configuration.responseType != "" {
      urltext = "\(urltext)&response_type=\(self.configuration.responseType)"
    }
    for (key, value) in self.configuration.parameters {
      urltext = "\(urltext)&\(key)=\(value)"
    }
    
    if #available(iOS 11.0, *) {
      self.safariAuthenticator = SFAuthenticationSession(url: URL(string: urltext.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!, callbackURLScheme: self.configuration.redirectURL, completionHandler: { (url, error) in
        if let error = error {
          self.clientDidFailLoadingToken(OAuth2Error(localizedTitle: "Authentication failed", localizedDescription: error.localizedDescription))
        } else if let url = url {
          self.handle(redirectURL: url)
        }
      })
      if let svc = self.safariAuthenticator as? SFAuthenticationSession {
        svc.start()
      }
    } else {
      let svc = SFSafariViewController(url: URL(string: urltext.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
      svc.title = self.configuration.preferredTitle
      if #available(iOS 10.0, *) {
        svc.preferredBarTintColor = self.configuration.preferredBarTintColor
        svc.preferredControlTintColor = self.configuration.preferredTintColor
      }
      svc.modalPresentationStyle = self.configuration.preferredPresentationStyle
      self.safariAuthenticator = svc
      controller.present(svc, animated: true, completion: nil)
    }
  }
  
  open func handle(redirectURL: URL) {
    if #available(iOS 11.0, *) { } else {
      if let svc = self.safariAuthenticator as? SFSafariViewController {
        svc.dismiss(animated: true, completion: nil)
        self.safariAuthenticator = nil
      }
    }
    // show loading
    let redirectString = redirectURL.absoluteString
    if self.configuration.redirectURL.isEmpty {
      self.clientDidFailLoadingToken(OAuth2Error(localizedTitle: "No redirect URL", localizedDescription: "Oauth2 configuration is missing a redirect URL"))
      return
    }
    let components = URLComponents(url: redirectURL, resolvingAgainstBaseURL: true)
    if !(redirectString.hasPrefix(self.configuration.redirectURL)) && (!(redirectString.hasPrefix("urn:ietf:wg:oauth:2.0:oob")) && "localhost" != components?.host) {
      self.clientDidFailLoadingToken(OAuth2Error(localizedTitle: "Redirect URL mismatch", localizedDescription: "Redirect URL mismatch: expecting \(self.configuration.redirectURL) , received: \(redirectString)"))
      return
    }
    if let queryItems = components?.queryItems {
      let codeItems = queryItems.filter({ (item) -> Bool in
        if item.name == "code" {
          return true
        }
        return false
      })
      if codeItems.count > 0 {
        self.clientIsLoadingToken()
        if let code = codeItems[0].value {
          let headers = ["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json"]
          let parameters = [
            "code": "\(code)",
            "client_id": "\(self.configuration.clientId)",
            "client_secret": "\(self.configuration.clientSecret)",
            "redirect_uri": "\(self.configuration.redirectURL)",
            "grant_type": "authorization_code"
          ]
          request(self.configuration.tokenURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (responseJSON) in
            do {
              let json = try JSON(data: responseJSON.data!)
              if let responseCode = responseJSON.response?.statusCode {
                if responseCode == 200 {
                  self.token = OAuth2Token()
                  self.token?.accessToken = json["access_token"].stringValue
                  self.token?.refreshToken = json["refresh_token"].stringValue
                  self.token?.tokenType = json["token_type"].stringValue
                  self.token?.idToken = json["id_token"].stringValue
                  self.token?.accessTokenExpiry = Date().addingTimeInterval(json["expires_in"].doubleValue)
                  self.saveToken()
                  self.clientDidFinishLoadingToken()
                }
                else {
                  self.clientDidFailLoadingToken(OAuth2Error(localizedTitle: "Authentication failed", localizedDescription: "Authentication failed, resonse: \n\(json)"))
                }
              }
              else {
                self.clientDidFailLoadingToken(OAuth2Error(localizedTitle: "Invalid response", localizedDescription: "Invalid OAuth2 token response"))
              }
            }
            catch {
              self.clientDidFailLoadingToken(OAuth2Error(localizedTitle: "Invalid response", localizedDescription: "Invalid OAuth2 token response"))
            }
          }
        }
      }
      else {
        self.clientDidFailLoadingToken(OAuth2Error(localizedTitle: "Unable to extract Code", localizedDescription: "Unable to extract code: query parameters has no \"code\" parameter"))
      }
    }
    else {
      self.clientDidFailLoadingToken(OAuth2Error(localizedTitle: "Unable to extract Code", localizedDescription: "Unable to extract code: No query parameters in redirect URL"))
    }
  }
  
  open func refreshAccessToken() {
    if let tok = self.token?.refreshToken {
      let headers = ["Content-Type": "application/x-www-form-urlencoded"]
      let parameters = [
        "client_id": "\(self.configuration.clientId)",
        "client_secret": "\(self.configuration.clientSecret)",
        "redirect_uri": "\(self.configuration.redirectURL)",
        "refresh_token": "\(tok)",
        "grant_type": "refresh_token"
      ]
      request(self.configuration.tokenURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (responseJSON) in
        do {
          let json = try JSON(data: responseJSON.data!)
          if let responseCode = responseJSON.response?.statusCode {
            if responseCode == 200 {
              self.token = OAuth2Token()
              self.token?.accessToken = json["access_token"].stringValue
              self.token?.refreshToken = json["refresh_token"].stringValue
              self.token?.tokenType = json["token_type"].stringValue
              self.token?.idToken = json["id_token"].stringValue
              self.token?.accessTokenExpiry = Date().addingTimeInterval(json["expires_in"].doubleValue)
              self.saveToken()
              self.clientDidFinishLoadingToken()
            }
            else {
              self.clientDidFailLoadingToken(OAuth2Error(localizedTitle: "Authentication failed", localizedDescription: "Authentication failed, resonse: \n\(json)"))
            }
          }
          else {
            self.clientDidFailLoadingToken(OAuth2Error(localizedTitle: "Invalid response", localizedDescription: "Invalid OAuth2 token response"))
          }
        }
        catch {
          self.clientDidFailLoadingToken(OAuth2Error(localizedTitle: "Invalid response", localizedDescription: "Invalid OAuth2 token response"))
        }
      }
    }
    else {
      self.clientDidFailLoadingToken(OAuth2Error(localizedTitle: "RefreshToken missing", localizedDescription: "Invalid OAuth2 refresh token"))
    }
  }
  
  open func unauthorize() {
    self.token = nil
    self.clearToken()
  }
  
}
