//
//  DetailCell.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 11/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import UIKit

class DetailCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func configure(_ info: BookDetailInfo) {
        label.text =  "\(info.0)  : \(info.1)"
        if info.0 == "url" {
            label.isHighlighted = true
        }
        if info.0 == "userNote" {
            backgroundColor = .yellow
        }
    }
    
    override func prepareForReuse() {
        label.text = nil
        backgroundColor = .white
        label.isHighlighted = false
    }
}
