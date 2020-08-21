//
//  KeychainManager.swift
//  Touch Novel
//
//  Created by Tong Yi on 8/21/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class KeychainManager: NSObject {
    // MARK: - Create the key for request
    class func createQuaryMutableDictionary(identifier:String)->NSMutableDictionary{
        // create a dictionary
        let keychainQuaryMutableDictionary = NSMutableDictionary.init(capacity: 0)
        // set the store type
        keychainQuaryMutableDictionary.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
        // set the store mark
        keychainQuaryMutableDictionary.setValue(identifier, forKey: kSecAttrService as String)
        keychainQuaryMutableDictionary.setValue(identifier, forKey: kSecAttrAccount as String)
        // set the accessbility
        keychainQuaryMutableDictionary.setValue(kSecAttrAccessibleAfterFirstUnlock, forKey: kSecAttrAccessible as String)
        
        return keychainQuaryMutableDictionary
    }
    
    // MARK: - store the data
    class func keyChainSaveData(data:Any ,withIdentifier identifier:String)->Bool {
        // read the key to store data
        let keyChainSaveMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // delete old value
        SecItemDelete(keyChainSaveMutableDictionary)
        // settting value
        keyChainSaveMutableDictionary.setValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
        // store value
        let saveState = SecItemAdd(keyChainSaveMutableDictionary, nil)
        if saveState == noErr  {
            return true
        }
        return false
    }

    // MARK: - Update Data
    class func keyChainUpdata(data:Any ,withIdentifier identifier:String)->Bool {
        // read the key for update
        let keyChainUpdataMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // create the dic for storing data
        let updataMutableDictionary = NSMutableDictionary.init(capacity: 0)
        // setting value
        updataMutableDictionary.setValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
        // update value
        let updataStatus = SecItemUpdate(keyChainUpdataMutableDictionary, updataMutableDictionary)
        if updataStatus == noErr {
            return true
        }
        return false
    }
    
    
    // MARK: - Read Data
    class func keyChainReadData(identifier:String)-> Any {
        var idObject:Any?
        
        let keyChainReadmutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // provide two required parameters for request
        keyChainReadmutableDictionary.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        keyChainReadmutableDictionary.setValue(kSecMatchLimitOne, forKey: kSecMatchLimit as String)
        // create the object for reading data
        var queryResult: AnyObject?
        // through the request to know whether it has that value or not
        let readStatus = withUnsafeMutablePointer(to: &queryResult) { SecItemCopyMatching(keyChainReadmutableDictionary, UnsafeMutablePointer($0))}
        if readStatus == errSecSuccess {
            if let data = queryResult as! NSData? {
                idObject = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as Any
            }
        }
        return idObject as Any
    }
    
    
    
    // MARK: - Delete Data
    class func keyChianDelete(identifier:String)->Void{
        // read the key for delete
        let keyChainDeleteMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // delete the data
        SecItemDelete(keyChainDeleteMutableDictionary)
    }
}

