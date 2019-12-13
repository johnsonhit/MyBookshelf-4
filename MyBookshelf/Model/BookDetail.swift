//
//  BookDetail.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 10/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias BookDetailInfo = (String, String)

struct BookDetail {
    
    let error: Int
    let title: String
    let subtitle: String
    let authors: String
    let publisher: String
    let isbn10: Int
    let isbn13: Int
    let pages: Int
    let year: Int
    let rating: Int
    let desc: String
    let price: Double
    var image: URL?
    var url: URL?
    let pdf: [String]
    
    var asArray: [BookDetailInfo]?
    
    var userNote: UserNote? {
        didSet {
            guard let userNote = userNote else { return }
            
            // update realm
            DispatchQueue.main.async {
                RealmClient.shared.updateUserNote(isbn13: userNote.isbn13, note: userNote.note, date: userNote.date, title: userNote.title)
            }
        }
    }
    
    var count: Int {
        guard let arr = asArray else {
            return 0
        }
        return arr.count
    }
    
    init(_ json: JSON) {
        error = json["error"].intValue
        title = json["title"].stringValue
        subtitle = json["subtitle"].stringValue
        authors = json["authors"].stringValue
        publisher = json["publisher"].stringValue
        isbn10 = json["isbn10"].intValue
        isbn13 = json["isbn13"].intValue
        pages = json["pages"].intValue
        year = json["year"].intValue
        rating = json["rating"].intValue
        desc = json["desc"].stringValue
        price = json["price"].doubleValue
        image = URL(string: json["image"].stringValue)
        url = URL(string: json["url"].stringValue)
        pdf = json["pdf"].arrayValue.map{ $0.stringValue }
        
        asArray = json.map{ ($0.0, $0.1.stringValue) }
    }
    
}
    
