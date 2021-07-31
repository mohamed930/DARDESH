//
//  RealmswiftLayer.swift
//  DARDESH
//
//  Created by Mohamed Ali on 28/07/2021.
//

import Foundation
import RealmSwift

class RealmswiftLayer {
    
    static let realm = try! Realm()
    
    // MARK:- TODO:- This Generatics Method For Save Message into RealmSwift.
    public static func Save<T: Object> (_ object: T) {
        
        do {
            try realm.write {
                realm.add(object,update: .all)
            }
        } catch {
            print("Error \(error.localizedDescription)")
        }
        
    }
    // ------------------------------------------------
}
