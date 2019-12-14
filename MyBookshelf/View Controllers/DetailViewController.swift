//
//  DetailViewController.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 10/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    static let storyboardIdentifier = "DetailViewController"
    
    struct Constants {
        static let reuseIdentifier = "detailCell"
        static let userNoteKeyValue = "userNote"
        static let urlKeyValue = "url"
        static let cellContentInset: CGFloat = 10
        static let cellMinHeight: CGFloat = 20
        static let fontSize: CGFloat = 15
        static let extraHeight: CGFloat = 17
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var isbn13: String?
    
    var bookDetail: BookDetail?
    
    var bookDetailInfos: [BookDetailInfo]?

    override func viewDidLoad() {
        
        guard let isbn13 = isbn13 else { fatalError("missing isbn13 in detailViewController")}
        super.viewDidLoad()
        
        indicatorView.startAnimating()
        
        BookshelfClient.shared.getBookDetail(isbn: isbn13) { detail, error in
            
            if let error = error {
                print("loadBookDetail error: \(error)")
                return
            } else {
                
                guard let detail = detail else {
                    print("missing book detail data")
                    return
                }
                
                if let userNoteExist = RealmClient.shared.retrieveUserNote(isbn13: String(detail.isbn13)) {
                    self.configure(detail, userNoteExist)
                } else {
                    self.configure(detail)
                }
                
                self.indicatorView.stopAnimating()
                
                self.collectionView.reloadData()
            }
            
        }
    }
    
    private func configure(_ bookDetail: BookDetail, _ userNote: UserNote? = nil) {
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: bookDetail.image)
        
        self.bookDetail = bookDetail

        self.bookDetailInfos = bookDetail.asArray
        
        if let userNote = userNote {
            bookDetailInfos?.append(BookDetailInfo(Constants.userNoteKeyValue, userNote.note))
        }
        
    }
    
    @IBAction func addNoteButtonTapped(_ sender: Any) {
        
        let noteView = instantiateNoteViewController()
        noteView.modalPresentationStyle = .overCurrentContext
        present(noteView, animated: true, completion: nil)
        
    }
    
    
    // MARK: Convenience
    
    private func instantiateNoteViewController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: NoteViewController.storyboardIdentifier)
            as? NoteViewController
            else { fatalError("Unable to instantiate an NoteViewController from the storyboard") }
        
        guard let isbn13 = isbn13 else { fatalError("missing isbn13 detailViewController")}
        controller.isbn13 = isbn13
        controller.delegate = self
        
        return controller
    }
    
    private func calculateCellHeightByWordLength(_ info: BookDetailInfo) -> CGFloat {
        
        let nsText = "\(info.0)  : \(info.1)" as NSString?
        guard let size = nsText?.boundingRect(with: CGSize(width: (view.frame.width - Constants.cellContentInset * 2), height: CGFloat.greatestFiniteMagnitude), options: [.truncatesLastVisibleLine, .usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: Constants.fontSize)], context: nil).size else {
            return .zero
        }

        return size.height < Constants.cellMinHeight ? Constants.cellMinHeight : size.height + Constants.extraHeight
    }
  
}

// MARK: UICollectionViewDataSource

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let infos = bookDetailInfos else { return 0 }

        return infos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath) as! DetailCell
        guard let infos = bookDetailInfos else { return cell }
        
        cell.configure(infos[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let infos = bookDetailInfos else { return }
        if infos[indexPath.row].0 == Constants.urlKeyValue {
            // show web view
            let webViewController = WebViewController()
            webViewController.urlStr = infos[indexPath.row].1
            self.navigationController?.pushViewController(webViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let infos = bookDetailInfos else { return .zero }
        return CGSize(width: view.frame.width, height: calculateCellHeightByWordLength(infos[indexPath.row]))
    }
}

// MARK: NoteViewControllerDelegate

extension DetailViewController: NoteViewControllerDelegate {
    func noteCreated(note: String) {
        
        guard let detail = bookDetail else { return }
        
        self.bookDetail?.userNote = UserNote(isbn13: String(detail.isbn13), note: note, date: Date(), title: detail.title)
        bookDetailInfos?.removeAll{ $0.0 == Constants.userNoteKeyValue }
        bookDetailInfos?.append(BookDetailInfo(Constants.userNoteKeyValue, note))
        self.collectionView.reloadData()
    }
}
