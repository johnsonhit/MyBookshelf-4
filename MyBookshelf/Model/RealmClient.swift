//
//  RealmClient.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 12/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import Foundation
import RealmSwift

class RealmClient {
    
    static let shared = RealmClient()
    let realm = try! Realm()
    
    func updateUserNote(isbn13: String, note: String, date: Date, title: String) {
        do {
            try realm.write {
                realm.create(UserNote.self, value: UserNote(isbn13: isbn13, note: note, date: date, title: title), update: .all)
                print("[REALM UPDATE SUCCESS] realm write updateUserNote success")
            }
        } catch let error as NSError {
            print("[REALM UPDATE FAIL] create userinfo from updateUserNote \(error)")
        }
        
    }
    

    func retrieveUserNote(isbn13: String) -> UserNote? {
        
        if let obj = realm.object(ofType: UserNote.self, forPrimaryKey: isbn13) {
            print("[Realm LOAD] loadUserNote success")
            return obj
        }
        return nil
    }

    func loadAllUserNotes(completion: @escaping (([UserNote]) -> Void)) {
        
        let obj = realm.objects(UserNote.self)
        completion(Array(obj))
        
    }
    
}
