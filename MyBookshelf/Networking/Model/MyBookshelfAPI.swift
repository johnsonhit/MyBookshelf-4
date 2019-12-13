//
//  EndPoint.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 10/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import Foundation

protocol EndPoint {
    var baseUrl: String { get }
    var path: String { get }
    var api: String { get }
}

enum MyBookshelfAPI {
    case new
    case search
    case books
}

extension MyBookshelfAPI: EndPoint {
    
    var baseUrl: String {
        return "https://api.itbook.store/1.0"
    }
    
    var path: String {
        switch self {
        case .new:
            return "/new"
        case .search:
            return "/search"
        case .books:
            return "/books"
        }
    }
    
    var api: String {
        return "\(baseUrl)\(path)"
    }

}
