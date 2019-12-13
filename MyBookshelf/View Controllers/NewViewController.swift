//
//  NewViewController.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 10/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import UIKit

class NewViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    struct Constants {
        static let reuseIdentifier = "bookCell"
        static let cellHeight: CGFloat = 160
    }
    
    var indicatorView: UIActivityIndicatorView!
        
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIndicatorView()
        
        BookshelfClient.shared.getNew { books, error in
            if let error = error {
                print("BookshelfClient error in NewViewController: \(error)")
                return
            }
            guard let books = books else { return }
                
            self.books = books
            
            self.indicatorView.stopAnimating()
            self.collectionView.reloadData()
        }
    }

    @IBAction func allnotesButtonTapped(_ sender: Any) {
        
        let noteListController = instaintiateAllNotesViewController()
        navigationController?.pushViewController(noteListController, animated: true)
    }
    
    // MARK: Setter
    
    func setIndicatorView() {
        indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.color = .darkGray
        indicatorView.hidesWhenStopped = true
        collectionView.addSubview(indicatorView)
        indicatorView.frame = collectionView.frame
        indicatorView.startAnimating()
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath) as! BookCell
    
        cell.configure(book: books[indexPath.row])
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(identifier: DetailViewController.storyboardIdentifier) as! DetailViewController
        
        controller.isbn13 = books[indexPath.row].isbn13
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: Convenience
    
    func instaintiateAllNotesViewController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: NoteListViewController.storyboardIdentifier)
            as? NoteListViewController
            else { fatalError("Unable to instantiate an NoteListViewController from the storyboard") }
        
        return controller
    }

}

// MARK: UICollectionViewDelegateFlowLayout

extension NewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: Constants.cellHeight)
    }
}

