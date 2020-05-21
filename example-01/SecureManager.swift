//
//  SecureManager.swift
//  example-01
//
//  Created by Sergey Chehuta on 21/05/2020.
//  Copyright © 2020 WhiteTown. All rights reserved.
//

import Foundation

class SecureManager {
    
    static func deleteKeychain(query:[String:Any]) -> Bool {
        let result = SecItemDelete(query as CFDictionary)
        return result == errSecSuccess
    }
    
    static func deleteLogin(login: String) -> Bool {
        let query : [String:Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: login]
        return deleteKeychain(query: query)
    }
    
    static func updateKeychain(query: [String:Any],
                               attrs: [String:Any]) -> Bool {
        let result = SecItemUpdate(query as CFDictionary, attrs as CFDictionary)
        return result == errSecSuccess
    }
    
    static func updatePassword(login: String, password: String) -> Bool {
        let pwData = password.data(using: .utf8)!
        let query : [String:Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: login]
        let attrs : [String:Any] = [kSecValueData as String: pwData]
        return updateKeychain(query: query, attrs: attrs)
    }
    
    static func findInKeychain(query : [String:Any]) -> String? {
        var item: CFTypeRef?
        let result = SecItemCopyMatching(query as CFDictionary, &item)
        guard result == errSecSuccess else { return nil }
        
//        let msg = SecCopyErrorMessageString(result, nil)
//        print (msg)
        
        if let pwData = item as? Data {
            let password = String(data: pwData, encoding: .utf8)
            return password
        }
        
        return nil
    }
    
    static func retrievePassword(login: String) -> String? {
        let query : [String:Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: login,
//                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true
        ]
        return findInKeychain(query: query)
    }

    static func addToKeychain(query : [String:Any]) -> Bool {
        let result = SecItemAdd(query as CFDictionary, nil)
        if #available(iOS 11.3, *) {
            let msg = SecCopyErrorMessageString(result, nil)
            print (msg)
        } else {
            // Fallback on earlier versions
        }
        return result == errSecSuccess
    }

    static func storeLogin(login: String, password : String) -> Bool {

        let pwData = password.data(using: .utf8)!
        let query : [String:Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: login,
                                    kSecValueData as String: pwData
        ]
        return addToKeychain(query: query)
    }
}
