//
//  String+Enscryption.swift
//  WebClient
//
//  Created by Smbat Tumasyan on 16.01.17.
//  Copyright © 2017 EGS. All rights reserved.
//

import Foundation

extension String {
    
    func MD5() -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let d = self.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}


