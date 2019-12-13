//
//  MyBookshelfTests.swift
//  MyBookshelfTests
//
//  Created by Jae Kyung Lee on 10/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import XCTest
@testable import MyBookshelf

class MyBookshelfTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    
    func testGetBookDetailClient() {
    
        let isbn = "9781617294136"
        
        let promise = expectation(description: "get request should succeed")
        
        BookshelfClient.shared.getBookDetail(isbn: isbn) { detail, error in
            
            if let error = error {
                
              XCTFail("Error: \(error.localizedDescription)")
              return
                
            } else if let detail = detail {
                
                if String(detail.isbn13) != isbn {
                    XCTFail("wrong data received \(detail)")
                    return
                }
                
                promise.fulfill()
                
              } else {
                
                XCTFail("nil value returned")
                
            }
        }
        
        wait(for: [promise], timeout: 5)
        
    }
    
    func testGetSearchResultClient() {
    
        let searchTerm = "swift"
        
        let promise = expectation(description: "request should complete")
        
        BookshelfClient.shared.getSearchResultWithCache(query: searchTerm, page: nil) { result in
            
            if let error = result.error {
                
              XCTFail("Error: \(error.localizedDescription)")
              return
                
            } else if let page = result.page, let books = result.books {
                print("page  \(page), books: \(books) ")
                promise.fulfill()
                
              } else {
                
                XCTFail("nil value returned")
                
            }
        }
        
        wait(for: [promise], timeout: 5)
        
    }
    

    func testsearchBarSearchButtonClickedPerformance() {
        
        let term = "something"
        
        self.measure {
            BookshelfClient.shared.getSearchResultWithCache(query: term, page: nil, completion: { _ in
                
            })
        }
    }

}
