//
//  KeychainService.swift
//  movieapp
//
//  Created by mops on 10/20/23.
//

import Foundation
import AuthenticationServices

func keychainSave(_ data: Data, service: String, account: String) -> Bool{
    let query = [
        kSecValueData: data,
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: account
    ] as CFDictionary
    
    let saveStatus = SecItemAdd(query, nil)
    
    if saveStatus != errSecSuccess {
        print("Error: \(saveStatus)")
    }
    
    if saveStatus == errSecDuplicateItem {
        keychainUpdate(data, service: service, account: account)
        return true
    }
    
    return false
}

func keychainUpdate(_ data: Data, service: String, account: String) {
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: account
    ] as CFDictionary
    
    let updatedData = [kSecValueData: data] as CFDictionary
    SecItemUpdate(query, updatedData)
}

func keychainRead(service: String, account: String) -> Data? {
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: account,
        kSecReturnData: true
    ] as CFDictionary
    
    var result: AnyObject?
    SecItemCopyMatching(query, &result)
    return result as? Data
}

func keychainDelete(service: String, account: String) {
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: account
    ] as CFDictionary
    
    SecItemDelete(query)
}
