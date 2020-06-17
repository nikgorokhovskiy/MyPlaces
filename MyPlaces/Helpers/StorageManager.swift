//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Admin on 22.01.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place) {
        
        try! realm.write {
            realm.add(place)
        }
    }
    
    static func deleteObject(_ place: Place) {
        
        try! realm.write {
            realm.delete(place)
        }
    }
}

