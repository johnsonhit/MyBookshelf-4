//
//  BookshelfClient.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 10/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BookshelfClient {
    
    static let shared = BookshelfClient()
    
    // Search result Cache
    private let searchedCache = NSCache<NSString, BookSearchedData>()
    
    func getNew(completion: @escaping ([Book]?, Error?) -> Void) {
        
        AF.request(MyBookshelfAPI.new.api).response { response in
            
            if response.error != nil {
                
                completion(nil, response.error)
                return
                
            } else {
                
                do {
                    var books: [Book] = []
                    
                    let json = try JSON(data: response.data!)
                    for data in json["books"].arrayValue {
                        books.append(Book(data))
                    }
                    completion(books, nil)
                
                } catch let error as NSError {
                    print("convert to json fail in getNew : \(error.debugDescription)")
                    completion(nil, error)
                }
                
            }
            
        }
        
    }
    
    func getBookDetail(isbn: String, completion: @escaping (BookDetail?, Error?) -> Void) {
        
        let requestStr = "\(MyBookshelfAPI.books.api)/\(isbn)"
        
        AF.request(requestStr).response { response in
            
            if response.error != nil {
                
                completion(nil, response.error)
                return
                
            } else {
                
                do {
                    
                    let json = try JSON(data: response.data!)
                    let bookDetail = BookDetail(json)
                    completion(bookDetail, nil)
                
                } catch let error as NSError {
                    print("convert to json fail in getBookDetail : \(error.debugDescription)")
                    completion(nil, error)
                }
                
            }
            
        }
        
    }
    
    private func getSearchResult(requestStr: String, completion: @escaping (BookSearchedData) -> Void) {
        
        AF.request(requestStr).response { response in
            
            if response.error != nil {
                
                completion(BookSearchedData(books: nil, page: nil, error: response.error))
                return
                
            } else {
                
                do {
                    
                    var books: [Book] = []
                    
                    let json = try JSON(data: response.data!)
                    for data in json["books"].arrayValue {
                        books.append(Book(data))
                    }
                    print(json)
                    
                    let cacheObj = BookSearchedData(books: books, page: json["page"].intValue, error: nil)
                    
                    self.searchedCache.setObject(cacheObj, forKey: requestStr as NSString)
                    
                    completion(cacheObj)
                
                } catch let error as NSError {
                    print("convert to json fail in getSearchResult : \(error.debugDescription)")
                    completion(BookSearchedData(books: nil, page: nil, error: error))
                }
                
            }
            
        }
        
    }
    
    func getSearchResultWithCache(query: String,  page: Int?, completion: @escaping (BookSearchedData) -> Void) {
        
        let requestStr = "\(MyBookshelfAPI.search.api)/\(query)\((page != nil) ? "/\(String(page!))" : "")"
        
        if let cache = searchedCache.object(forKey: requestStr as NSString) {
            completion(cache)
            
        } else {
            
            getSearchResult(requestStr: requestStr, completion: completion)
            
        }
        
    }
    
}
