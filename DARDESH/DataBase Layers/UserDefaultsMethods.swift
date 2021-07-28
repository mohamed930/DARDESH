//
//  UserDefaultsMethods.swift
//  DARDESH
//
//  Created by Mohamed Ali on 09/07/2021.
//

import Foundation

class UserDefaultsMethods {
    
    static func SaveDataToUserDefaults<T:Codable>(Key: String ,_ user: T, completion: @escaping (String) -> (Void)) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(user.self)
            UserDefaults.standard.setValue(data, forKey: Key)
            completion("Success")
            
        } catch {
            print(error.localizedDescription)
            completion(error.localizedDescription)
        }
    }
    
    static func loadDataFromUserDefaults<T:Codable>(Key: String, className: T.Type) -> T? {
        let savedPerson = UserDefaults.standard.object(forKey: Key) as? Data
        let decoder = JSONDecoder()
        if let loadedPerson = try? decoder.decode(T.self, from: savedPerson!) {
           return loadedPerson
        }
        else {
            return nil
        }
    }
}
