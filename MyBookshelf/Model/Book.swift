//
//  Book.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 10/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Book {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: Double
    var image: URL?
    var url: URL?
    
    var detail: BookDetail?
    
    init(_ json: JSON) {
        title = json["title"].stringValue
        subtitle = json["subtitle"].stringValue
        isbn13 = json["isbn13"].stringValue
        
        let priceStr = json["price"].stringValue.dropFirst()
        price = Double(priceStr) ?? 0.00
        
        image = URL(string: json["image"].stringValue)
        url = URL(string: json["url"].stringValue)
    }
}
