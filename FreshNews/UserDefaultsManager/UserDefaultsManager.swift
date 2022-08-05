//
//  UserDefaultsManager.swift
//  FreshNews
//
//  Created by Rafayel Aghayan  on 05.08.22.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()

    // MARK: KEYS
    let encodedObject = "rEncodedObject"
    
    
    // MARK: SET VALUE FOR KEY
    public func setEncodedObject(object: Any, forKey: EncodedObjectsKeys) {
        switch forKey {
        case .freshNewsModel:
            let objectType = object as! [FreshNewsModel]
            guard let data = try? JSONEncoder().encode(objectType) else { return }
            let key = encodedObject + "_" + forKey.rawValue
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    // MARK: DELETE VALUE FOR KEY
    
    public func deleteEncodedObjectList(forKey: EncodedObjectsKeys) {
        let key = encodedObject + "_" + forKey.rawValue
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    // MARK: GET VALUE FOR KEY
    
    public func getEncodedObject(forKey: EncodedObjectsKeys) -> Any? {
        
        switch forKey {
        case .freshNewsModel:
            let key = encodedObject + "_" + forKey.rawValue
            guard let data = UserDefaults.standard.data(forKey: key),
            let object = try? JSONDecoder().decode([FreshNewsModel].self, from: data)
            else { return nil }
            return object
        }
    }
}
