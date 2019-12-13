//
//  SearchViewController.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 11/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inticatorView: UIActivityIndicatorView!
    
    struct Constants {
        static let reuseIdentifier = "bookCell"
        static let searchPlaceholder = "search"
        static let cellHeight: CGFloat = 160
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var indicatorView: UIActivityIndicatorView!

    let books = SearchViewModel()
    
    let operationQueue = OperationQueue()
      
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchController()
        setIndicatorView()
        books.delegate = self
    }
    
    // MARK: settter
    
    func setSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchPlaceholder
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    func setIndicatorView() {
        indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.color = .darkGray
        indicatorView.hidesWhenStopped = true
        collectionView.addSubview(indicatorView)
        indicatorView.frame = collectionView.frame
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return books.numberOfBooks
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath) as! BookCell
        
        if let book = books.loadBook(indexPath.row) {
            cell.configure(book: book)
        } else {
            cell.configure(book: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(identifier: DetailViewController.storyboardIdentifier) as! DetailViewController
        
        if let book = books.loadBook(indexPath.row) {
            controller.isbn13 = book.isbn13
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: Constants.cellHeight)
    }
    
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            if let operation = self.books.loadOperation(index: indexPath.row) {
                
                self.operationQueue.addOperation(operation)
                
            }
            
        }
        
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        collectionView.backgroundView = nil
        indicatorView.startAnimating()
        guard let query = searchBar.text else { return }
        
        books.searchBooks(query: query, page: nil) { success in
            self.indicatorView.stopAnimating()
            
            if success {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                self.collectionView.reloadData()
            } else {
                
                self.collectionView.setBackgroundView()
            }
        }
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func updateView(indexes: [Int]?) {

        if let indexes = indexes  {
            let indexPath = indexes.map{ IndexPath(item: $0, section: 0) }
            self.collectionView.reloadItems(at: visibleIndexPathsToReload(intersecting: indexPath))
        } else {
            
            self.inticatorView.stopAnimating()
            self.collectionView.reloadData()
        }
    }

    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
