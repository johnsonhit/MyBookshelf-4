//
//  BookCell.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 10/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import UIKit
import Kingfisher

class BookCell: UICollectionViewCell {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var isbn: UILabel!
    @IBOutlet weak var price: UILabel!
    
    var book: Book?
    
    override func awakeFromNib() {
      super.awakeFromNib()
      
      indicatorView.hidesWhenStopped = true
    }
    
    func configure(book: Book?) {
        
        if let book = book {
            
            self.book = book
            
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: book.image)
            title.text = book.title
            subTitle.text = book.subtitle
            isbn.text = book.isbn13
            price.text = "$\(String(book.price))"
            
            title.alpha = 1
            subTitle.alpha = 1
            isbn.alpha = 1
            price.alpha = 1
            
            indicatorView.stopAnimating()
            
        } else {
            
            title.alpha = 0
            subTitle.alpha = 0
            isbn.alpha = 0
            price.alpha = 0
            
            indicatorView.startAnimating()
            
        }
        
    }
    
}
