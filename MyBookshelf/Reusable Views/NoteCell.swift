//
//  NoteCell.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 13/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import UIKit

class NoteCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    func configure(userNote: UserNote) {
        dateLabel.text = userNote.date.description
        bookTitleLabel.text = userNote.title
    }
}
