//
//  NoteListViewController.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 13/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import UIKit

class NoteListViewController: UIViewController {
    
    static let storyboardIdentifier = "NoteListViewController"
    let cellIdentifier = "noteCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var notes: [UserNote]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RealmClient.shared.loadAllUserNotes { allNotes in
            self.notes = allNotes
            self.collectionView.reloadData()
        }
    }

}

extension NoteListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let notes = notes else {
            return 0
        }
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! NoteCell
        
        guard let notes = notes else { return cell }
        cell.configure(userNote: notes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let notes = notes else { return }
        let controller = storyboard?.instantiateViewController(identifier: DetailViewController.storyboardIdentifier) as! DetailViewController
        
        controller.isbn13 = notes[indexPath.row].isbn13
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
}
