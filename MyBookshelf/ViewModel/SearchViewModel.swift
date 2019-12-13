//
//  BookData.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 11/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import Foundation

protocol SearchViewModelDelegate {
    func updateView(indexes: [Int]?)
}

class SearchViewModel {
    
    var delegate: SearchViewModelDelegate?
    
    var query: String?
    
    var currentPage: Int?
    
    var noNextPage = false
    
    private var books: [Book] = []
    
    public var numberOfBooks: Int {
        return books.count
    }
    
    public func loadBook(_ index: Int) -> Book? {
        
        if index < numberOfBooks {
            return books[index]
        }
        return nil
    }
    
    public func loadOperation(index: Int) -> LoadMoreBooksOperation? {
        
        if index > numberOfBooks - 2 {
            
            guard let strongQuery = query else { return nil }
            
            let nextPage = (currentPage == nil) ? nil : currentPage! + 1
            
            let operation = LoadMoreBooksOperation(query: strongQuery, page: nextPage)
            
            operation.loadingCompleteHandler = { books, page in
                guard let strongBooks = books else {
                    return
                }
                if page == nil {
                    self.noNextPage = true
                }
                
                self.books += strongBooks
                self.currentPage = page
                
                self.delegate?.updateView(indexes: Array(index..<self.numberOfBooks))
            }
            
            return operation
            
        } else {
            
            return nil
        }
    }
    
    public func searchBooks(query: String, page: Int?, completion: @escaping (Bool) -> Void) {
        
        self.query = query
        self.currentPage = page
        
        BookshelfClient.shared.getSearchResultWithCache(query: query, page: page) { result in
            
            self.currentPage = result.page
            
            guard let books = result.books else {
                print("missing  loadMoreBooks in SearchBookResult" )
                completion(false)
                return
            }
            
            self.books = books
            
            completion(books.count > 0)
        }
    }
 
}

class LoadMoreBooksOperation: Operation {
    
    var query: String?
    var page: Int?
    
    var loadingCompleteHandler : (([Book]?, Int?) -> Void)?
    
    init(query: String, page: Int?) {
        self.query = query
        self.page = page
    }
    
    override func main() {
        
        if isCancelled { return }
        
        guard let strongQuery = query else { return }
        
        BookshelfClient.shared.getSearchResultWithCache(query: strongQuery, page: page) { result in
            
            guard let books = result.books else {
                print("missing  loadMoreBooks in SearchBookREsult" )
                return
            }
            
            if let loadingCompleteHandler = self.loadingCompleteHandler {
                DispatchQueue.main.async {
                    loadingCompleteHandler(books, result.page)
                }
            }
        }
    }
}
