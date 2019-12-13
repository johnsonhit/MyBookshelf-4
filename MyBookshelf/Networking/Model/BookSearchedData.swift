//
//  BookSearchedData.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 12/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import Foundation

class BookSearchedData {
    
    let books: [Book]?
    let page: Int?
    let error: Error?
    
    init(books: [Book]?, page: Int?, error: Error?) {
        self.books = books
        self.page = page
        self.error = error
    }
    
}
