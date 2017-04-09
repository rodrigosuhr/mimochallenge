//
//  AuthUtils.swift
//  MimoiOSCodingChallenge
//
//  Created by Rodrigo Suhr on 4/9/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import UIKit
import Alamofire

protocol AuthUtilsProtocol : class {
    func onSignupError(message: String)
    func onLoginSuccess()
    func onLoginError(message: String)
}

class AuthUtils: NSObject {
    weak var delegate : AuthUtilsProtocol?
    static let IS_AUTH_KEY = "MimoiOSCodingChallenge_isAuthenticated";
    static let USER_ID_KEY = "MimoiOSCodingChallenge_userID";
    static let USER_EMAIL_KEY = "MimoiOSCodingChallenge_userEmail";
    static let ACCESS_TOKEN_KEY = "MimoiOSCodingChallenge_userEmail"
    
    static let CLIENT_ID = "PAn11swGbMAVXVDbSCpnITx5Utsxz1co";
    static let CONNECTION_NAME = "Username-Password-Authentication";
    
    class func isAuthenticated() -> Bool {
        return UserDefaults.standard.bool(forKey: IS_AUTH_KEY)
    }
    
    func authenticate(_ token: String) {
        UserDefaults.standard.set(true, forKey: AuthUtils.IS_AUTH_KEY)
        UserDefaults.standard.set(token, forKey: AuthUtils.ACCESS_TOKEN_KEY)
    }
    
    func signUp(_ email: String, _ passwd: String ) {
        let parameters: Parameters = [
            "client_id": AuthUtils.CLIENT_ID,
            "email": email,
            "password": passwd,
            "connection": AuthUtils.CONNECTION_NAME
        ]
        
        Alamofire.request("https://mimo-test.auth0.com/dbconnections/signup/", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if ((response.error) == nil) {
                let json = response.result.value as! NSDictionary
                
                if json["code"] != nil {
                    self.delegate?.onSignupError(message: json.value(forKey: "description") as! String)
                } else {
                    UserDefaults.standard.set(json.value(forKey: "_id") as! String, forKey: AuthUtils.USER_ID_KEY)
                    UserDefaults.standard.set(json.value(forKey: "email") as! String, forKey: AuthUtils.USER_EMAIL_KEY)
                    
                    self.logIn(email, passwd)
                }
            }
            
        }
    }
    
    func logIn(_ username: String, _ passwd: String ) {
        let parameters: Parameters = [
            "client_id": AuthUtils.CLIENT_ID,
            "username": username,
            "password": passwd,
            "connection": AuthUtils.CONNECTION_NAME,
            "grant_type": "password"
        ]
        
        Alamofire.request("https://mimo-test.auth0.com/oauth/ro/", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if ((response.error) == nil) {
                let json = response.result.value as! NSDictionary
                
                if json["error"] != nil {
                    self.delegate?.onLoginError(message: json.value(forKey: "error_description") as! String)
                } else {
                    self.authenticate(json.value(forKey: "access_token") as! String)
                    self.delegate?.onLoginSuccess()
                }
            }
            
        }
    }
    
    class func logOut() {
        UserDefaults.standard.set(false, forKey: IS_AUTH_KEY)
    }
}
