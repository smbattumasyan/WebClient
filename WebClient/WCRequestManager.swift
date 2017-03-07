//
//  WCRequestManager.swift
//  WebClient
//
//  Created by Smbat Tumasyan on 12.01.17.
//  Copyright © 2017 EGS. All rights reserved.
//

import UIKit

class WCRequestManager: NSObject {
    
    let kLoginUrl       = "http://10.1.6.233:8080/login"
    let kRegstrationUrl = "http://10.1.6.233:8080/registration"
    
    func loginRequest(paramDict:NSDictionary, completionHandler:@escaping (Data?, URLResponse?, Error?) -> Void) {
        let loginUrl = URL(string: kLoginUrl)
        var request  = URLRequest(url: loginUrl!)
        
        
        if let username = paramDict["username"], let passwrod = paramDict["password"] {
            
            let postData = NSMutableData(data:String(format:"username=\(username)").data(using: .utf8)!)
            postData.append(String(format:"&password=\(passwrod)").data(using: .utf8)!)
            request.httpBody = postData as Data
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Length")
            request.httpMethod = "POST"
            URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
        }
    }
    
    func registrationRequest(paramDict:NSDictionary, completionHandler:@escaping (Data?, URLResponse?, Error?) -> Void) {
        let registrationURL = URL(string: kRegstrationUrl)
        var request         = URLRequest(url: registrationURL!)
        
        if let username = paramDict["username"],
            let password  = paramDict["password"],
            let name      = paramDict["name"],
            let email     = paramDict["email"],
            let userImage = paramDict["userImage"] {
            
            let postData = NSMutableData(data:String(format:"username=\(username)").data(using: .utf8)!)
            postData.append(String(format:"&password=\(password)").data(using: .utf8)!)
            postData.append(String(format:"&name=\(name)").data(using: .utf8)!)
            postData.append(String(format:"&email=\(email)").data(using: .utf8)!)
            postData.append(String(format:"&userImage=\(userImage)").data(using: .utf8)!)
            request.httpBody = postData as Data
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Length")
            request.httpMethod = "POST"
            URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
        }
    }
}
