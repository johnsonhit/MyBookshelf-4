//
//  UserNote.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 12/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import Foundation
import RealmSwift

class UserNote: Object {
    
    @objc dynamic var date = Date()
    @objc dynamic var isbn13 = ""
    @objc dynamic var note = ""
    @objc dynamic var title = ""
    
    override static func primaryKey() -> String? {
        return "isbn13"
    }
    
    convenience init(isbn13: String, note: String, date: Date, title: String) {
        self.init()
        self.isbn13 = isbn13
        self.note = note
        self.title = title
    }
}
